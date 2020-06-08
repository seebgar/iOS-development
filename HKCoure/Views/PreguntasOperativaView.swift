//
//  AnaliticaOperativaView.swift
//  HKCoure
//
//  Created by Pipe on 1/06/20.
//  Copyright © 2020 Sebastian. All rights reserved.
//

import Foundation
import SwiftUI
import FirebaseDatabase
import Network


struct PreguntasOperativasView: View{
    
    @EnvironmentObject var store: Store
    
    
    @State var conexion: Bool = false
    @State var alert: Bool = false

    @State var totPacientes: Int = 0
    
    @State var genero: String = "Masculino"
    @State var internados: Int = 0
    @State var proporcion: Double = 1.3048
    @State var alergias: String = "Al azucar"
    @State var tipoS: String = ""
    
    //Empiezan en domingo
    @State var diasM: [Int] = [0,0,0,0,0,0,0]
    @State var diasF: [Int] = [0,0,0,0,0,0,0]
    
    @State var franjaHoraria: [Int] = [0,0,0,0]
    
    @State var triajeM: Double = 0.0
    @State var nTriajeM: Int = 0
    @State var triajeF: Double = 0.0
    @State var nTriajeF: Int = 0
    
    @State var tTriaje1: Double = 0.0
    @State var tTriaje2: Double = 0.0
    @State var tTriaje3: Double = 0.0
    
    @State var nTriaje1: Int = 0
    @State var nTriaje2: Int = 0
    @State var nTriaje3: Int = 0
    
    @State var sangre: [Int] = [0,0,0,0,0,0,0,0]
    
    @State var l = "Lunes"
    @State var m = "Martes"
    @State var mi = "Miercoles"
    @State var j = "Jueves"
    @State var v = "Viernes"
    @State var s = "Sabado"
    @State var d = "Domingo"

    
    
    var body: some View{
        VStack{
            HStack{
                Button(action: {
                    self.store.preguntasOperativasView = false
                    self.store.tiposAnalyticsView = true
                    
                }) {
                    Text("Volver").foregroundColor( Color.red)
                }
                Spacer()
                Text("Preguntas operativas").bold()
                Spacer()
            }.padding(.horizontal).padding(.top, 16)
            
            Divider()
            ScrollView (.vertical, showsIndicators: false) {
                VStack  (alignment: .center, spacing: 20) {
                    
                    VStack{
                        Text("Número de pacientes").bold().font(.system(size:18))
                        Text("por genero que llegaron")
                        Text("por día de la semana").bold().font(.system(size:18)).padding(.bottom, 7)
                        lunesYMartes(l: self.$l, m: self.$m,lM: self.$diasM[1], lF: self.$diasF[1], mM: self.$diasM[2], mF: self.$diasF[2])
                        lunesYMartes(l: self.$mi, m: self.$j ,lM: self.$diasM[3], lF: self.$diasF[3], mM: self.$diasM[4], mF: self.$diasF[4])
                        lunesYMartes(l: self.$v, m: self.$s ,lM: self.$diasM[5], lF: self.$diasF[5], mM: self.$diasM[6], mF: self.$diasF[6])
                        domingo(m: self.$d, mM: self.$diasM[0], mF: self.$diasF[0])
                    }
                    
                    

                    Divider()
                    franHoraria(total: self.$totPacientes, horas: self.$franjaHoraria)
                    Divider()
                    tipoSangre(sangre: self.$tipoS)
                    Divider()
                    tiempTriaje(tT1: self.$tTriaje1, tT2: self.$tTriaje2, tT3: self.$tTriaje3)
                    Divider()
                    triajePorGenero(tM: self.$triajeF, tH: self.$triajeM)
                    
                }
            }
        }.onAppear{
            self.conectionTest()
            self.getData()
        }

    }
    
