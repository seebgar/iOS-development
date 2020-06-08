//
//  AnalyticsView.swift
//  HKCoure
//
//  Created by Pipe on 23/04/20.
//  Copyright © 2020 Sebastian. All rights reserved.
//

import SwiftUI
import UIKit
import FirebaseDatabase
import Network
//import Charts

struct AnalyticsView: View{
    
    @EnvironmentObject var store: Store
    
    @State var numeroPacientes: Int = 0
    
    @State var pacientesBogota: Int = 0
    @State var pacientesOtraC: Int = 0
    @State var pacientesSexoM: Int = 0
    @State var pacientesSexoF: Int = 0
    @State var pacientesSexoO: Int = 0
    @State var pacientesSexoTot: Int = 0
    @State var pacientesTriageUno: Int = 0
    @State var pacientesTriageDos: Int = 0
    @State var pacientesTriageTres: Int = 0
    @State var paciList: [Paci2] = []
    @State var conexion: Bool = false
    @State var alert: Bool = false
    
    
    @State var totalPacientes: Float = 0.0;
    
    @State var porcentajeCiudadOtra: Float = 0.0;
    @State var porcentajeCiudadBogota: Float = 0.0;
    
    @State var porcentajeSexoM: Float = 0.0;
    @State var porcentajeSexoF: Float = 0.0;
    @State var porcentajeSexoO: Float = 0.0;
    
    @State var porcentajeNivelUno: Float = 0.0;
    @State var porcentajeNivelDos: Float = 0.0;
    @State var porcentajeNivelTres: Float = 0.0;
    
    @State var edad0_25: Int = 0
    @State var edad25_50: Int = 0
    @State var edad50_75: Int = 0
    @State var edad75_100: Int = 0
    @State var edadMas_100: Int = 0
    
    @State var tie0_25: Double = 0
    @State var tie25_50: Double = 0
    @State var tie50_75: Double = 0
    @State var tie75_100: Double = 0
    @State var tieMas_100: Double = 0
    
    @State var tri0_25: Double = 0
    @State var tri25_50: Double = 0
    @State var tri50_75: Double = 0
    @State var tri75_100: Double = 0
    @State var triMas_100: Double = 0
    
    @State var generoPacienteMasT: String = "Masculino"

    @State var tieMuj: Double = 0
    @State var tieHom: Double = 0
    
    @State var colorT1: [Color] = [.lightRed,.primaryRed]
    @State var colorT2: [Color] = [ Color.RGB(red: 112, green: 112, blue: 112), Color.RGB(red: 112, green: 112, blue: 112)]
    @State var colorT3: [Color] = [.lightBlue, .primaryBlue]
    
