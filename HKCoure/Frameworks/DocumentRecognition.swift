//
//  DocumentRecognition.swift
//  HKCoure
//
//  Created by Sebastian on 2/29/20.
//  Copyright © 2020 Sebastian. All rights reserved.
//

import SwiftUI
import UIKit
import Vision
import VisionKit

struct DocumentRecognitionView: UIViewControllerRepresentable {
    
    @Binding var didFinishCamera: Bool
    
    func startProcessingImage(scan: VNDocumentCameraScan) -> Void {
        print("--> Inicia Procesamiento")
        let txtRecognizer = VisionController()
        txtRecognizer.documentTextRecognitionQueue(scan: scan)
    }
    
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentRecognitionView>) -> VNDocumentCameraViewController {
        print("--> Se mostrara la camara")
        let visionCamera = VNDocumentCameraViewController()
        visionCamera.delegate = context.coordinator
        return visionCamera
    }
    
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: UIViewControllerRepresentableContext<DocumentRecognitionView>) { }
    
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    
    final class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        var parent: DocumentRecognitionView
        
        init(parent: DocumentRecognitionView) {
            print("--> Se incializa el coordinator")
            self.parent = parent
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            print("--> Document scanned:: ")
            print(scan)
            self.parent.startProcessingImage(scan: scan)
            self.parent.didFinishCamera = true
            controller.dismiss(animated: true)
        }
        
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            controller.dismiss(animated: true)
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            print("*--> Error escaneando documento con camara")
            print(error)
            controller.dismiss(animated: true)
        }
        
    }
    
}
