
//  PacienteDetailView.swift
//  HKCoure
//
//  Created by Andres Rodriguez on 4/04/20.
//  Copyright © 2020 Sebastian. All rights reserved.
//

import SwiftUI
import CoreData
import FirebaseDatabase

struct SearchPacienteDetailView: View {
    
    @EnvironmentObject var store: Store
    
    @State private var deAlta = false
    
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
    @State private var traije = ""
    @State private var estado = ""
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let defaults = UserDefaults.standard
    
    @State private var miliTime: Int = 0
    
    
    var body: some View {
        
        ZStack{

            Color.offWhite
            NavigationView{
                
                Form{
                    Section (header: Text("Información del paciente.").onReceive(timer){time in self.miliTime+=1}) {
                        HStack {
                            Text("Cedula")
                                .frame(width: 100)
                            Spacer()
                            TextField("", text: self.$cedula)
                        }
                        
                        HStack {
                            Text("Nombres")
                                .frame(width: 100)
                            Spacer()
                            TextField("", text: self.$nombres)
                        }
                        
                        HStack {
                            Text("Fecha nacimiento")
                                .frame(width: 100)
                            Spacer()
                            DatePicker("", selection: self.$fechNaci, displayedComponents: .date)
                        }
                        
                        HStack {
                            Text("Lugar")
                                .frame(width: 100)
                            Spacer()
                            TextField("", text: self.$lugar)
                        }
                        
                        HStack {
                            Text("Estatura")
                                .frame(width: 100)
                            Spacer()
                            TextField("", text: self.$estatura)
                        }
                        
                        HStack {
                            Text("Tipo de sangre")
                                .frame(width: 100)
                            Spacer()
                            Picker("", selection: self.$tipoSangre){
                                ForEach(BloodType.allBloodTypes, id: \.self){
                                    bt in
                                    Text(bt).tag(bt)
                                }}
                        }
                        
                        HStack {
                            Text("Sexo")
                                .frame(width: 100)
                            Spacer()
                            Picker("", selection: self.$sexo){
                                ForEach(Sexo.allSex, id: \.self){
                                    s in Text(s).tag(s)
                                }
                            }
                        }
                        
                        HStack {
                            Text("Telefono")
                                .frame(width: 100)
                            Spacer()
                            TextField("", text: self.$telefono)
                        }
                    }
                    
                    Section(header: Text("Información del paciente")){
                        HStack {
                            Text("Motivo")
                                .frame(width: 100)
                            Spacer()
                            TextField("", text: self.$motivo)
                        }
                        
                        HStack {
                            Text("Sintomas")
                                .frame(width: 100)
                            Spacer()
                            TextField("", text: self.$sintomas)
                        }
                        
                        HStack {
                            Text("Pulso")
                                .frame(width: 100)
                            Spacer()
                            TextField("", text: self.$pulso)
                        }
                        
                        HStack {
                            Text("Respiración")
                                .frame(width: 100)
                            Spacer()
                            TextField("", text: self.$respiracion)
                        }
                        
                        HStack {
                            Text("Temperatura")
                                .frame(width: 100)
                            Spacer()
                            TextField("", text: self.$temperatura)
                        }
                        
                        HStack {
                            Text("Tension")
                                .frame(width: 100)
                            Spacer()
                            TextField("", text: self.$tension)
                        }
                        
                        HStack {
                            Text("Área")
                                .frame(width: 100)
                            Spacer()
                            TextField("", text: self.$area)
                        }
                        
                        HStack {
                            Text("Alergias")
                                .frame(width: 100)
                            Spacer()
                            TextField("", text: self.$alergias)
                        }
                        
                        HStack {
                            Text("Triaje")
                                .frame(width: 100)
                            Spacer()
                            TextField("", text: self.$traije)
                        }
                    }
                    Section(header: Text("Estado del paciente")){
                        Button(action: {
                            self.deAlta = true
                        }) {
                            Text("Dar de alta").foregroundColor( Color.green).bold()
                        }.alert(isPresented: $deAlta){
                            Alert(title: Text("Dar de alta"), message: Text("Está a punto de dar de alta a este paciente. ¿Desea dar de alta este paciente?"), primaryButton: .default(Text("Si"), action: {
                                self.darDeAlta()
                                self.store.searchPacientDetail = false
                            }), secondaryButton: .default(Text("No").foregroundColor(Color.red)))}
                            .disabled(self.estado == "0")
                    }
                }.onAppear{
                    var buscarTime = self.defaults.object(forKey:"BuscarTime") as? [Int] ?? [0,0]
                    print(buscarTime)
                    self.getPaciente()
                }.navigationBarTitle( Text("Paciente"))
                .navigationBarItems(leading:
                    Button(action: {
                        
                        self.store.searchPacientDetail = false
                    }) {
                        Text("Atras").foregroundColor( Color.red)
                    },
                    trailing:
                    Button(action: {
                        var crearTime = self.defaults.object(forKey:"BuscarTime") as? [Int] ?? [0,0]
                        crearTime[0] = crearTime[0] + self.miliTime
                        crearTime[1] = crearTime[1] + 1
                        self.defaults.set(crearTime, forKey:"BuscarTime")
                        self.saveData()
                        
                    }) {
                        Text("Guardar")
                    }.disabled(self.cambio())
                )
            }
        }
    }
    
