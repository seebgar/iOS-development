//
//  PacienteDetailView.swift
//  HKCoure
//
//  Created by Andres Rodriguez on 4/04/20.
//  Copyright © 2020 Sebastian. All rights reserved.
//

import SwiftUI
import CoreData

struct PacienteDetailView: View {
    
    @EnvironmentObject var store: Store
    
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
    
    
    var body: some View {
        
        ZStack{

            Color.offWhite
            NavigationView{
                
                Form{
                    Section (header: Text("Información del paciente.")) {
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
                }.onAppear(
                    perform: self.getPaciente
                ).navigationBarTitle( Text("Paciente"))
                .navigationBarItems(leading:
                    Button(action: {
                        self.store.showPacienteDetail = false
                    }) {
                        Text("Atras").foregroundColor( Color.red)
                    }
                )
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
}
