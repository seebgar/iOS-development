//
//  Store.swift
//  HKCoure
//
//  Created by Sebastian on 2/28/20.
//  Copyright © 2020 Sebastian. All rights reserved.
//


import UIKit
import Combine
import FirebaseAuth
import Firebase

class Store: NSObject, ObservableObject {
    let didChange = ObservableObjectPublisher()
    
    @Published var showSubscriptionForm: Bool = false {
        willSet {
            didChange.send()
        }
    }
    
    @Published var textRecognitionResults: [String] = [] {
        willSet {
            didChange.send()
        }
    }
    
    @Published var isLogged: Bool = false {
        willSet {
            didChange.send()
        }
    }
    
    @Published var isPacient: Bool = false {
        willSet {
            didChange.send()
        }
    }
    
    @Published var visionTextResults: [String] = [] {
        willSet {
            didChange.send()
        }
    }
    
    @Published var procesandoTexto: Bool = false {
        willSet {
            didChange.send()
        }
    }
    
    @Published var addPacien: Bool = false {
        willSet {
            didChange.send()
        }
    }
    
    @Published var showPacienteDetail: Bool = false {
        willSet {
            didChange.send()
        }
    }
    
    @Published var cedulaPacienteActual: String = "" {
        willSet {
            didChange.send()
        }
    }
    
    @Published var listView: Bool = false {
        willSet {
            didChange.send()
        }
    }
    @Published var preguntasSistemaView: Bool = false{
        willSet {
            didChange.send()
        }
    }
    
    @Published var tiposAnalyticsView: Bool = false{
        willSet{
            didChange.send()
        }
    }
    
    @Published var preguntasDemograficasView: Bool = false{
        willSet{
            didChange.send()
        }
    }
    
    @Published var preguntasOperativasView: Bool = false{
        willSet{
            didChange.send()
        }
    }
    
    @Published var alarmView : Bool = false{
        willSet{
            didChange.send()
        }
    }
    
    @Published var pacienteActual: PacienteHK = PacienteHK(cedula: 1, estatura: 1, fechNaci: Date(), lugar: "lugar", motivo: "motivo", nombre: "nombre", sexo: "M", telefono: 1, tipoSangre: "0+", alergias: "alergias", pulso:1, saturacion: 1, sintomas: "sintomas", temperatura: 1, tension: "tension", triaje: 1, area:"area", visitas: 0, estado: "0"){
        willSet {
            didChange.send()
        }
    }
    
    @Published var serachView: Bool = false{
        willSet {
            didChange.send()
        }
    }
    
    @Published var speechView: Bool = false{
        willSet {
            didChange.send()
        }
    }
    
    @Published var wasSpeeching: Bool = false{
        willSet{
            didChange.send()
        }
    }
    
    
    @Published var searchPacientDetail: Bool = false{
        willSet{
            didChange.send()
        }
    }
    
    @Published var arregloFormulario: [Any] = []{
        willSet{
            didChange.send()
        }
    }
    
    
}
