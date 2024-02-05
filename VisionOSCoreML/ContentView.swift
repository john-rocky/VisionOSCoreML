//
//  ContentView.swift
//  VisionOSCoreML
//
//  Created by 間嶋大輔 on 2024/02/05.
//

import SwiftUI

struct ContentView: View {
    @State private var inputImage: UIImage = UIImage(named: "myFace")!
    @ObservedObject var modelHandler = ModelHandler()

    var body: some View {
        VStack {
                Image(uiImage: inputImage)
                    .resizable()
                    .scaledToFit()
            
            if let resultImage = modelHandler.resultImage {
                Image(uiImage: resultImage)
                    .resizable()
                    .scaledToFit()
            }
            Button("ToAnime") {
                modelHandler.processImage(inputImage)
            }
        }
        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