    func getData(){
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.observeSingleEvent(of: .value,  with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            let content = value?["pacientes"] as? NSDictionary
            let pacientes = content?.allKeys
            var nPacientes = 0
            for i in 0..<pacientes!.count {
                let cedula = pacientes?[i] as? String
                let val = content?[cedula!] as? NSDictionary
                
                let fecha = val?["Fecha"] as? String ?? ""
                
                let formatter4 = DateFormatter()
                formatter4.dateFormat = "dd/MM/yyyy"
                let fechNaci = formatter4.date(from: fecha) ?? Date()
                
                let delta = Calendar.current.dateComponents([.year], from: fechNaci, to: Date()).year
                
                let fecha2 = val?["Hora"] as? String ?? ""
                
                let format = DateFormatter()
                format.dateFormat = "HH:mm dd/MM/yyyy"
                let fechLlegada = format.date(from: fecha2) ?? Date()
                let hor = Calendar.current.component(.hour, from: fechLlegada)
                let weekDay = Calendar.current.component(.weekday, from: fechLlegada)

                let actual = Paci3(ced: cedula!, nom: val?["Nombre"] as? String ?? "", tri: val?["Triage"] as? String ?? "", sex: val?["Sexo"] as? String ?? "", ciu: val?["Lugar"] as? String ?? "", edad: delta as? Int ?? 0, tiempo: val?["Tiempo"] as? Int ?? 0, sangre: val?["Sangre"] as? String ?? "")
                self.totPacientes += 1
                if weekDay == 1 && (actual.sex == "M" || actual.sex == "m"){
                    self.diasM[weekDay-1] = self.diasM[weekDay-1] + 1
                }else if weekDay == 1 && (actual.sex == "F" || actual.sex == "f"){
                    self.diasF[weekDay-1] = self.diasF[weekDay-1] + 1
                }
                if weekDay == 2 && (actual.sex == "M" || actual.sex == "m"){
                    self.diasM[weekDay-1] = self.diasM[weekDay-1] + 1
                }else if weekDay == 2 && (actual.sex == "F" || actual.sex == "f"){
                    self.diasF[weekDay-1] = self.diasF[weekDay-1] + 1
                }
                if weekDay == 3 && (actual.sex == "M" || actual.sex == "m"){
                    self.diasM[weekDay-1] = self.diasM[weekDay-1] + 1
                }else if weekDay == 3 && (actual.sex == "F" || actual.sex == "f"){
                    self.diasF[weekDay-1] = self.diasF[weekDay-1] + 1
                }
                if weekDay == 4 && (actual.sex == "M" || actual.sex == "m"){
                    self.diasM[weekDay-1] = self.diasM[weekDay-1] + 1
                }else if weekDay == 4 && (actual.sex == "F" || actual.sex == "f"){
                    self.diasF[weekDay-1] = self.diasF[weekDay-1] + 1
                }
                if weekDay == 5 && (actual.sex == "M" || actual.sex == "m"){
                    self.diasM[weekDay-1] = self.diasM[weekDay-1] + 1
                }else if weekDay == 5 && (actual.sex == "F" || actual.sex == "f"){
                    self.diasF[weekDay-1] = self.diasF[weekDay-1] + 1
                }
                if weekDay == 6 && (actual.sex == "M" || actual.sex == "m"){
                    self.diasM[weekDay-1] = self.diasM[weekDay-1] + 1
                }else if weekDay == 6 && (actual.sex == "F" || actual.sex == "f"){
                    self.diasF[weekDay-1] = self.diasF[weekDay-1] + 1
                }
                if weekDay == 7 && (actual.sex == "M" || actual.sex == "m"){
                    self.diasM[weekDay-1] = self.diasM[weekDay-1] + 1
                }else if weekDay == 7 && (actual.sex == "F" || actual.sex == "f"){
                    self.diasF[weekDay-1] = self.diasF[weekDay-1] + 1
                }
                
                if hor <= 5{
                    self.franjaHoraria[0] = self.franjaHoraria[0] + 1
                }
                else if hor > 5 && hor <= 11{
                    self.franjaHoraria[1] = self.franjaHoraria[1] + 1
                }
                else if hor > 11 && hor <= 17{
                    self.franjaHoraria[2] = self.franjaHoraria[2] + 1
                }
                else if hor > 17{
                    self.franjaHoraria[3] = self.franjaHoraria[3] + 1
                }
                
                if actual.sangre == "O+" || actual.sangre == "0+" || actual.sangre == "o+"{
                    self.sangre[0] = self.sangre[0] + 1
                }else if actual.sangre == "O-" || actual.sangre == "0-" || actual.sangre == "o-"{
                    self.sangre[1] = self.sangre[1] + 1
                }
                else if actual.sangre == "A+" || actual.sangre == "a+"{
                    self.sangre[2] = self.sangre[2] + 1
                }else if actual.sangre == "A-" || actual.sangre == "a-"{
                    self.sangre[3] = self.sangre[3] + 1
                }
                else if actual.sangre == "B+" || actual.sangre == "b+"{
                    self.sangre[4] = self.sangre[4] + 1
                }else if actual.sangre == "B-" || actual.sangre == "b-"{
                    self.sangre[5] = self.sangre[5] + 1
                }
                else if actual.sangre == "AB+" || actual.sangre == "ab+"{
                    self.sangre[6] = self.sangre[6] + 1
                }else if actual.sangre == "AB-" || actual.sangre == "ab-"{
                    self.sangre[7] = self.sangre[7] + 1
                }
                
                if actual.tri == "1" {
                    self.nTriaje1 += 1
                    self.tTriaje1 += Double(actual.tiempo) ?? 0
                    if actual.sex == "M" || actual.sex == "m"{
                        self.nTriajeM += 1
                        self.triajeM += 1
                    }else{
                        self.nTriajeF += 1
                        self.triajeF += 1
                    }
                }
                else if actual.tri == "2" {
                    self.nTriaje2 += 1
                    self.tTriaje2 += Double(actual.tiempo) ?? 0
                    if actual.sex == "M" || actual.sex == "m"{
                        self.nTriajeM += 1
                        self.triajeM += 2
                    }else{
                        self.nTriajeF += 1
                        self.triajeF += 2
                    }
                }
                else if actual.tri == "3" {
                    self.nTriaje3 += 1
                    self.tTriaje3 += Double(actual.tiempo) ?? 0
                    if actual.sex == "M" || actual.sex == "m"{
                        self.nTriajeM += 1
                        self.triajeM += 3
                    }else{
                        self.nTriajeF += 1
                        self.triajeF += 3
                    }
                }
                
                if self.nTriaje1 == 0 {self.tTriaje1 = -1}
                else {
                    self.tTriaje1 = self.tTriaje1 / Double(self.nTriaje1)
                }
                if self.nTriaje2 == 0 {self.tTriaje2 = -1}
                else {
                    self.tTriaje2 = self.tTriaje2 / Double(self.nTriaje2)
                }
                if self.nTriaje3 == 0 {self.tTriaje3 = -1}
                else {
                    self.tTriaje3 = self.tTriaje3 / Double(self.nTriaje3)
                }
                
                
                if self.nTriajeM == 0 { self.triajeM = -1}
                else{
                    self.triajeM = self.triajeM / Double(self.nTriajeM)
                }
                if self.nTriajeF == 0 { self.triajeF = -1}
                else{
                    self.triajeF = self.triajeF / Double(self.nTriajeF)
                }
                
                self.tipoS = self.mayorSangre()
                //self.paciList.append(actual)
            }
            print(self.franjaHoraria[0])
            print(self.totPacientes)
            print((Double(self.franjaHoraria[0])/Double(self.totPacientes)))
            print("------------------------")
            print(self.diasM)
            print(self.diasF)
            
            
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
    
    func mayorSangre() -> String
    {
        if self.sangre[0] >= self.sangre[1] && self.sangre[0] >= self.sangre[2] && self.sangre[0] >= self.sangre[3] && self.sangre[0] >= self.sangre[4] && self.sangre[0] >= self.sangre[5] && self.sangre[0] >= self.sangre[6] && self.sangre[0] >= self.sangre[7]{
            return "0+"
        }
        else if self.sangre[1] >= self.sangre[0] && self.sangre[1] >= self.sangre[2] && self.sangre[1] >= self.sangre[3] && self.sangre[1] >= self.sangre[4] && self.sangre[1] >= self.sangre[5] && self.sangre[1] >= self.sangre[6] && self.sangre[1] >= self.sangre[7]{
            return "0-"
        }
        else if self.sangre[2] >= self.sangre[0] && self.sangre[2] >= self.sangre[1] && self.sangre[2] >= self.sangre[3] && self.sangre[2] >= self.sangre[4] && self.sangre[2] >= self.sangre[5] && self.sangre[2] >= self.sangre[6] && self.sangre[2] >= self.sangre[7]{
            return "A+"
        }
        else if self.sangre[3] >= self.sangre[0] && self.sangre[3] >= self.sangre[1] && self.sangre[3] >= self.sangre[2] && self.sangre[3] >= self.sangre[4] && self.sangre[3] >= self.sangre[5] && self.sangre[3] >= self.sangre[6] && self.sangre[3] >= self.sangre[7]{
            return "A-"
        }
        else if self.sangre[4] >= self.sangre[0] && self.sangre[4] >= self.sangre[1] && self.sangre[4] >= self.sangre[2] && self.sangre[4] >= self.sangre[4] && self.sangre[3] >= self.sangre[5] && self.sangre[4] >= self.sangre[6] && self.sangre[4] >= self.sangre[7]{
            return "B+"
        }
        else if self.sangre[5] >= self.sangre[0] && self.sangre[5] >= self.sangre[1] && self.sangre[5] >= self.sangre[2] && self.sangre[5] >= self.sangre[4] && self.sangre[5] >= self.sangre[4] && self.sangre[5] >= self.sangre[6] && self.sangre[5] >= self.sangre[7]{
            return "B-"
        }
        else if self.sangre[6] >= self.sangre[0] && self.sangre[6] >= self.sangre[1] && self.sangre[6] >= self.sangre[2] && self.sangre[6] >= self.sangre[4] && self.sangre[6] >= self.sangre[4] && self.sangre[6] >= self.sangre[5] && self.sangre[6] >= self.sangre[7]{
            return "AB+"
        }
        else {
            return "AB-"
        }
    }

}

private struct lunesYMartes:View{
    
    @Binding var l: String
    @Binding var m: String
    
    @Binding var lM: Int
    @Binding var lF: Int
    @Binding var mM: Int
    @Binding var mF: Int
    
    var body: some View{
        HStack{
            VStack{
                Text(self.l).font(.system(size:15)).bold().padding(.top, 5)
                    ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 120, height: 120)
                        .shadow(color: Color.primaryBlack.opacity( 0.2), radius: 10, x: 10, y: 10)
                        .shadow(color: Color.primaryWhite.opacity( 0.7), radius: 10, x: -5, y: -5)
                    if self.lM + self.lF != 0{
                        Circle()
                            .trim(from: CGFloat( 1.0 - (Double(self.lM) / Double(self.lM + self.lF))) , to: 1)
                        .stroke(LinearGradient(gradient: Gradient(colors: [.lightBlue, .primaryBlue]), startPoint: .topLeading, endPoint: .bottomTrailing),
                                style: StrokeStyle(lineWidth: 10, lineJoin: .round, miterLimit: .infinity, dash: [0, 0], dashPhase: 0))
                        .rotationEffect(Angle(degrees: 90))
                        .rotation3DEffect(.degrees(180), axis: (x: 1 , y: 0, z: 0) )
                        .frame(width: 110, height: 110)
                        
                        // trim 0.2 -> 80%
                        Circle()
                            .trim(from: 0.0 , to: CGFloat((Double(self.lF) / Double(self.lM + self.lF))))
                        .stroke(LinearGradient(gradient: Gradient(colors: [Color.RGB(red: 244, green: 151, blue: 142), Color.RGB(red: 255, green: 89, blue: 94)]), startPoint: .topLeading, endPoint: .bottomTrailing),
                                style: StrokeStyle(lineWidth: 10, lineJoin: .round, miterLimit: .infinity, dash: [0, 0], dashPhase: 0))
                        .rotationEffect(Angle(degrees: 90))
                        .rotation3DEffect(.degrees(180), axis: (x: 1 , y: 0, z: 0) )
                        .frame(width: 110, height: 110)
                    }
                        VStack {
                            Text("Hombres")
                            if self.lM == 0{
                                Text("-").font(.system(size:18)).bold()
                            }else{ Text(String(self.lM)).font(.system(size:18)).bold() }
                            Text("Mujeres")
                            if self.lF == 0 {
                                Text("-").font(.system(size:18)).bold()
                            }else { Text(String(self.lF)).font(.system(size:18)).bold() }
                        }
                }
                
            }
            VStack{
                Text(self.m).font(.system(size:15)).bold().padding(.top, 5)
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 120, height: 120)
                        .shadow(color: Color.primaryBlack.opacity( 0.2), radius: 10, x: 10, y: 10)
                        .shadow(color: Color.primaryWhite.opacity( 0.7), radius: 10, x: -5, y: -5)
                    if self.mM + self.mF != 0{
                        Circle()
                            .trim(from: CGFloat( 1.0 - (Double(self.mM) / Double(self.mM + self.mF))) , to: 1)
                        .stroke(LinearGradient(gradient: Gradient(colors: [.lightBlue, .primaryBlue]), startPoint: .topLeading, endPoint: .bottomTrailing),
                                style: StrokeStyle(lineWidth: 10, lineJoin: .round, miterLimit: .infinity, dash: [0, 0], dashPhase: 0))
                        .rotationEffect(Angle(degrees: 90))
                        .rotation3DEffect(.degrees(180), axis: (x: 1 , y: 0, z: 0) )
                        .frame(width: 110, height: 110)
                        
                        // trim 0.2 -> 80%
                        Circle()
                            .trim(from: 0.0 , to: CGFloat((Double(self.mF) / Double(self.mM + self.mF))))
                        .stroke(LinearGradient(gradient: Gradient(colors: [Color.RGB(red: 244, green: 151, blue: 142), Color.RGB(red: 255, green: 89, blue: 94)]), startPoint: .topLeading, endPoint: .bottomTrailing),
                                style: StrokeStyle(lineWidth: 10, lineJoin: .round, miterLimit: .infinity, dash: [0, 0], dashPhase: 0))
                        .rotationEffect(Angle(degrees: 90))
                        .rotation3DEffect(.degrees(180), axis: (x: 1 , y: 0, z: 0) )
                        .frame(width: 110, height: 110)
                    }
                        VStack {
                            Text("Hombres")
                            if self.mM == 0{
                                Text("-").font(.system(size:18)).bold()
                            }else{ Text(String(self.mM)).font(.system(size:18)).bold() }
                            Text("Mujeres")
                            if self.mF == 0 {
                                Text("-").font(.system(size:18)).bold()
                            }else { Text(String(self.mF)).font(.system(size:18)).bold() }
                        }
                }
            }
    }
}
}

