//
//  SpeechView.swift
//  HKCoure
//
//  Created by Andres Rodriguez on 16/04/20.
//  Copyright © 2020 Sebastian. All rights reserved.
//

import SwiftUI
import Speech
import UIKit

struct SpeechView: View {
    
    @State private var grabando: Bool = false
    @EnvironmentObject var store: Store
    @State private var arreglo: [Any] = []
    @State private var alFinal = false
    @State private var autoriza = true
    @State private var titulo = "Primero"
    @State private var input: String = ""
    @State private var textoGrabando = ""
    @State private var i = 14
    @State private var speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "es-ES"))
    @State private var isRecording: Bool = false
    
    @ObservedObject var speech = SwiftUISpeech()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var audioEngine = AVAudioEngine()
    
    var body: some View {
        
        VStack(alignment: .center){
            
            Spacer()
            Text("Campo actual:").padding(.all, 20)
            Text(self.titulo).font(.system(size: 45, weight: .bold)).foregroundColor(.black)

            TextField("Ingrese la información del campo",text: self.$input)
                    .frame(height: nil)
                .multilineTextAlignment(.center)
                
            
            Spacer()
            Text(self.textoGrabando)
                .padding(.bottom, 5)
                .foregroundColor(.red)
                .disabled(true)
            HStack(alignment: .center){
                Button(action: {
                    self.anterior()
                }) {
                    HStack{
                        
                        Image(systemName: "chevron.left")
                        Text("Anterior")
                    }
                    
                    
                }.padding(.horizontal, 30).disabled(self.grabando == true)
                Button(action: {
                    if self.grabando == false{
                        self.textoGrabando = "Grabando..."
                        self.grabando = true
                        self.speech.startRecording()
                        
                    }
                    else{
                        self.textoGrabando = ""
                        self.grabando = false
                        self.speech.stopRecording()
                        self.input = self.speech.outputText
                        //sleep(4)
                        self.siguiente()
                    }
                    //self.requestTranscribePermissions()
                    
                }) {
                    Image(systemName: "mic.fill").foregroundColor(.primaryWhite).font(.system(size: 25))
                }.buttonStyle(DarkButtonStyle2(paddingHorizontal: 18))
                Button(action: {
                    self.siguiente()
                }) {
                    HStack{
                        
                        Text("Siguiente")
                        Image(systemName: "chevron.right")
                    }
                }.padding(.horizontal, 30).disabled(self.grabando == true)
            }
            Button(action: {
                self.speech.stopRecording()
                self.store.speechView = false
                self.store.addPacien = true
                self.store.wasSpeeching = true
                self.arreglo[self.i + 1] = self.input as! String
                self.store.arregloFormulario = self.arreglo
                }) {
                    HStack{
                        
                        Image(systemName: "arrow.turn.up.left")
                        Text("Volver")
                    }
                    
            }.padding(.top, 15).disabled(self.grabando == true)
            Spacer()
            
        }.onAppear(
            perform: self.cargarArreglo).padding(.all, 20)
    }
    
    
    func estarActualizando(){
        while self.grabando{
            self.input = self.speech.outputText
        }
    }
    
    // Inicializa el arreglo
    func cargarArreglo()
    {
        self.arreglo = self.store.arregloFormulario
        self.titulo = self.arreglo[self.i] as! String
        self.input = self.arreglo[self.i + 1] as! String
    }
    
    // Pasa al anterior campo del dictado de voz
    func siguiente(){
        if i < (self.arreglo.count - 2)
        {
            self.arreglo[self.i + 1] = self.input as! String
            self.i = self.i + 2
            self.titulo = self.arreglo[self.i] as! String
            self.input = self.arreglo[self.i + 1] as! String
        }
    }
    
    // Pasa al siguiente campo del dictado de voz
    func anterior(){

        if i > 14
        {
            self.arreglo[self.i + 1] = self.input as! String
            self.i = self.i - 2
            self.titulo = self.arreglo[self.i] as! String
            self.input = self.arreglo[self.i + 1] as! String
            
        }
    }
    
}