    var body: some View{
        VStack{
            
            HStack{
                Button(action: {
                    self.store.preguntasDemograficasView = false
                    self.store.tiposAnalyticsView = true
                    
                }) {
                    Text("Volver").foregroundColor( Color.red)
                }
                Spacer()
                Text("Preguntas demográficas").bold()
                Spacer()
            }.padding(.horizontal).padding(.top, 16)
            
            
            Divider()
            
            
            ScrollView (.vertical, showsIndicators: false) {
                VStack  (alignment: .center, spacing: 20) {
                    
                    VStack{
                        Text("Pacientes por Ciudad").bold()
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 176, height: 176)
                                .shadow(color: Color.primaryBlack.opacity( 0.2), radius: 10, x: 10, y: 10)
                                .shadow(color: Color.primaryWhite.opacity( 0.7), radius: 10, x: -5, y: -5)
                            
                            // trim 0.2 -> 80%
                            Circle()
                                .trim(from: CGFloat( 1.0 - self.porcentajeCiudadOtra ) , to: 1)
                                .stroke(LinearGradient(gradient: Gradient(colors: [.lightRed, .primaryRed]), startPoint: .topLeading, endPoint: .bottomTrailing),
                                        style: StrokeStyle(lineWidth: 16, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [0, 0], dashPhase: 0))
                                .rotationEffect(Angle(degrees: 90))
                                .rotation3DEffect(.degrees(180), axis: (x: 1 , y: 0, z: 0) )
                                .frame(width: 160, height: 160)
                            
                            VStack {
                                Text("Bogotá" ).font(.subheadline).bold()
                                Text("\(String(format: "%.2f", 100 * self.porcentajeCiudadBogota)) %").font(.subheadline).bold()
                                Text("")
                                Text("Otra" ).font(.subheadline).bold()
                                Text("\(String(format: "%.2f", 100 * self.porcentajeCiudadOtra)) %").font(.subheadline).bold()
                            }
                        }
                    }.padding()
                    Divider()
                    
                    VStack {
                        Text("Pacientes por Sexo").bold()
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 176, height: 176)
                                .shadow(color: Color.primaryBlack.opacity( 0.2), radius: 10, x: 10, y: 10)
                                .shadow(color: Color.primaryWhite.opacity( 0.7), radius: 10, x: -5, y: -5)
                            
                            // trim 0.2 -> 80%
                            Circle()
                                .trim(from: CGFloat( 1.0 - self.porcentajeSexoF ) , to: 1)
                                .stroke(LinearGradient(gradient: Gradient(colors: [.lightRed, .primaryRed]), startPoint: .topLeading, endPoint: .bottomTrailing),
                                        style: StrokeStyle(lineWidth: 16, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [0, 0], dashPhase: 0))
                                .rotationEffect(Angle(degrees: 90))
                                .rotation3DEffect(.degrees(180), axis: (x: 1 , y: 0, z: 0) )
                                .frame(width: 160, height: 160)
                            Circle()
                                .trim(from: CGFloat( 1.0 - self.porcentajeSexoM ) , to: CGFloat( 1 - self.porcentajeSexoF ))
                                .stroke(LinearGradient(gradient: Gradient(colors: [ Color.RGB(red: 112, green: 112, blue: 112), Color.RGB(red: 112, green: 112, blue: 112)]), startPoint: .topLeading, endPoint: .bottomTrailing),
                                        style: StrokeStyle(lineWidth: 16, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [0, 0], dashPhase: 0))
                                .rotationEffect(Angle(degrees: 90))
                                .rotation3DEffect(.degrees(180), axis: (x: 1 , y: 0, z: 0) )
                                .frame(width: 160, height: 160)
                            
                            VStack {
                                Text("Femenino" ).font(.subheadline).bold()
                                Text("\(String(format: "%.2f", 100 * self.porcentajeSexoF) ) %").font(.subheadline).bold()
                                Text("")
                                Text("Masculino" ).font(.subheadline).bold()
                                Text("\(String(format: "%.2f", 100 * self.porcentajeSexoM) ) %").font(.subheadline).bold()
                            }
                        }
                    }.padding()
                    Divider()
                    VStack {
                        Text("Pacientes por Triage").bold()
                        
                        HStack (alignment: .center, spacing: 20) {
                            
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 98, height: 98)
                                    .shadow(color: Color.primaryBlack.opacity( 0.2), radius: 10, x: 10, y: 10)
                                    .shadow(color: Color.primaryWhite.opacity( 0.7), radius: 10, x: -5, y: -5)
                                
                                // trim 0.2 -> 80%
                                Circle()
                                    .trim(from: CGFloat( 1.0 - self.porcentajeNivelUno ) , to: 1)
                                    .stroke(LinearGradient(gradient: Gradient(colors: [.lightRed, .primaryRed]), startPoint: .topLeading, endPoint: .bottomTrailing),
                                            style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [0, 0], dashPhase: 0))
                                    .rotationEffect(Angle(degrees: 90))
                                    .rotation3DEffect(.degrees(180), axis: (x: 1 , y: 0, z: 0) )
                                    .frame(width: 88, height: 88)
                                
                                
                                VStack {
                                    Text("Nivel 1" ).font(.footnote).bold()
                                    Text("\(String(format: "%.2f", 100 * self.porcentajeNivelUno) ) %").font(.footnote).bold()
                                    //
                                }
                            }
                            
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 98, height: 98)
                                    .shadow(color: Color.primaryBlack.opacity( 0.2), radius: 10, x: 10, y: 10)
                                    .shadow(color: Color.primaryWhite.opacity( 0.7), radius: 10, x: -5, y: -5)
                                
                                // trim 0.2 -> 80%
                                Circle()
                                    .trim(from: CGFloat( 1.0 - self.porcentajeNivelDos ) , to: 1)
                                    .stroke(LinearGradient(gradient: Gradient(colors:[ Color.RGB(red: 112, green: 112, blue: 112), Color.RGB(red: 112, green: 112, blue: 112)]), startPoint: .topLeading, endPoint: .bottomTrailing),
                                            style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [0, 0], dashPhase: 0))
                                    .rotationEffect(Angle(degrees: 90))
                                    .rotation3DEffect(.degrees(180), axis: (x: 1 , y: 0, z: 0) )
                                    .frame(width: 88, height: 88)
                                
                                                      
                                
                                VStack {
                                    
                                    Text("Nivel 2" ).font(.footnote).bold()
                                    Text("\(String(format: "%.2f", 100 * self.porcentajeNivelDos) ) %").font(.footnote).bold()
                                   
                                }
                            }
                        }
                        
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 98, height: 98)
                                .shadow(color: Color.primaryBlack.opacity( 0.2), radius: 10, x: 10, y: 10)
                                .shadow(color: Color.primaryWhite.opacity( 0.7), radius: 10, x: -5, y: -5)
                            
                            // trim 0.2 -> 80%
                            Circle()
                                .trim(from: CGFloat( 1.0 - self.porcentajeNivelTres ) , to: 1)
                                .stroke(LinearGradient(gradient: Gradient(colors: [.lightBlue, .primaryBlue]), startPoint: .topLeading, endPoint: .bottomTrailing),
                                        style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [0, 0], dashPhase: 0))
                                .rotationEffect(Angle(degrees: 90))
                                .rotation3DEffect(.degrees(180), axis: (x: 1 , y: 0, z: 0) )
                                .frame(width: 88, height: 88)
                            
                            
                            VStack {
                                
                                Text("Nivel 3" ).font(.footnote).bold()
                                Text("\(String(format: "%.2f", 100 * self.porcentajeNivelTres) ) %").font(.footnote).bold()
                            }
                            
                        }
                        
                        
                        
                    }.padding()
                    Divider()
                    edadPacienteMasTiempo(total: self.$numeroPacientes, e0_24: self.$edad0_25, e25_50: self.$edad25_50, e50_75: self.$edad50_75, e75_100: self.$edad75_100, eMas100: self.$edadMas_100)
                    Divider()
                    tiempoPromedio(total: self.$numeroPacientes, e0_24: self.$tie0_25, e25_50: self.$tie25_50, e50_75: self.$tie50_75, e75_100: self.$tie75_100, eMas100: self.$tieMas_100)
                }
                .frame(maxWidth: .infinity)
                VStack{
                    Divider()
                    triagePromedio(e0_24: self.$tri0_25, e25_50: self.$tri25_50, e50_75: self.$tri50_75, e75_100: self.$tri75_100, eMas100: self.$triMas_100)
                    Divider()
                    tiempoPorGenero(tM: self.$tieMuj, tH: self.$tieHom)
                }
                
                
            }
            .frame(maxWidth: .infinity)
        }
            
        .onAppear{
            self.conectionTest()
            self.getData()
            
        }
        .alert(isPresented: $alert){
            Alert(title: Text("Sin internet"), message: Text("Lo sentimos, en este momento no tienes internet.\nIntentalo de nuevo más tarde"), dismissButton: .default(Text("Okay")))
        }
    }
    
    func getData(){
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.observeSingleEvent(of: .value,  with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            let content = value?["pacientes"] as? NSDictionary
            let pacientes = content?.allKeys
            for i in 0..<pacientes!.count {
                let cedula = pacientes?[i] as? String
                let val = content?[cedula!] as? NSDictionary
                
                let fecha = val?["Fecha"] as? String ?? ""
                
                let formatter4 = DateFormatter()
                formatter4.dateFormat = "dd/MM/yyyy"
                let fechNaci = formatter4.date(from: fecha) ?? Date()
                
                let delta = Calendar.current.dateComponents([.year], from: fechNaci, to: Date()).year
                
                
                let actual = Paci2(ced: cedula!, nom: val?["Nombre"] as? String ?? "", tri: val?["Triage"] as? String ?? "", sex: val?["Sexo"] as? String ?? "", ciu: val?["Lugar"] as? String ?? "", edad: delta as? Int ?? 0, tiempo: val?["Tiempo"] as? Int ?? 0)
                //self.paciList.append(actual)
                
                print("actual ---> ",actual.ciu.lowercased())
                
                if actual.ciu.lowercased().contains("bogotá") || actual.ciu.lowercased().contains("bogota"){
                    self.pacientesBogota += 1
                }
                else{
                    print("entra")
                    self.pacientesOtraC += 1
                }
                
                if actual.sex == "M" || actual.sex == "m"{
                    self.pacientesSexoM += 1
                    self.pacientesSexoTot += 1
                    self.tieHom += Double(actual.tiempo)
                }
                else if actual.sex == "F" || actual.sex == "f"{
                    self.pacientesSexoF += 1
                    self.pacientesSexoTot += 1
                    self.tieMuj += Double(actual.tiempo)
                }
                else {
                    self.pacientesSexoO += 1
                    self.pacientesSexoTot += 1
                }
                
                if actual.tri == "1"{
                    self.pacientesTriageUno += 1
                }
                else if actual.tri == "2"{
                    self.pacientesTriageDos += 1
                }
                else{
                    self.pacientesTriageTres += 1
                }
                
                if actual.edad >= 0 && actual.edad < 24{
                    self.edad0_25 += 1
                    self.tie0_25 += Double(actual.tiempo)
                    self.tri0_25 += Double(actual.tri) ?? 0
                }
                else if actual.edad >= 25 && actual.edad < 50{
                    self.edad25_50 += 1
                    self.tie25_50 += Double(actual.tiempo)
                    self.tri25_50 += Double(actual.tri) ?? 0
                }
                else if actual.edad >= 50 && actual.edad < 75 {
                    self.edad50_75 += 1
                    self.tie50_75 += Double(actual.tiempo)
                    self.tri50_75 += Double(actual.tri) ?? 0
                }
                else if actual.edad >= 75 && actual.edad < 100{
                    self.edad75_100 += 1
                    self.tie75_100 += Double(actual.tiempo)
                    self.tri75_100 += Double(actual.tri) ?? 0
                }
                else {
                    self.edadMas_100 += 1
                    self.tieMas_100 += Double(actual.tiempo)
                    self.triMas_100 += Double(actual.tri) ?? 0
                }
                
                self.numeroPacientes += 1
                
            }
            if self.pacientesSexoM == 0{
                self.tieHom = -1
            }else{
                self.tieHom = Double( self.tieHom ) / Double( self.pacientesSexoM )
            }
            if self.pacientesSexoF == 0{
                self.tieMuj = -1
            }
            else{
                self.tieMuj = Double( self.tieMuj)/Double(self.pacientesSexoF)
            }
            
            if self.edad0_25 == 0{
                self.tie0_25 = -1
                self.tri0_25 = -1
            }else{
                self.tie0_25 = Double(self.tie0_25 / Double(self.edad0_25))
                self.tri0_25 = Double(self.tri0_25 / Double(self.edad0_25))
            }
            
            if self.edad25_50 == 0{
                self.tie25_50 = -1
                self.tri25_50 = -1
            }else {
                self.tie25_50 = Double(self.tie25_50 / Double(self.edad25_50))
                self.tri25_50 = Double(self.tri25_50 / Double(self.edad25_50))
            }
            
            if self.edad50_75 == 0{
                self.tie50_75 = -1
                self.tri50_75 = -1
            }else {
                self.tie50_75 = Double(self.tie50_75 / Double(self.edad50_75))
                self.tri50_75 = Double(self.tri50_75 / Double(self.edad50_75))
            }
            
            if self.edad75_100 == 0{
                self.tie75_100 = -1
                self.tri75_100 = -1
            }else {
                self.tie75_100 = Double(self.tie75_100 / Double(self.edad75_100))
                self.tri75_100 = Double(self.tri75_100 / Double(self.edad75_100))
            }
            
            if self.edadMas_100 == 0{
                self.tieMas_100 = -1
                self.triMas_100 = -1
            }else {
                self.tieMas_100 = Double(self.tieMas_100 / Double(self.edadMas_100))
                self.triMas_100 = Double(self.triMas_100 / Double(self.edadMas_100))
            }
            // Valores para analitica de Porcentaje Users por Ciudad
            self.totalPacientes = Float(self.pacientesBogota) + Float(self.pacientesOtraC);
            self.porcentajeCiudadOtra =  Float(self.pacientesOtraC) / (self.totalPacientes > 0 ? Float( self.totalPacientes) : 1.0);
            self.porcentajeCiudadBogota =  Float( self.pacientesBogota) / (self.totalPacientes > 0 ? Float(self.totalPacientes) : 1.0);
            
            // Valores Sexo
            self.porcentajeSexoF =  Float(self.pacientesSexoF) / (self.totalPacientes > 0 ? Float( self.totalPacientes) : 1.0);
            self.porcentajeSexoM =  Float( self.pacientesSexoM) / (self.totalPacientes > 0 ? Float(self.totalPacientes) : 1.0);
            self.porcentajeSexoO =  Float( self.pacientesSexoO) / (self.totalPacientes > 0 ? Float(self.totalPacientes) : 1.0);
            
            // Valores Triageç
            self.porcentajeNivelUno =  Float( self.pacientesTriageUno) / (self.totalPacientes > 0 ? Float(self.totalPacientes) : 1.0);
            self.porcentajeNivelDos =  Float( self.pacientesTriageDos) / (self.totalPacientes > 0 ? Float(self.totalPacientes) : 1.0);
            self.porcentajeNivelTres =  Float( self.pacientesTriageTres) / (self.totalPacientes > 0 ? Float(self.totalPacientes) : 1.0);
        }
        ){(error) in
            print("----------------------Falla")
            print(error.localizedDescription)
        }
    }
    
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
                self.conexion = false
                self.alert = true
            }
        }
        let queue = DispatchQueue(label: "Monitor")
        nwkMonitor.start(queue: queue)
        nwkMonitor.cancel()
    }
}

