//
//  WalletQRCodeView.swift
//  Crypto-Ride
//
//  Created by mitchell tucker on 7/8/23.
//

import SwiftUI
import Foundation
import BigInt
import CoreImage.CIFilterBuiltins
import web3swift
import PhotosUI
import CoreTransferable

struct WalletQRCodeView: View {
    // Wallet address
    let address:String
    let phoneNumber:String
    
    @State var showAddress = false
    // Qr code generator
    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()
    
    init(address:String, phone:String) {
        self.address = address
        if phone.isEmpty {showAddress = true}
        self.phoneNumber = phone
    }
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                if showAddress {
                    UIPasteboard.general.string = address
                } else {
                    UIPasteboard.general.string = phoneNumber
                }
                
            }, label: {
                Image(uiImage:generateQRCode(from: address))
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .padding()
                    .frame(width: 130, height: 130)
                
            })
            .buttonStyle(.borderedProminent)
            Spacer()
        }
        Button(action: {
            // if empty dont show phone number
            if !phoneNumber.isEmpty {
                showAddress.toggle()
            }
            
        }, label: {
            if showAddress {
                Text(address)
                    .font(.subheadline)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }else{
                Text(phoneNumber)
                    .font(.subheadline)
                
            }
        })
    }
    
    
    // MARK: generateQRCode
    /// Encodes string data as a qr code in a UIImage
    ///
    /// - Parameters:
    ///         - `from string` String containing ethereum address
    ///
    /// - Returns:
    ///         - `UIImage` uiimage containing the qr code
    ///
    func generateQRCode(from string: String) -> UIImage {
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")
        if let qrCodeImage = filter.outputImage {
            if let qrCodeCGImage = context.createCGImage(qrCodeImage, from: qrCodeImage.extent) {
                return UIImage(cgImage: qrCodeCGImage)
            }
        }
        return UIImage(systemName: "xmark") ?? UIImage()
    }
    

}

struct WalletQRCodeView_Previews: PreviewProvider {
    static var previews: some View {
        WalletQRCodeView(address: "0x6863A73D537e37D366388965f01F42454f66F52c",phone: "+4 555 444 6666")
    }
}
