//
//  ProfileImage.swift
//  CryptoRide-Driver
//
//  Created by mitchell tucker on 6/6/23.
//

import SwiftUI
import PhotosUI

struct ProfileImage: View {
    let imageState: ProfileModel.ImageState
    let systemImage:String
    
    var body: some View {
        switch imageState {
        case .success(let image):
            image.resizable()
        case .loading:
            ProgressView()
        case .empty:
            Image(systemName: systemImage)
                .font(.system(size: 40))
                .foregroundColor(.white)
        case .failure:
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(.white)
        }
    }
}


struct CircularProfileImage: View {
    let imageState: ProfileModel.ImageState
    let systemImage:String
    
    var body: some View {
        ProfileImage(imageState: imageState, systemImage: systemImage)
            .scaledToFill()
            .clipShape(Circle())
            .frame(width: 100, height: 100)
            .background {
                Circle().fill(
                    LinearGradient(
                        colors: [.yellow, .orange],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        }
    }
}


struct CircularProfileImageDL: View {
    @EnvironmentObject var viewModel: ProfileModel
    let systemImage:String
    
    var body: some View {
        CircularProfileImage(imageState: viewModel.imageState, systemImage: systemImage)
    }
}


struct EditableCircularProfileImage: View {
    @EnvironmentObject var viewModel: ProfileModel
    let systemImage:String
    
    var body: some View {
        CircularProfileImage(imageState: viewModel.imageState, systemImage: systemImage)
            .overlay(alignment: .bottomTrailing) {
                PhotosPicker(selection: $viewModel.imageSelection,
                             matching: .images,
                             photoLibrary: .shared()) {
                    Image(systemName: "pencil.circle.fill")
                        .symbolRenderingMode(.multicolor)
                        .font(.system(size: 30))
                        .foregroundColor(.accentColor)
                }
                .buttonStyle(.borderless)
        }
    }
}