//¿Cual es la edad de la persona con quien se tarda más la toma de datos?
private struct edadPacienteMasTiempo:View{
    @Binding var total: Int
    @Binding var e0_24: Int
    @Binding var e25_50: Int
    @Binding var e50_75: Int
    @Binding var e75_100: Int
    @Binding var eMas100: Int
    
    var body: some View{
        VStack{
            
            Text("Número de pacientes").bold().font(.system(size:18))
            Text("por rango de edad")
            
            VStack {
                
                HStack (alignment: .center, spacing: 20) {
                    
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 120, height: 120)
                            .shadow(color: Color.primaryBlack.opacity( 0.2), radius: 10, x: 10, y: 10)
                            .shadow(color: Color.primaryWhite.opacity( 0.7), radius: 10, x: -5, y: -5)
                        
                        // trim 0.2 -> 80%
                        Circle()
                            .trim(from: CGFloat( 1.0 - (Double(self.e0_24)/Double(self.total)) ) , to: 1)
                            .stroke(LinearGradient(gradient: Gradient(colors: [.lightRed, .primaryRed]), startPoint: .topLeading, endPoint: .bottomTrailing),
                                    style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [0, 0], dashPhase: 0))
                            .rotationEffect(Angle(degrees: 90))
                            .rotation3DEffect(.degrees(180), axis: (x: 1 , y: 0, z: 0) )
                            .frame(width: 110, height: 110)
                        
                        
                        VStack {
                            Text("Entre")
                            Text("0 a 24 años" )
                            Text(String(self.e0_24)).bold().font(.system(size:17))
                            Text("pacientes")
                            //
                        }
                    }
                    
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 120, height: 120)
                            .shadow(color: Color.primaryBlack.opacity( 0.2), radius: 10, x: 10, y: 10)
                            .shadow(color: Color.primaryWhite.opacity( 0.7), radius: 10, x: -5, y: -5)
                        
