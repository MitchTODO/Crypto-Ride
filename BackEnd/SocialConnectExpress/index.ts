// Import the express in typescript file
import express, { Express, RequestHandler, Response, Router } from "express";
import bodyParser from 'body-parser';

import {
  MasaSessionMiddleware,
  MasaSessionRouter,
  sessionCheckHandler,
} from "@masa-finance/masa-express";

import {
  CreateSoulNameResult,
  SoulNameErrorCodes,
} from "@masa-finance/masa-sdk";

import cors from "cors";
//import { storeSoulName } from "./store-soul-name";

import { OdisUtils } from '@celo/identity';

import {
    AuthSigner,
    OdisContextName,
    ServiceContext,
  } from "@celo/identity/lib/odis/query";

import { ContractKit, newKit } from "@celo/contractkit";
import { Account } from "web3-core";


// Initialize the express engine
const app: express.Application = express();
app.use(bodyParser.urlencoded({extended:false}));
app.use(bodyParser.json())
 
// Take a port 3000 for running server.
const port: number = 3000;
const sessionName = "my_fancy_session_name";
const secret = "top_secret_1337";
const ttl = 30 * 24 * 60 * 60;
const environment = "dev";
const domain = "localhost";
const sessionNamespace = "a7d2c862-b332-4f70-86db-ab32f61c6574";
/*
app.use(cors({
    origin:domain,
    credentials:true,
  })
);

const sessionMiddleware:RequestHandler = MasaSessionMiddleware({
  sessionName,
  secret,
  domain,
  ttl,
  environment,
});

app.use(
  "/session",
  MasaSessionRouter({
    sessionMiddleware,
    sessionName,
    sessionNamespace,
  })
);

export const soulNameRouter:Router = express.Router();
soulNameRouter.use(sessionMiddleware);
soulNameRouter.use(sessionCheckHandler as never);

soulNameRouter.post(
  "/soul-name/store",
  (request, response) => {
    const result: CreateSoulNameResult = {
      success: false,
      message: "Hello world!",
      errorCode: SoulNameErrorCodes.UnknownError,
    };
    console.log(result);
    response.json(result);
  }
);
app.use(soulNameRouter);
*/
// Social Connect number look up
app.get('/number/:number', async (_req, _res)  =>  {
    try {
        const kit = await newKit(ALFAJORES_RPC);
        const asv2 = new ASv2(kit);
        _res.send(await asv2.lookupAddresses(_req.params.number));
    }catch(err) {
        console.log(err);
        _res.send(err)
    }
});
// Social Connect number register
app.post('/register', async (_req,_res) => {
    const kit = await newKit(ALFAJORES_RPC);
    const asv2 = new ASv2(kit);
    const timeAttestationWasVerified = Math.floor(new Date().getTime() / 1000);
    try {
        let value = await asv2.registerAttestation(_req.body.phone,_req.body.account, timeAttestationWasVerified);
        console.log(value);
        _res.send(value);
    }catch(err) {
        console.log(err);
        _res.send(err);
    }    
});
 
// Server setup
app.listen(port, () => {
    console.log(`TypeScript with Express
         http://localhost:${port}/`);
});


/** Hard Coded **/
const ALFAJORES_RPC = "https://alfajores-forno.celo-testnet.org";
const ISSUER_PRIVATE_KEY = "0x726e53db4f0a79dfd63f58b19874896fce3748fcb80874665e0c147369c04a37";

class ASv2 {
  kit: ContractKit;
  issuer: Account;
  authSigner: AuthSigner;
  serviceContext: ServiceContext

  constructor(kit: ContractKit) {
    this.kit = kit;
    this.issuer = kit.web3.eth.accounts.privateKeyToAccount(ISSUER_PRIVATE_KEY);
    this.kit.addAccount(ISSUER_PRIVATE_KEY);
    this.kit.defaultAccount = this.issuer.address;
    this.serviceContext = OdisUtils.Query.getServiceContext(OdisContextName.ALFAJORES);

    this.authSigner = {
      authenticationMethod: OdisUtils.Query.AuthenticationMethod.WALLET_KEY,
      contractKit: this.kit,
    };
  }

  async registerAttestation(phoneNumber: string, account: string, attestationIssuedTime: number) {
    await this.checkAndTopUpODISQuota();

    // get identifier from phone number using ODIS
    const {obfuscatedIdentifier} = await OdisUtils.Identifier.getObfuscatedIdentifier(
      phoneNumber,
      OdisUtils.Identifier.IdentifierPrefix.PHONE_NUMBER,
      this.issuer.address,
      this.authSigner,
      this.serviceContext
    )

    const federatedAttestationsContract = await this.kit.contracts.getFederatedAttestations();

    // upload identifier <-> address mapping to onchain registry
    await federatedAttestationsContract
      .registerAttestationAsIssuer(obfuscatedIdentifier, account, attestationIssuedTime)
      .send();
  }

  async lookupAddresses(phoneNumber: string) {
    // get identifier from phone number using ODIS
    const {obfuscatedIdentifier} = await OdisUtils.Identifier.getObfuscatedIdentifier(
      phoneNumber,
      OdisUtils.Identifier.IdentifierPrefix.PHONE_NUMBER,
      this.issuer.address,
      this.authSigner,
      this.serviceContext
    )

    const federatedAttestationsContract = await this.kit.contracts.getFederatedAttestations();

    // query on-chain mappings
    const attestations = await federatedAttestationsContract.lookupAttestations(
      obfuscatedIdentifier,
      [this.issuer.address]
    );

    return attestations.accounts;
  }

  private async checkAndTopUpODISQuota() {

    //check remaining quota
    const { remainingQuota } = await OdisUtils.Quota.getPnpQuotaStatus(
      this.issuer.address,
      this.authSigner,
      this.serviceContext
    );

    console.log("remaining ODIS quota", remainingQuota);
    if (remainingQuota < 1) {
      const stableTokenContract = await this.kit.contracts.getStableToken();
      const odisPaymentsContract = await this.kit.contracts.getOdisPayments();

      // give odis payment contract permission to use cUSD
      const currentAllowance = await stableTokenContract.allowance(
        this.issuer.address,
        odisPaymentsContract.address
      );

      console.log("current allowance:", currentAllowance.toString());
      let enoughAllowance: boolean = false;

      const ONE_CENT_CUSD_WEI = this.kit.web3.utils.toWei("0.01", "ether");

      if (currentAllowance.lt(ONE_CENT_CUSD_WEI)) {
        const approvalTxReceipt = await stableTokenContract
          .increaseAllowance(
            odisPaymentsContract.address,
            ONE_CENT_CUSD_WEI
          )
          .sendAndWaitForReceipt();
        
        enoughAllowance = approvalTxReceipt.status;
      } else {
        enoughAllowance = true;
      }

      // increase quota
      if (enoughAllowance) {
        const odisPayment = await odisPaymentsContract
          .payInCUSD(this.issuer.address, ONE_CENT_CUSD_WEI)
          .sendAndWaitForReceipt();
        console.log("odis payment tx status:", odisPayment.status);
        console.log("odis payment tx hash:", odisPayment.transactionHash);
      } else {
        throw "cUSD approval failed";
      }
    }
  }
}
