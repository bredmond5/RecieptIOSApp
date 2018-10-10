//
//  OCRService.swift
//  RecieptApp
//
//  Created by Brice Redmond on 9/21/18.
//  Copyright © 2018 Brice Redmond. All rights reserved.
//

import TesseractOCR

protocol OCRServiceDelegate: class {
    func ocrService(_ service: OCRService, didDetect text: String)
}

 class OCRService {
    private let tesseract = G8Tesseract(language: "eng")!
    
    weak var delegate: OCRServiceDelegate?
    
    init() {
        tesseract.engineMode = .tesseractOnly
        tesseract.pageSegmentationMode = .singleBlock
    }
    
    func handle(image: UIImage) {
        handleWithTesseract(image: image)
    }
    
    private func handleWithTesseract(image: UIImage) {
        tesseract.image = image.g8_blackAndWhite()
        tesseract.recognize()
        let text = tesseract.recognizedText ?? ""
        
        delegate?.ocrService(self, didDetect: text)
    }
}