                        // trim 0.2 -> 80%
                        Circle()
                            .trim(from: CGFloat( 1.0 - (Double(self.e25_50)/Double(self.total))) , to: 1)
                            .stroke(LinearGradient(gradient: Gradient(colors:[ Color.RGB(red: 112, green: 112, blue: 112), Color.RGB(red: 112, green: 112, blue: 112)]), startPoint: .topLeading, endPoint: .bottomTrailing),
                                    style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [0, 0], dashPhase: 0))
                            .rotationEffect(Angle(degrees: 90))
                            .rotation3DEffect(.degrees(180), axis: (x: 1 , y: 0, z: 0) )
                            .frame(width: 110, height: 110)
                        
                                              
                        
                        VStack {
                            Text("Entre")
                            Text("25 a 49 años" )
                            Text(String(self.e25_50)).font(.system(size:17)).bold()
                            Text("pacientes")
                           
                        }
                    }
                }
                HStack (alignment: .center, spacing: 20) {
                    
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 120, height: 120)
                            .shadow(color: Color.primaryBlack.opacity( 0.2), radius: 10, x: 10, y: 10)
                            .shadow(color: Color.primaryWhite.opacity( 0.7), radius: 10, x: -5, y: -5)
                        
                        // trim 0.2 -> 80%
                        Circle()
                            .trim(from: CGFloat( 1.0 - (Double(self.e50_75)/Double(self.total)) ) , to: 1)
                            .stroke(LinearGradient(gradient: Gradient(colors: [ Color.RGB(red: 190, green: 190, blue: 190), Color.RGB(red: 190, green: 190, blue: 190)]), startPoint: .topLeading, endPoint: .bottomTrailing),
                                    style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [0, 0], dashPhase: 0))
                            .rotationEffect(Angle(degrees: 90))
                            .rotation3DEffect(.degrees(180), axis: (x: 1 , y: 0, z: 0) )
                            .frame(width: 110, height: 110)
                        
                        
                        VStack {
                            Text("Entre")
                            Text("50 a 74 años" )
                            Text(String(self.e50_75)).font(.system(size:17)).bold()
                            Text("pacientes")
                            //
                        }
                    }
                    
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 120, height: 120)
                            .shadow(color: Color.primaryBlack.opacity( 0.2), radius: 10, x: 10, y: 10)
                            .shadow(color: Color.primaryWhite.opacity( 0.7), radius: 10, x: -5, y: -5)
                        
                        // trim 0.2 -> 80%
                        Circle()
                            .trim(from: CGFloat( 1.0 - (Double(self.e75_100)/Double(self.total))) , to: 1)
                            .stroke(LinearGradient(gradient: Gradient(colors:[.lightBlue, .primaryBlue]), startPoint: .topLeading, endPoint: .bottomTrailing),
                                    style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [0, 0], dashPhase: 0))
                            .rotationEffect(Angle(degrees: 90))
                            .rotation3DEffect(.degrees(180), axis: (x: 1 , y: 0, z: 0) )
                            .frame(width: 110, height: 110)
                        
                                              
                        
                        VStack {
                            Text("Entre")
                            Text("75 a 100 años" )
                            Text(String(self.e75_100)).font(.system(size:17)).bold()
                            Text("pacientes")
                           
                        }
                    }
                }
                
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 120, height: 120)
                        .shadow(color: Color.primaryBlack.opacity( 0.2), radius: 10, x: 10, y: 10)
                        .shadow(color: Color.primaryWhite.opacity( 0.7), radius: 10, x: -5, y: -5)
                    
                    // trim 0.2 -> 80%
                    Circle()
                        .trim(from: CGFloat( 1.0 - (Double(self.eMas100)/Double(self.total)) ) , to: 1)
                        .stroke(LinearGradient(gradient: Gradient(colors: [ Color.RGB(red: 190, green: 190, blue: 190), Color.RGB(red: 190, green: 190, blue: 190)]), startPoint: .topLeading, endPoint: .bottomTrailing),
                                style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [0, 0], dashPhase: 0))
                        .rotationEffect(Angle(degrees: 90))
                        .rotation3DEffect(.degrees(180), axis: (x: 1 , y: 0, z: 0) )
                        .frame(width: 110, height: 110)
                    
                    
                    VStack {
                        
                        Text("Más de 100" )
                        Text("años")
                        Text(String(self.eMas100)).font(.footnote).bold()
                        Text("pacientes")
                    }
                    
                }
                                
            }.padding()
        }.padding()
        
    
    }
}

