//
//  TextRecognition.swift
//  HKCoure
//
//  Created by Sebastian on 2/28/20.
//  Copyright © 2020 Sebastian. All rights reserved.
//

import SwiftUI
import Vision
import VisionKit


struct TextRecognitionView: UIViewControllerRepresentable {
        
    var image: UIImage = UIImage()
    
    @Binding var didFinishPicker: Bool
        
    func startProcessingImage() -> Void {
        let txtRecognizer = VisionController()
        txtRecognizer.singleTextRecognitionQueue(img: self.image)
    }
    
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<TextRecognitionView>) -> UIViewController {
        let picker: UIImagePickerController = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        return picker
    }
    
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<TextRecognitionView>) { }
    
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: TextRecognitionView
        init(parent: TextRecognitionView) {
            self.parent = parent
        }
        
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selected = info[.editedImage] as? UIImage {
                self.parent.image = selected
                self.parent.startProcessingImage()
            }
            self.parent.didFinishPicker = true
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
        
    }
    
}

