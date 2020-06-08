//
//  FormView.swift
//  HKCoure
//
//  Created by Andres Rodriguez on 4/04/20.
//  Copyright © 2020 Sebastian. All rights reserved.
//

import SwiftUI
import CoreData
import FirebaseDatabase
import Foundation
import UIKit
import Network

struct FormView: View{
    
    @EnvironmentObject var store: Store
    let defaults = UserDefaults.standard
    
    @State private var didFinishCamera: Bool = false
    @State private var showSheet: Bool = false
    @ObservedObject var limiteCedula = TextBindingManager(limit: 10)
    
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @State private var alert: Bool = false
    @State private var alertForm: Bool = false
    @State private var msg: String = ""
    @State private var conexion: Bool = false
    @State private var alertCedula: Bool = false
    @State private var alertError: Bool = false
    @State private var alertGuardado: Bool = false
    @State private var terminaLectura:Bool = false
    
    @State private var arreglo = ["Cedula", "", "Nombres", "", "Fecha", Date(),"Lugar de nacimiento","", "Estatura", "", "Tipo de Sangre","", "Sexo", "", "Telefono", "", "Motivo", "", "Alergias", "", "Pulso", "",  "Respiración", "", "Temperatura", "", "Tensión", "" ,"Área", "", "Triaje", ""] as [Any]
    
    @State private var cedula = ""
    @State private var nombres = ""
    @State private var fechNaci = Date()
    @State private var lugar = ""
    @State private var estatura = ""
    @State private var tipoSangre = ""
    @State private var sexo = ""
    @State private var telefono = ""
    