private struct domingo: View{
    
    @Binding var m:String
    
    @Binding var mM: Int
    @Binding var mF: Int
    
    var body:some View{
        VStack{
            Text(self.m).font(.system(size:15)).bold()
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 120, height: 120)
                    .shadow(color: Color.primaryBlack.opacity( 0.2), radius: 10, x: 10, y: 10)
                    .shadow(color: Color.primaryWhite.opacity( 0.7), radius: 10, x: -5, y: -5)
                if self.mM + self.mF != 0{
                    Circle()
                        .trim(from: CGFloat( 1.0 - (Double(self.mM) / Double(self.mM + self.mF))) , to: 1)
                    .stroke(LinearGradient(gradient: Gradient(colors: [.lightBlue, .primaryBlue]), startPoint: .topLeading, endPoint: .bottomTrailing),
                            style: StrokeStyle(lineWidth: 10, lineJoin: .round, miterLimit: .infinity, dash: [0, 0], dashPhase: 0))
                    .rotationEffect(Angle(degrees: 90))
                    .rotation3DEffect(.degrees(180), axis: (x: 1 , y: 0, z: 0) )
                    .frame(width: 110, height: 110)
                    
                    // trim 0.2 -> 80%
                    Circle()
                        .trim(from: 0.0 , to: CGFloat((Double(self.mF) / Double(self.mM + self.mF))))
                    .stroke(LinearGradient(gradient: Gradient(colors: [Color.RGB(red: 244, green: 151, blue: 142), Color.RGB(red: 255, green: 89, blue: 94)]), startPoint: .topLeading, endPoint: .bottomTrailing),
                            style: StrokeStyle(lineWidth: 10, lineJoin: .round, miterLimit: .infinity, dash: [0, 0], dashPhase: 0))
                    .rotationEffect(Angle(degrees: 90))
                    .rotation3DEffect(.degrees(180), axis: (x: 1 , y: 0, z: 0) )
                    .frame(width: 110, height: 110)
                }
                    VStack {
                        Text("Hombres")
                        if self.mM == 0{
                            Text("-").font(.system(size:18)).bold()
                        }else{ Text(String(self.mM)).font(.system(size:18)).bold() }
                        Text("Mujeres")
                        if self.mF == 0 {
                            Text("-").font(.system(size:18)).bold()
                        }else { Text(String(self.mF)).font(.system(size:18)).bold() }
                    }
            }
        }
    }
}

