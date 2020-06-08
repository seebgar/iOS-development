//
//  VisionController.swift
//  HKCoure
//
//  Created by Sebastian on 2/29/20.
//  Copyright © 2020 Sebastian. All rights reserved.
//

import SwiftUI
import Vision
import VisionKit

class VisionController {
            
    @EnvironmentObject var store: Store
    var textRecognitionRequest = VNRecognizeTextRequest()
    private var list: [String] = []
    
    init() {
        self.configureRecognizer()
    }
    
    func configureRecognizer() -> Void {
        textRecognitionRequest = VNRecognizeTextRequest(completionHandler: { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            for someObservation in observations {
                let topCandidate = someObservation.topCandidates(1)
                if let recognizedText = topCandidate.first {
                    print("\(recognizedText.string)")
                    self.list.append(recognizedText.string)
                }
            }
        })
        textRecognitionRequest.recognitionLevel = .accurate
        textRecognitionRequest.usesLanguageCorrection = false
        textRecognitionRequest.customWords = ["NUMERO", "APELLIDOS", "NOMBRES", "FIRMA", "REPUBLICA", "COLOMBIA", "CEDULA", "CIUDADANIA"]
        textRecognitionRequest.usesCPUOnly = true
        textRecognitionRequest.recognitionLanguages = ["es-ES"]
    }
    
    func singleTextRecognitionQueue(img: UIImage) -> Void {
        DispatchQueue.global(qos: .userInitiated).async {
            self.processImage(img: img)
            recognizedTextResults = self.list
            print("--> Lista")
            print(recognizedTextResults)
        }
    }
    
    
    func documentTextRecognitionQueue(scan: VNDocumentCameraScan) -> Void {
        DispatchQueue.global(qos: .userInitiated).async {
            for pageIndex in 0..<scan.pageCount {
                let image = scan.imageOfPage(at: pageIndex)
                self.processImage(img: image)
            }
            recognizedTextResults = self.selectData(arr: self.list)
            print("--> Lista")
            print(recognizedTextResults)
        }
    }
    
    
    private func processImage(img: UIImage) -> Void {
        guard let image = img.cgImage else { return }
        let requests = [textRecognitionRequest]
        let handler = VNImageRequestHandler(cgImage: image, options: [:])
        do {
            try handler.perform(requests)
        } catch {
            print("*--> Error processing image.")
            print(error)
            return
        }
    }
    
    func selectData(arr: [String])-> [String]{
        let size = arr.count
        var ced = ""
        var ape = ""
        var nom = ""
        var fech = ""
        var lug = ""
        var est = ""
        var san = ""
        var sex = ""
        var aux = ""
        for i in (0..<size){
            if String(arr[i]).contains("NUMERO"){
                aux = String(arr[i+1]).replacingOccurrences(of: "NUMERO", with: "")
                aux = aux.replacingOccurrences(of: ".", with: "")
                aux = aux.replacingOccurrences(of: " ", with: "")
                ced = aux
            }
            else if String(arr[i]).contains("APELLIDOS"){
                aux = String(arr[i-1])
                ape = aux
            }
            else if String(arr[i]).contains("NOMBRES"){
                aux = String(arr[i-1])
                nom = aux
            }
            else if String(arr[i]).contains("FECHA DE NACIMIENTO"){
                if String(arr[i+1]).contains("-"){
                    var aux2 = String(arr[i+1]).components(separatedBy: "-")
                    if aux2[1] == "ENE"{aux2[1] = "01"}
                    else if aux2[1] == "FEB"{aux2[1] = "02"}
                    else if aux2[1] == "MAR"{aux2[1] = "03"}
                    else if aux2[1] == "ABR"{aux2[1] = "04"}
                    else if aux2[1] == "MAY"{aux2[1] = "05"}
                    else if aux2[1] == "JUN"{aux2[1] = "06"}
                    else if aux2[1] == "JUL"{aux2[1] = "07"}
                    else if aux2[1] == "AGO"{aux2[1] = "08"}
                    else if aux2[1] == "SEP"{aux2[1] = "09"}
                    else if aux2[1] == "OCT"{aux2[1] = "10"}
                    else if aux2[1] == "NOV"{aux2[1] = "11"}
                    else if aux2[1] == "DIC"{aux2[1] = "12"}
                    fech = "\(aux2[0])/\(aux2[1])/\(aux2[2])"
                }
            }
            else if String(arr[i]).contains("LUGAR DE NACIMIENTO"){
                lug = String(arr[i-2])
            }
            else if String(arr[i]).contains("ESTATURA"){
                est = String(arr[i-3])
            }
            else if String(arr[i]).contains("G.S"){
                san = String(arr[i-3])
            }
            else if String(arr[i]).contains("SEXO"){
                sex = String(arr[i-3])
            }
            
        }
        
        return [ced, ape, nom, fech, lug, est, san, sex]
    }
    
}