    @State private var motivo = ""
    @State private var sintomas = ""
    @State private var pulso = ""
    @State private var respiracion = ""
    @State private var temperatura = ""
    @State private var tension = ""
    @State private var area = ""
    @State private var alergias = ""
    @State private var triaje = ""
    @State private var miliTime: Int = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView{
            
            Form {
                Section(header: Text("Información del paciente").onReceive(timer){time in self.miliTime+=1}){
                    TextField("Cédula" , text: self.$cedula).keyboardType(.numberPad)
                    TextField("Nombre", text:$nombres)
                    DatePicker( selection: $fechNaci, in: ...Date(),displayedComponents: .date){Text("Fecha nacimiento")}
                    TextField("Lugar de nacimiento" , text:$lugar)
                    TextField("Estatura" , text:$estatura).keyboardType(.decimalPad)
                    Picker( selection: $tipoSangre,
                           label: Text("Tipo de sangre")){
                            ForEach(BloodType.allBloodTypes, id: \.self){
                                bt in
                                Text(bt).tag(bt)
                            }
                    }
                    HStack{
                        Text("Sexo").padding(.horizontal, 5)
                        Picker( selection: $sexo, label: Text("Sexo")){
                            ForEach(Sexo.allSex, id: \.self){
                                s in
                                Text(s).tag(s)
                            }
                        }.pickerStyle( SegmentedPickerStyle())
                    }
                    TextField("Telefono" , text:$telefono).keyboardType(.phonePad)
                    Button( action: {
                        self.saveInArray()
                        self.store.speechView = true
                        self.store.addPacien = false
                    }){
                        Text("Dictado")
                    }
                    Button( action: {
                        
                        self.showSheet = true
                        print(self.store.$textRecognitionResults)
                        
                    }){
                        Text("Escanear")
                    }
                }
                Section(header: Text("Consulta")){
                    TextField("Motivo" , text:$motivo)
                    TextField("Alergias", text: $alergias)
                    TextField("Pulso" , text:$pulso)
                    TextField("Respiracion" , text:$respiracion).keyboardType(.decimalPad)
                    TextField("Temperatura" , text:$temperatura).keyboardType(.decimalPad)
                    TextField("Tension" , text:$tension)
                    TextField("Area" , text:$area)
                    TextField("Triaje" , text:$triaje).keyboardType(.numberPad)
                }
                
            }.navigationBarTitle( Text("Nuevo paciente"))
            .navigationBarItems(leading:
                Button(action: {
                    self.store.addPacien = false
                    self.cleanData()

                }) {
                    Text("Cancelar").foregroundColor( Color.red)
                },
                trailing:
                Button(action: {
                    
                    var crearTime = self.defaults.object(forKey:"CrearTime") as? [Int] ?? [0,0]
                    crearTime[0] = crearTime[0] + self.miliTime
                    crearTime[1] = crearTime[1] + 1
                    self.defaults.set(crearTime, forKey:"CrearTime")
                    
                    if self.cedula == "" || self.cedula == " "{
                        self.msg = "Ingrese un valor de cédula válido"
                        self.alertCedula = true
                    }
                    else{
                        self.conectionTest()
                        self.saveData()
                        self.store.addPacien = false
                        self.store.cedulaPacienteActual = self.cedula
                        self.validForm()
                    }
                    
                }) {
                    Text("Guardar")
                }.disabled(self.cedula.isEmpty)
                .alert(isPresented: $alertCedula){
                Alert(title: Text("Identificación invalida"), message: Text(self.msg), dismissButton: .default(Text("Okay")))}
                .alert(isPresented: $alertError){
                Alert(title: Text("Error al cargar"), message: Text(self.msg), dismissButton: .default(Text("Okay")))}
                .alert(isPresented: $alertGuardado){
                Alert(title: Text("Paciente guardado"), message: Text(self.msg), dismissButton: .default(Text("Okay")))}
            )
            
            
        }.onDisappear{
        
        }
        .onAppear{
            var crearTime = self.defaults.object(forKey:"CrearTime") as? [Int] ?? [0,0]
            if self.store.wasSpeeching == false{
                self.conectionTest()
            }else{
                self.wasSpeech()
            }
            }
        .alert(isPresented: $alert){
        Alert(title: Text("Sin conexión a internet"), message: Text(self.msg), dismissButton: .default(Text("Okay")))}
        .sheet(isPresented: self.$showSheet) {
            Group {
                DocumentRecognitionView(didFinishCamera: self.$didFinishCamera)
                    .onAppear {
                        self.store.procesandoTexto = true
                }.onDisappear{
                    self.store.procesandoTexto = false
                    while recognizedTextResults.isEmpty {
                        sleep(1)
                    }
                    self.store.procesandoTexto = false
                    if recognizedTextResults.count > 7 {
                        self.cedula = recognizedTextResults[0]
                        self.nombres = "\(recognizedTextResults[2]) \(recognizedTextResults[1])"
                        let formatter4 = DateFormatter()
                        formatter4.dateFormat = "dd/MM/yyyy"
                        self.fechNaci = formatter4.date(from: recognizedTextResults[3]) ?? Date()
                        self.lugar = recognizedTextResults[4]
                        self.estatura = recognizedTextResults[5]
                        self.tipoSangre = recognizedTextResults[6]
                        self.sexo = recognizedTextResults[7]
                    }
                }
            }
        }
        
    }
    
    // verifica la conexión al wifi
    func conectionTest()
    {
        let nwkMonitor = NWPathMonitor(requiredInterfaceType: .wifi)
        nwkMonitor.pathUpdateHandler = {
            path in
            if path.status == .satisfied{
                self.conexion = true
            }
            else
            {
                self.alert = true
                self.conexion = false
                self.msg = "En este momento no te encuentras conectado a internet, todos los pacientes se guardarán en el celular"

            }
        }
        let queue = DispatchQueue(label: "Monitor")
        nwkMonitor.start(queue: queue)
        nwkMonitor.cancel()
    }
    
    //Este no funciona aún :D
    //La idea es validar campos del formulario
    func validForm(){
        if (self.estatura.contains("a") || self.estatura.contains("2") || self.estatura.contains("3") || self.estatura.contains("4") || self.estatura.contains("5") || self.estatura.contains("6") || self.estatura.contains("7") || self.estatura.contains("8") || self.estatura.contains("9") || self.estatura.contains("0") || self.estatura.contains(".") || self.estatura.contains(",")){
            self.alertForm = true
        }
        if !(self.cedula.contains("1") || self.cedula.contains("2") || self.cedula.contains("3") || self.cedula.contains("4") || self.cedula.contains("5") || self.cedula.contains("6") || self.cedula.contains("7") || self.cedula.contains("8") || self.cedula.contains("9") || self.cedula.contains("0")){
            self.alertForm = true
        }
        if !(self.telefono.contains("1") || self.telefono.contains("2") || self.telefono.contains("3") || self.telefono.contains("4") || self.telefono.contains("5") || self.telefono.contains("6") || self.telefono.contains("7") || self.telefono.contains("8") || self.telefono.contains("9") || self.telefono.contains("0") || self.telefono.contains("+") || self.telefono.contains("(") || self.telefono.contains(")")){
            self.alertForm = true
        }
    }
    
    //Verifica si viene de dictado y carga los datos anteriormente enviados
    func wasSpeech(){
        if self.store.wasSpeeching == true{
            self.store.wasSpeeching = false
            self.readArray()
        }
    }
    
    // Estructura de tipo de sangre
    struct BloodType {
        static let allBloodTypes = [
            "0+",
            "0-",
            "A+",
            "A-",
            "B+",
            "B-",
            "AB+",
            "AB-"
        ]
    }
    
    // Estructura de sexo
    struct Sexo {
        static let allSex = [
            "M",
            "F"
        ]
    }
    
    // Guarda en un arreglo la información del formulario cuando el formulario va a pasar a dictado
    func saveInArray()
    {
        self.arreglo[1] = self.cedula
        self.arreglo[3] = self.nombres
        self.arreglo[5] = self.fechNaci
        self.arreglo[7] = self.lugar
        self.arreglo[9] = self.estatura
        self.arreglo[11] = self.tipoSangre
        self.arreglo[13] = self.sexo
        self.arreglo[15] = self.telefono
        self.arreglo[17] = self.motivo
        self.arreglo[19] = self.alergias
        self.arreglo[21] = self.pulso
        self.arreglo[23] = self.respiracion
        self.arreglo[25] = self.temperatura
        self.arreglo[27] = self.tension
        self.arreglo[29] = self.area
        self.arreglo[31] = self.triaje
        self.store.arregloFormulario = self.arreglo
    }
    
    // Asigna los valores correspondientes cuando lee la información de los arreglo
    func readArray()
    {
        self.arreglo = self.store.arregloFormulario
        self.cedula = self.arreglo[1] as? String ?? ""
        self.nombres = self.arreglo[3] as? String ?? ""
        let fech = self.arreglo[5] as? String ?? ""
        
        let formatter4 = DateFormatter()
        formatter4.dateFormat = "dd/MM/yyyy"
        self.fechNaci = formatter4.date(from: fech) ?? Date()
        
        self.lugar = self.arreglo[7] as? String ?? ""
        self.estatura = self.arreglo[9] as? String ?? ""
        self.tipoSangre = self.arreglo[11] as? String ?? ""
        self.sexo = self.arreglo[13] as? String ?? ""
        self.telefono = self.arreglo[15] as? String ?? ""
        self.motivo = self.arreglo[17] as? String ?? ""
        self.alergias = self.arreglo[19] as? String ?? ""
        self.pulso = self.arreglo[21] as? String ?? ""
        self.respiracion = self.arreglo[23] as? String ?? ""
        self.temperatura = self.arreglo[25] as? String ?? ""
        self.tension = self.arreglo[27] as? String ?? ""
        self.area = self.arreglo[29] as? String ?? ""
        self.triaje = self.arreglo[31] as? String ?? ""
    }
    
    // Guarda el paciente, cuando no hay conexion no muestra el mensaje que no hay conexion
    func saveData(){
        // Guarda localmente primero y luego intenta guardar en firebase
        let paci = Paciente(context: context)
        paci.cedula = Int64(self.cedula) ?? 0
        paci.nombre = self.nombres
        paci.fechNaci = self.fechNaci
        paci.lugar = self.lugar
        paci.estatura = Double(self.estatura) ?? 0
        paci.tipoSangre = self.tipoSangre
        paci.sexo = self.sexo
        paci.telefono = Int64(self.telefono) ?? 0
        paci.motivo = self.motivo
        paci.alergias = self.alergias
        paci.pulso = Int16(self.pulso) ?? 0
        paci.saturacion = Int16(self.respiracion) ?? 0
        paci.temperatura = Double(self.temperatura) ?? 0
        paci.tension = self.tension
        paci.area = self.area
        paci.triage = Int16(self.triaje) ?? 0
        
        // Guarda en Core Data el paciente
        appDelegate.saveContext()
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "dd/MM/yyyy"
        let fechaString = formatter3.string(from: self.fechNaci)
        
        let format = DateFormatter()
        format.dateFormat = "HH:mm dd/MM/yyyy"
        let fechaAct = format.string(from: Date())
        ref.child("pacientes").child(self.cedula).setValue(["Alergias":self.alergias,"Altura":self.estatura, "Area": self.area, "Fecha": fechaString,"Motivo":self.motivo,"Nombre": self.nombres, "Pulso": self.pulso, "Respiracion":self.respiracion,"Sexo": self.sexo,"Sintomas":self.sintomas,"Telefono": self.telefono,"Temperatura":self.temperatura,"Tension":self.tension,"Triage":self.triaje, "Sangre": self.tipoSangre, "Lugar": self.lugar, "Visitas":1, "Estado": "1", "Hora": fechaAct, "Tiempo": Int(Double(self.miliTime)/60.0)]){
        (error:Error?, ref:DatabaseReference) in
        if let error = error {
            self.msg = "Ha ocurrido un error al cargar el usuario: \(error)"
            self.alertError = true
        }
        else{
                self.context.delete(paci)
                self.appDelegate.saveContext()
                self.msg = "El paciente identificado con la cédula: \(self.cedula) se ha guardado exitosamente."
                self.alertGuardado = true
            }}
        
        self.store.pacienteActual = PacienteHK(cedula: Int64(self.cedula) ?? 0, estatura: Double(self.estatura) ?? 0, fechNaci: self.fechNaci, lugar: self.lugar, motivo: self.motivo, nombre: self.nombres, sexo: self.sexo, telefono: Int64(self.telefono) ?? 0, tipoSangre: self.tipoSangre, alergias: self.alergias, pulso: Int16(self.pulso) ?? 0, saturacion: Int16(self.respiracion) ?? 0, sintomas: self.sintomas, temperatura: Double(self.temperatura) ?? 0, tension: self.tension, triaje: Int16(self.triaje) ?? 0, area: self.area, visitas: 1, estado: "1")
        print(self.store.pacienteActual)
        self.store.showPacienteDetail = true
    }
    
    // Limpia la información cuando se sale del formulario
    func cleanData(){
        
        self.cedula = ""
        self.nombres = ""
        self.fechNaci = Date()
        self.lugar = ""
        self.estatura =  ""
        self.tipoSangre = ""
        self.sexo =  ""
        self.telefono =  ""
        self.motivo =  ""
        self.alergias =  ""
        self.pulso =  ""
        self.respiracion =  ""
        self.temperatura =  ""
        self.tension =  ""
        self.area =  ""
        self.triaje =  ""
    }
    
   func run(after seconds: Int, completion: @escaping () -> Void){
          let deadline = DispatchTime.now() + .seconds(seconds)
          DispatchQueue.main.asyncAfter(deadline: deadline) {
              completion()
          }
      }
        
}

class TextBindingManager: ObservableObject{
    @Published var text = "" {
        didSet {
            if text.count > characterLimit && oldValue.count <= characterLimit {
                text = oldValue
            }
        }
    }
    let characterLimit: Int
    
    init(limit: Int = 5){
        characterLimit = limit
    }
}