private struct tiempoPromedio: View{
    @Binding var total: Int
    @Binding var e0_24: Double
    @Binding var e25_50: Double
    @Binding var e50_75: Double
    @Binding var e75_100: Double
    @Binding var eMas100: Double
    
    var body: some View{
        VStack{
            
            Text("Tiempo promedio").bold().font(.system(size:18))
            Text("de toma de datos")
            Text("por rango de edad")
            
            VStack {
                
                HStack (alignment: .center, spacing: 20) {
                    
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 120, height: 120)
                            .shadow(color: Color.primaryBlack.opacity( 0.2), radius: 10, x: 10, y: 10)
                            .shadow(color: Color.primaryWhite.opacity( 0.7), radius: 10, x: -5, y: -5)
                        
                        // trim 0.2 -> 80%
                        Circle()
                            .trim(from: CGFloat( 0 - self.e0_24 ) , to: 1)
                            .stroke(LinearGradient(gradient: Gradient(colors: [.lightRed, .primaryRed]), startPoint: .topLeading, endPoint: .bottomTrailing),
                                    style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [0, 0], dashPhase: 0))
                            .rotationEffect(Angle(degrees: 90))
                            .rotation3DEffect(.degrees(180), axis: (x: 1 , y: 0, z: 0) )
                            .frame(width: 115, height: 115)
                        
                        
                        VStack {
                            Text("Entre")
                            Text("0 a 24 años" )
                            if self.e0_24 == -1{
                                Text("-").bold().font(.system(size:20))
                            }else
                            {
                                Text("\(String(format: "%.2f", self.e0_24) )").bold().font(.system(size:17))
                                Text("minutos")
                                
                            }
                            //
                        }
                    }
                    
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 120, height: 120)
                            .shadow(color: Color.primaryBlack.opacity( 0.2), radius: 10, x: 10, y: 10)
                            .shadow(color: Color.primaryWhite.opacity( 0.7), radius: 10, x: -5, y: -5)
                        