private struct franHoraria: View{
    @Binding var total: Int
    @Binding var horas: [Int]
    var body: some View {
        VStack{
            Text("Llegada de pacientes")
            Text("por franja horaria").bold().font(.system(size:18))
            
            HStack (alignment: .center, spacing: 20) {
                
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 140, height: 140)
                        .shadow(color: Color.primaryBlack.opacity( 0.2), radius: 10, x: 10, y: 10)
                        .shadow(color: Color.primaryWhite.opacity( 0.7), radius: 10, x: -5, y: -5)
                    
                    // trim 0.2 -> 80%
                    Circle()
                        .trim(from: CGFloat(1-(Double(self.horas[0])/Double(self.total)) ) , to: 1)
                        .stroke(LinearGradient(gradient: Gradient(colors: [.lightRed, .primaryRed]), startPoint: .topLeading, endPoint: .bottomTrailing),
                                style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [0, 0], dashPhase: 0))
                        .rotationEffect(Angle(degrees: 90))
                        .rotation3DEffect(.degrees(180), axis: (x: 1 , y: 0, z: 0) )
                        .frame(width: 130, height: 130)
                    
                    
                    VStack {
                        Text("Madrugada").bold()
                        Text("antes de 6 am" )
                        Text(String(self.horas[0])).bold().font(.system(size:17))
                        Text("pacientes")
                        //
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
                        .trim(from: CGFloat( 1.0 - (Double(self.horas[1])/Double(self.total))) , to: 1)
                        .stroke(LinearGradient(gradient: Gradient(colors:[ Color.RGB(red: 112, green: 112, blue: 112), Color.RGB(red: 112, green: 112, blue: 112)]), startPoint: .topLeading, endPoint: .bottomTrailing),
                                style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [0, 0], dashPhase: 0))
                        .rotationEffect(Angle(degrees: 90))
                        .rotation3DEffect(.degrees(180), axis: (x: 1 , y: 0, z: 0) )
                        .frame(width: 130, height: 130)
                    
                                          
                    
                    VStack {
                        Text("Mañana").bold()
                        Text("de 6 am a 12 pm" )
                        Text(String(self.horas[1])).font(.system(size:17)).bold()
                        Text("pacientes")
                       
                    }
                }
            }
            
            HStack (alignment: .center, spacing: 20) {
                
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 140, height: 140)
                        .shadow(color: Color.primaryBlack.opacity( 0.2), radius: 10, x: 10, y: 10)
                        .shadow(color: Color.primaryWhite.opacity( 0.7), radius: 10, x: -5, y: -5)
                    
                    // trim 0.2 -> 80%
                    Circle()
                        .trim(from: CGFloat( 1.0 - (Double(self.horas[2])/Double(self.total)) ) , to: 1)
                        .stroke(LinearGradient(gradient: Gradient(colors: [ Color.RGB(red: 190, green: 190, blue: 190), Color.RGB(red: 190, green: 190, blue: 190)]), startPoint: .topLeading, endPoint: .bottomTrailing),
                                style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [0, 0], dashPhase: 0))
                        .rotationEffect(Angle(degrees: 90))
                        .rotation3DEffect(.degrees(180), axis: (x: 1 , y: 0, z: 0) )
                        .frame(width: 130, height: 130)
                    
                    
                    VStack {
                        Text("Tarde").bold()
                        Text("de 12 pm a 6 pm" )
                        Text(String(self.horas[2])).bold().font(.system(size:17))
                        Text("pacientes")
                        //
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
                        .trim(from: CGFloat( 1.0 - (Double(self.horas[3])/Double(self.total))) , to: 1)
                        .stroke(LinearGradient(gradient: Gradient(colors:[.lightBlue, .primaryBlue]), startPoint: .topLeading, endPoint: .bottomTrailing),
                                style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [0, 0], dashPhase: 0))
                        .rotationEffect(Angle(degrees: 90))
                        .rotation3DEffect(.degrees(180), axis: (x: 1 , y: 0, z: 0) )
                        .frame(width: 130, height: 130)
                    
                                          
                    
                    VStack {
                        Text("Noche").bold()
                        Text("de 6 pm a 12 am" )
                        Text(String(self.horas[3])).font(.system(size:17)).bold()
                        Text("pacientes")
                       
                    }
                }
            }
            
        }
    }
}

