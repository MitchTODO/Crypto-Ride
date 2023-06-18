
export const soulNameRouter: Router = express.Router();
soulNameRouter.post(
    "/store",
    async (request: Request, response: Response): Promise<void> => {

    }
);

app.use("/soul-name",soulNameRouter);