                        // trim 0.2 -> 80%
                        Circle()
                            .trim(from: CGFloat( 0 - self.e25_50) , to: 1)
                            .stroke(LinearGradient(gradient: Gradient(colors:[ Color.RGB(red: 112, green: 112, blue: 112), Color.RGB(red: 112, green: 112, blue: 112)]), startPoint: .topLeading, endPoint: .bottomTrailing),
                                    style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [0, 0], dashPhase: 0))
                            .rotationEffect(Angle(degrees: 90))
                            .rotation3DEffect(.degrees(180), axis: (x: 1 , y: 0, z: 0) )
                            .frame(width: 115, height: 115)
                        
                                              
                        
                        VStack {
                            Text("Entre")
                            Text("25 a 49 años" )
                            if self.e25_50 == -1{
                                Text("-").bold().font(.system(size:20))
                            }else
                            {
                                Text("\(String(format: "%.2f", self.e25_50) )").bold().font(.system(size:17))
                                Text("minutos")
                                
                            }
                           
                        }
                    }
                }
                HStack (alignment: .center, spacing: 20) {
                    
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 120, height: 120)
                            .shadow(color: Color.primaryBlack.opacity( 0.2), radius: 10, x: 10, y: 10)
                            .shadow(color: Color.primaryWhite.opacity( 0.7), radius: 10, x: -5, y: -5)
                        
                        // trim 0.2 -> 80%
                        Circle()
                            .trim(from: CGFloat( 0 - self.e50_75 ) , to: 1)
                            .stroke(LinearGradient(gradient: Gradient(colors: [ Color.RGB(red: 190, green: 190, blue: 190), Color.RGB(red: 190, green: 190, blue: 190)]), startPoint: .topLeading, endPoint: .bottomTrailing),
                                    style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [0, 0], dashPhase: 0))
                            .rotationEffect(Angle(degrees: 90))
                            .rotation3DEffect(.degrees(180), axis: (x: 1 , y: 0, z: 0) )
                            .frame(width: 115, height: 115)
                        
                        
                        VStack {
                            Text("Entre")
                            Text("50 a 74 años" )
                            if self.e50_75 == -1{
                                Text("-").bold().font(.system(size:20))
                            }else
                            {
                                Text("\(String(format: "%.2f", self.e50_75) )").bold().font(.system(size:17))
                                Text("minutos")
                                
                            }
                            //
                        }
                    }
                    
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 120, height: 120)
                            .shadow(color: Color.primaryBlack.opacity( 0.2), radius: 10, x: 10, y: 10)
                            .shadow(color: Color.primaryWhite.opacity( 0.7), radius: 10, x: -5, y: -5)
                        
                        // trim 0.2 -> 80%
                        Circle()
                            .trim(from: CGFloat( 0 - self.e75_100) , to: 1)
                            .stroke(LinearGradient(gradient: Gradient(colors:[.lightBlue, .primaryBlue]), startPoint: .topLeading, endPoint: .bottomTrailing),
                                    style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [0, 0], dashPhase: 0))
                            .rotationEffect(Angle(degrees: 90))
                            .rotation3DEffect(.degrees(180), axis: (x: 1 , y: 0, z: 0) )
                            .frame(width: 115, height: 115)
                        
                                              
                        
                        VStack {
                            Text("Entre")
                            Text("75 a 100 años" )
                            if self.e75_100 == -1{
                                Text("-").bold().font(.system(size:20))
                            }else
                            {
                                Text("\(String(format: "%.2f", self.e75_100) )").bold().font(.system(size:17))
                                Text("minutos")
                                
                            }
                           
                        }
                    }
                }
                
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 120, height: 120)
                        .shadow(color: Color.primaryBlack.opacity( 0.2), radius: 10, x: 10, y: 10)
                        .shadow(color: Color.primaryWhite.opacity( 0.7), radius: 10, x: -5, y: -5)
                    
                    // trim 0.2 -> 80%
                    Circle()
                        .trim(from: CGFloat( 0 - self.eMas100 ) , to: 1)
                        .stroke(LinearGradient(gradient: Gradient(colors: [.lightBlue, .primaryRed]), startPoint: .topLeading, endPoint: .bottomTrailing),
                                style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [0, 0], dashPhase: 0))
                        .rotationEffect(Angle(degrees: 90))
                        .rotation3DEffect(.degrees(180), axis: (x: 1 , y: 0, z: 0) )
                        .frame(width: 115, height: 115)
                    
                    
                    VStack {
                        
                        Text("Más de 100" )
                        Text("años")
                        if self.eMas100 == -1{
                            Text("-").bold().font(.system(size:20))
                        }else
                        {
                            Text("\(String(format: "%.2f", self.eMas100) )").bold().font(.system(size:17))
                            Text("minitos")
                            
                        }
                    }
                    
                }
                                
            }.padding()
        }.padding()
        
    
    }
}

