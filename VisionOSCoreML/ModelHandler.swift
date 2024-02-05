//
//  ModelHandler.swift
//  VisionOSCoreML
//
//  Created by 間嶋大輔 on 2024/02/05.
//
import SwiftUI
import Vision

class ModelHandler: ObservableObject {
    @Published var resultImage: UIImage?
    private var request: VNCoreMLRequest!

    init() {
        setupModel()
    }

    private func setupModel() {
        guard let model = try? VNCoreMLModel(for: animegan2face_paint_512_v2().model) else {
            fatalError()
        }

        self.request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
            guard let results = request.results, let firstResult = results.first as? VNPixelBufferObservation else {
                return
            }
            let ciImage = CIImage(cvPixelBuffer: firstResult.pixelBuffer)
            let context = CIContext()
            guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return }
            DispatchQueue.main.async {
                self?.resultImage = UIImage(cgImage: cgImage)
            }
        })
    }

    func processImage(_ uiImage: UIImage) {
        guard let ciImage = CIImage(image: uiImage) else {
            fatalError()
        }
        
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try handler.perform([self.request])
            } catch {
                fatalError()
            }
        }
    }
}