private struct tipoSangre:View{
    @Binding var sangre: String
    
    var body: some View{
        VStack{
            Text("Tipo de sangre").bold().font(.system(size:18))
            Text("más comun")
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 140, height: 140)
                    .shadow(color: Color.primaryBlack.opacity( 0.2), radius: 10, x: 10, y: 10)
                    .shadow(color: Color.primaryWhite.opacity( 0.7), radius: 10, x: -5, y: -5)
                
                // trim 0.2 -> 80%
                Circle()
                .trim(from: CGFloat( 1.0 - 15) , to: 1)
                .stroke(LinearGradient(gradient: Gradient(colors: [.lightBlue, .primaryRed]), startPoint: .topLeading, endPoint: .bottomTrailing),
                        style: StrokeStyle(lineWidth: 7, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [0, 0], dashPhase: 0))
                .rotationEffect(Angle(degrees: 90))
                .rotation3DEffect(.degrees(180), axis: (x: 1 , y: 0, z: 0) )
                .frame(width: 133, height: 133)
                
                VStack {
                    Text((String(self.sangre))).font(.system(size:33)).bold()
                }
            }
        }.padding()
    }
}

private struct tiempTriaje: View{
    
    @Binding var tT1: Double
    @Binding var tT2: Double
    @Binding var tT3: Double
    