//¿Cual es nivel de triaje promedio para una persona de una edad especificada?
private struct triagePromedio:View{
    @Binding var e0_24: Double
    @Binding var e25_50: Double
    @Binding var e50_75: Double
    @Binding var e75_100: Double
    @Binding var eMas100: Double
    
    var body: some View{
        VStack{
            
            Text("Triaje promedio").bold().font(.system(size:18))
            Text("de pacientes")
            Text("por rango de edad")
            
            VStack {
                
                HStack (alignment: .center, spacing: 20) {
                    
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 120, height: 120)
                            .shadow(color: Color.primaryBlack.opacity( 0.2), radius: 10, x: 10, y: 10)
                            .shadow(color: Color.primaryWhite.opacity( 0.7), radius: 10, x: -5, y: -5)
                        
                        // trim 0.2 -> 80%
                        Circle()
                            .trim(from: CGFloat( 1.0 - self.e0_24) , to: 1)
                            .stroke(LinearGradient(gradient: Gradient(colors: [.lightRed, .primaryRed]), startPoint: .topLeading, endPoint: .bottomTrailing),
                                    style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [0, 0], dashPhase: 0))
                            .rotationEffect(Angle(degrees: 90))
                            .rotation3DEffect(.degrees(180), axis: (x: 1 , y: 0, z: 0) )
                            .frame(width: 115, height: 115)
                        
                        
                        VStack {
                            Text("Entre")
                            Text("0 a 24 años" )
                            if self.e0_24 == -1{
                              Text("-").bold().font(.system(size:20))
                            }else{ Text("\(String(format: "%.2f", self.e0_24) )").bold().font(.system(size:23)) }
                            
                            //
                        }
                    }
                    
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 120, height: 120)
                            .shadow(color: Color.primaryBlack.opacity( 0.2), radius: 10, x: 10, y: 10)
                            .shadow(color: Color.primaryWhite.opacity( 0.7), radius: 10, x: -5, y: -5)
                        
                        // trim 0.2 -> 80%
                        Circle()
                            .trim(from: CGFloat( 1.0 - self.e25_50) , to: 1)
                            .stroke(LinearGradient(gradient: Gradient(colors:[ Color.RGB(red: 112, green: 112, blue: 112), Color.RGB(red: 112, green: 112, blue: 112)]), startPoint: .topLeading, endPoint: .bottomTrailing),
                                    style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [0, 0], dashPhase: 0))
                            .rotationEffect(Angle(degrees: 90))
                            .rotation3DEffect(.degrees(180), axis: (x: 1 , y: 0, z: 0) )
                            .frame(width: 115, height: 115)
                        
                                              
                        
                        VStack {
                            Text("Entre")
                            Text("25 a 49 años" )
                            if self.e25_50 == -1{
                              Text("-").bold().font(.system(size:20))
                            }else{ Text("\(String(format: "%.2f", self.e25_50) )").bold().font(.system(size:23))}
                           
                        }
                    }
                }
                HStack (alignment: .center, spacing: 20) {
                    
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 120, height: 120)
                            .shadow(color: Color.primaryBlack.opacity( 0.2), radius: 10, x: 10, y: 10)
                            .shadow(color: Color.primaryWhite.opacity( 0.7), radius: 10, x: -5, y: -5)
                        
                        // trim 0.2 -> 80%
                        Circle()
                            .trim(from: CGFloat( 1.0 - self.e50_75 ) , to: 1)
                            .stroke(LinearGradient(gradient: Gradient(colors: [ Color.RGB(red: 190, green: 190, blue: 190), Color.RGB(red: 190, green: 190, blue: 190)]), startPoint: .topLeading, endPoint: .bottomTrailing),
                                    style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [0, 0], dashPhase: 0))
                            .rotationEffect(Angle(degrees: 90))
                            .rotation3DEffect(.degrees(180), axis: (x: 1 , y: 0, z: 0) )
                            .frame(width: 115, height: 115)
                        
                        
                        VStack {
                            Text("Entre")
                            Text("50 a 74 años" )
                            if self.e50_75 == -1{
                              Text("-").bold().font(.system(size:20))
                            }else{ Text("\(String(format: "%.2f", self.e50_75) )").bold().font(.system(size:23))}
                            //
                        }
                    }
                    
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 120, height: 120)
                            .shadow(color: Color.primaryBlack.opacity( 0.2), radius: 10, x: 10, y: 10)
                            .shadow(color: Color.primaryWhite.opacity( 0.7), radius: 10, x: -5, y: -5)
                        
                        // trim 0.2 -> 80%
                        Circle()
                            .trim(from: CGFloat( 1.0 - self.e75_100) , to: 1)
                            .stroke(LinearGradient(gradient: Gradient(colors:[.lightBlue, .primaryBlue]), startPoint: .topLeading, endPoint: .bottomTrailing),
                                    style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [0, 0], dashPhase: 0))
                            .rotationEffect(Angle(degrees: 90))
                            .rotation3DEffect(.degrees(180), axis: (x: 1 , y: 0, z: 0) )
                            .frame(width: 115, height: 115)
                        
                                              
                        
                        VStack {
                            Text("Entre")
                            Text("75 a 100 años" )
                            if self.e75_100 == -1{
                              Text("-").bold().font(.system(size:20))
                            }else{ Text("\(String(format: "%.2f", self.e75_100) )").bold().font(.system(size:23))}
                           
                        }
                    }
                }
                
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 120, height: 120)
                        .shadow(color: Color.primaryBlack.opacity( 0.2), radius: 10, x: 10, y: 10)
                        .shadow(color: Color.primaryWhite.opacity( 0.7), radius: 10, x: -5, y: -5)
                    
                    // trim 0.2 -> 80%
                    Circle()
                        .trim(from: CGFloat( 1.0 - self.eMas100 ) , to: 1)
                        .stroke(LinearGradient(gradient: Gradient(colors: [.lightBlue, .primaryRed]), startPoint: .topLeading, endPoint: .bottomTrailing),
                                style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [0, 0], dashPhase: 0))
                        .rotationEffect(Angle(degrees: 90))
                        .rotation3DEffect(.degrees(180), axis: (x: 1 , y: 0, z: 0) )
                        .frame(width: 115, height: 115)
                    
                    
                    VStack {
                        
                        Text("Más de 100" )
                        Text("años")
                        if self.eMas100 == -1{
                          Text("-").bold().font(.system(size:20))
                        }else{ Text("\(String(format: "%.2f", self.eMas100) )").bold().font(.system(size:23))}
                    }
                    
                }
                                
            }.padding()
        }.padding()
    }
}

