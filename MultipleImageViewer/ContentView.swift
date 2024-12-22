//
//  ContentView.swift
//  MultipleImageViewer
//
//  Created by Benji Loya on 22.12.2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
       /// navigation Stack is must as this uses the zoom Transition API
        NavigationStack {
            VStack {
                ImageViewer {
                    ForEach(sampleImages) { image in
                        AsyncImage(url: URL(string: image.link)) { image in
                            image
                                .resizable()
                            /// Fit/Fill resize will be done inside the image viewer
                        } placeholder: {
                            Rectangle()
                                .fill(.gray.opacity(0.25))
                                .overlay {
                                    ProgressView()
                                        .tint(.primary.opacity(0.6))
                                        .scaleEffect(0.7)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                }
                        }
                        .containerValue(\.activeViewID, image.id)
                    }
                } overlay: {
                    OverlayView()
                }
            }
            .padding(15)
            .navigationTitle("Image Viewer")
        }
    }
}

#Preview {
    ContentView()
}


/// Overlay View
struct OverlayView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .foregroundStyle(.ultraThinMaterial)
                    .padding(10)
                    .contentShape(.rect)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer(minLength: 0)
        }
        .padding(15)
    }
}