    var body : some View{
        VStack {
        Text("Tiempo promedio").bold().font(.system(size:18))
        Text("de lectura de datos")
        Text("por triaje").bold().font(.system(size:18))
        
        HStack (alignment: .center, spacing: 20) {
            
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 98, height: 98)
                    .shadow(color: Color.primaryBlack.opacity( 0.2), radius: 10, x: 10, y: 10)
                    .shadow(color: Color.primaryWhite.opacity( 0.7), radius: 10, x: -5, y: -5)
                
                // trim 0.2 -> 80%
                if self.tT1 != -1{
                    Circle()
                    .stroke(LinearGradient(gradient: Gradient(colors: [.lightRed, .primaryRed]), startPoint: .topLeading, endPoint: .bottomTrailing),
                            style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [0, 0], dashPhase: 0))
                    .rotationEffect(Angle(degrees: 90))
                    .rotation3DEffect(.degrees(180), axis: (x: 1 , y: 0, z: 0) )
                    .frame(width: 88, height: 88)
                }
                
                VStack {
                    Text("Nivel 1" )
                    if self.tT1 == -1 {
                        Text("-").bold()
                    }else{
                        Text("\(String(format: "%.2f", self.tT1) )").bold()
                    }
                    Text("Minutos")
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
                if self.tT2 != -1{
                    Circle()
                        .stroke(LinearGradient(gradient: Gradient(colors:[ Color.RGB(red: 112, green: 112, blue: 112), Color.RGB(red: 112, green: 112, blue: 112)]), startPoint: .topLeading, endPoint: .bottomTrailing),
                                style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [0, 0], dashPhase: 0))
                        .rotationEffect(Angle(degrees: 90))
                        .rotation3DEffect(.degrees(180), axis: (x: 1 , y: 0, z: 0) )
                        .frame(width: 88, height: 88)
                }
                                      
                VStack {
                    
                    Text("Nivel 2" )
                    if self.tT2 == -1{
                        Text("-").bold()
                    }else{
                        Text("\(String(format: "%.2f", self.tT2) )").bold()
                    }
                    Text("minutos")
                   
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
                if self.tT3 != -1{
                    
                    Circle()
                        .stroke(LinearGradient(gradient: Gradient(colors: [.lightBlue, .primaryBlue]), startPoint: .topLeading, endPoint: .bottomTrailing),
                                style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [0, 0], dashPhase: 0))
                        .rotationEffect(Angle(degrees: 90))
                        .rotation3DEffect(.degrees(180), axis: (x: 1 , y: 0, z: 0) )
                        .frame(width: 88, height: 88)
                    
                }
                    VStack {
                        
                        Text("Nivel 3" )
                        if self.tT3 == -1 {
                            Text("-").bold()
                        }else{
                            Text("\(String(format: "%.2f", self.tT3) )").bold()
                        }
                        Text("minutos")
                    }
                    
                }
                
                
                
            }.padding()
    }
}

private struct triajePorGenero:View{
    
    @Binding var tM: Double
    @Binding var tH: Double
    
    var body: some View{
        VStack{
            
            Text("Triaje promedio").bold().font(.system(size:18))
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
                        }
                    }
                }
            }
            
        }.padding()
    }
    
    func segundos(){
        
    }
}

struct Paci3: Identifiable{
    var id = UUID()
    
    
    var ced: String
    var nom: String
    var tri: String
    var sex: String
    var ciu: String
    var edad: Int
    var tiempo: Int
    var sangre:String
}