//¿Cual es el genero de persona con quien se tarda más la toma de datos?
private struct tiempoPorGenero:View{
    
    @Binding var tM: Double
    @Binding var tH: Double
    
    var body: some View{
        VStack{
            
            Text("Tiempo promedio").bold().font(.system(size:18))
            Text("de toma de datos")
            Text("por genero").bold().font(.system(size:18))
            VStack{
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 140, height: 140)
                        .shadow(color: Color.primaryBlack.opacity( 0.2), radius: 10, x: 10, y: 10)
                        .shadow(color: Color.primaryWhite.opacity( 0.7), radius: 10, x: -5, y: -5)
                    
                    // trim 0.2 -> 80%
                    Circle()
                    .trim(from: CGFloat( 0.0 - self.tH) , to: 1)
                    .stroke(LinearGradient(gradient: Gradient(colors: [.lightBlue, .primaryBlue]), startPoint: .topLeading, endPoint: .bottomTrailing),
                            style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [0, 0], dashPhase: 0))
                    .rotationEffect(Angle(degrees: 90))
                    .rotation3DEffect(.degrees(180), axis: (x: 1 , y: 0, z: 0) )
                    .frame(width: 130, height: 130)
                    
                    VStack {
                        Text("Hombres")
                        if self.tH == -1{
                          Text("-").bold().font(.system(size:20))
                        }else{
                            
                            Text("\(String(format: "%.2f", self.tH) )").bold().font(.system(size:23))
                            Text("minutos")
                        }
                    }
                }
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 140, height: 140)
                        .shadow(color: Color.primaryBlack.opacity( 0.2), radius: 10, x: 10, y: 10)
                        .shadow(color: Color.primaryWhite.opacity( 0.7), radius: 10, x: -5, y: -5)
                    
                    // trim 0.2 -> 80%
                    Circle()
                        .trim(from: CGFloat( 0.0 - self.tM) , to: 1)
                    .stroke(LinearGradient(gradient: Gradient(colors: [Color.RGB(red: 244, green: 151, blue: 142), Color.RGB(red: 255, green: 89, blue: 94)]), startPoint: .topLeading, endPoint: .bottomTrailing),
                            style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [0, 0], dashPhase: 0))
                    .rotationEffect(Angle(degrees: 90))
                    .rotation3DEffect(.degrees(180), axis: (x: 1 , y: 0, z: 0) )
                    .frame(width: 130, height: 130)
                    
                    VStack {
                        Text("Mujeres")
                        if self.tM == -1{
                          Text("-").bold().font(.system(size:20))
                        }else{
                            Text("\(String(format: "%.2f", self.tM) )").bold().font(.system(size:23))
                            Text("minutos")
                        }
                    }
                }
            }
            
        }.padding()
    }
    
    func segundos(){
        
    }
}

struct Paci2: Identifiable{
    var id = UUID()
    
    
    var ced: String
    var nom: String
    var tri: String
    var sex: String
    var ciu: String
    var edad: Int
    var tiempo: Int
}