    func darDeAlta(){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("pacientes").child(self.cedula).updateChildValues(["Estado":"0"]){
        (error:Error?, ref:DatabaseReference) in
        if let error = error {
            //self.msg = "Ha ocurrido un error al cargar el usuario: \(error)"
            //self.alertError = true
            }
            
        }
        
    }
    
    // Toma la información del Paciente Actual en Store
    func getPaciente(){
        let paciente = self.store.pacienteActual
        print(paciente)
        self.cedula = String(paciente.cedula)
        self.nombres = paciente.nombre!
        self.fechNaci = paciente.fechNaci!
        self.lugar = paciente.lugar!
        self.estatura = String(paciente.estatura)
        self.tipoSangre = paciente.tipoSangre!
        self.sexo = paciente.sexo!
        self.telefono = String(paciente.telefono)
        self.motivo = paciente.motivo!
        self.alergias = paciente.alergias!
        self.pulso = String(paciente.pulso)
        self.respiracion = String(paciente.saturacion)
        self.temperatura = String(paciente.temperatura)
        self.tension = paciente.tension!
        self.area = paciente.area
        self.traije = String(paciente.triage)
        self.sintomas = paciente.sintomas!
        self.estado = paciente.estado

    }
    
    // estructura de tipo de sangre
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
        paci.triage = Int16(self.traije) ?? 0
        
        // Guarda en Core Data el paciente
        appDelegate.saveContext()
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "dd/MM/yyyy"
        let fechaString = formatter3.string(from: self.fechNaci)
        ref.child("pacientes").child(self.cedula).updateChildValues(["Alergias":self.alergias,"Altura":self.estatura, "Area": self.area, "Fecha": fechaString,"Motivo":self.motivo,"Nombre": self.nombres, "Pulso": self.pulso, "Respiracion":self.respiracion,"Sexo": self.sexo,"Sintomas":self.sintomas,"Telefono": self.telefono,"Temperatura":self.temperatura,"Tension":self.tension,"Triage":self.traije, "Sangre": self.tipoSangre, "Lugar": self.lugar, "Visitas": self.store.pacienteActual.visitas + 1]){
        (error:Error?, ref:DatabaseReference) in
        if let error = error {
            //self.msg = "Ha ocurrido un error al cargar el usuario: \(error)"
            //self.alertError = true
        }
        else{
                self.context.delete(paci)
                self.appDelegate.saveContext()
                //self.msg = "El paciente identificado con la cédula: \(self.cedula) se ha guardado exitosamente."
                //self.alertGuardado = true
            }}
        
        self.store.pacienteActual = PacienteHK(cedula: Int64(self.cedula) ?? 0, estatura: Double(self.estatura) ?? 0, fechNaci: self.fechNaci, lugar: self.lugar, motivo: self.motivo, nombre: self.nombres, sexo: self.sexo, telefono: Int64(self.telefono) ?? 0, tipoSangre: self.tipoSangre, alergias: self.alergias, pulso: Int16(self.pulso) ?? 0, saturacion: Int16(self.respiracion) ?? 0, sintomas: self.sintomas, temperatura: Double(self.temperatura) ?? 0, tension: self.tension, triaje: Int16(self.traije) ?? 0, area: self.area, visitas: self.store.pacienteActual.visitas + 1, estado: "1")
        print(self.store.pacienteActual)
        self.store.showPacienteDetail = true
        self.store.searchPacientDetail = true
    }
    
    func cambio() -> Bool{
        if self.store.pacienteActual.cedula != Int64(self.cedula){
            return false
        }
        else if self.store.pacienteActual.nombre != self.nombres{
            return false
        }
        else if self.store.pacienteActual.fechNaci != self.fechNaci{
            return false
        }
        else if self.store.pacienteActual.lugar != self.lugar{
            return false
        }
        else if self.store.pacienteActual.estatura != Double(self.estatura){
            return false
        }
        else if self.store.pacienteActual.tipoSangre != self.tipoSangre{
            return false
        }
        else if self.store.pacienteActual.sexo != self.sexo{
            return false
        }
        else if self.store.pacienteActual.telefono != Int64(self.telefono){
            return false
        }
        else if self.store.pacienteActual.motivo != self.motivo{
            return false
        }
        else if self.store.pacienteActual.sintomas != self.sintomas{
            return false
        }
        else if self.store.pacienteActual.pulso != Int16(self.pulso){
            return false
        }
        else if self.store.pacienteActual.saturacion != Int16(self.respiracion){
            return false
        }
        else if self.store.pacienteActual.temperatura != Double(self.temperatura){
            return false
        }
        else if self.store.pacienteActual.tension != self.tension{
            return false
        }
        else if self.store.pacienteActual.area != self.area{
            return false
        }
        else if self.store.pacienteActual.alergias != self.alergias{
            return false
        }
        else if self.store.pacienteActual.triage != Int16(self.traije){
            return false
        }
        return true
    }
}
