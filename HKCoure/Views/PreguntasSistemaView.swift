//
//  PreguntasSistemaView.swift
//  HKCoure
//
//  Created by Pipe on 1/06/20.
//  Copyright © 2020 Sebastian. All rights reserved.
//

import SwiftUI
import UIKit
import FirebaseDatabase
import Network

struct PreguntasSistemasViews: View {
    
    
    @State var conexion: Bool = false
    @State var alert: Bool = false
    let defaults = UserDefaults.standard
    
    @EnvironmentObject var store: Store
    

    @State var tPromBuscar: Double = 0.789
    @State var vecesCaido: Int = 10
    @State var vecesCon: Int = 30
    @State var mayorProm: Double = 0
    
    var body: some View{
        VStack{
            HStack{
                Button(action: {
                    self.store.preguntasSistemaView = false
                    self.store.tiposAnalyticsView = true
                    
                }) {
                    Text("Volver").foregroundColor( Color.red)
                }
                Spacer()
                Text("Preguntas de Sistema").bold()
                Spacer()
            }.padding(.horizontal).padding(.top, 16)
            
            Divider()
            ScrollView (.vertical, showsIndicators: false) {
            VStack  (alignment: .center, spacing: 20) {
                
                
                tiempoBuscar(tProm: self.$tPromBuscar)
                Divider()
                mayorPromedio(nVeces: self.$mayorProm)
                }
            }
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
            var nPacientes = 0
            for i in 0..<pacientes!.count {
                let cedula = pacientes?[i] as? String
                let val = content?[cedula!] as? NSDictionary
                
                let fecha = val?["Fecha"] as? String ?? ""
                
                let formatter4 = DateFormatter()
                formatter4.dateFormat = "dd/MM/yyyy"
                let fechNaci = formatter4.date(from: fecha) ?? Date()
                
                let delta = Calendar.current.dateComponents([.year], from: fechNaci, to: Date()).year
                
                
                let actual = Paci2(ced: cedula!, nom: val?["Nombre"] as? String ?? "", tri: val?["Triage"] as? String ?? "", sex: val?["Sexo"] as? String ?? "", ciu: val?["Lugar"] as? String ?? "", edad: delta as? Int ?? 0, tiempo: val?["Tiempo"] as? Int ?? 0)
                nPacientes += 1
                if actual.tiempo >= 5{
                    self.mayorProm += 1
                }
                //self.paciList.append(actual)
            }
            
            if nPacientes == 0{
                self.mayorProm = 0
            }
            else{
                self.mayorProm = Double(self.mayorProm) / Double(nPacientes)
            }
            
            var crearTime = self.defaults.object(forKey:"ConexionTime") as? [Int] ?? [0,1]
            self.tPromBuscar = Double(crearTime[0]/crearTime[1])
            
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

//¿Cuanto tarda el sistema en buscar un paciente que ya tiene historia clinica en el hospital?

private struct tiempoBuscar:View{
    @Binding var tProm: Double
    
    var body: some View{
        VStack{
            Text("Tiempo promedio de busqueda").bold().font(.system(size:18))
            Text("de pacientes a")
            Text("en la base de datos").bold().font(.system(size:18))
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 150, height: 150)
                    .shadow(color: Color.primaryBlack.opacity( 0.2), radius: 10, x: 10, y: 10)
                    .shadow(color: Color.primaryWhite.opacity( 0.7), radius: 10, x: -5, y: -5)
                
                // trim 0.2 -> 80%
                Circle()
                .trim(from: CGFloat( 1.0 - 15) , to: 1)
                .stroke(LinearGradient(gradient: Gradient(colors: [.lightBlue, .primaryRed]), startPoint: .topLeading, endPoint: .bottomTrailing),
                        style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [0, 0], dashPhase: 0))
                .rotationEffect(Angle(degrees: 90))
                .rotation3DEffect(.degrees(180), axis: (x: 1 , y: 0, z: 0) )
                .frame(width: 145, height: 145)
                
                VStack {
                    Text("\(String(format: "%.3f", self.tProm))").font(.system(size:23)).bold()
                    Text("Segundos" ).font(.subheadline)
                }
            }
        }.padding()
    }
}

//¿Cuantas tomas de datos tardan más de la media en un rango de tiempo dado?

private struct mayorPromedio:View{
    
    @Binding var nVeces: Double
    
    var body: some View{
        VStack{
            Text("Porcentaje de toma de datos")
            Text("Mayores a 5 minutos").bold().font(.system(size:18))
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 150, height: 150)
                    .shadow(color: Color.primaryBlack.opacity( 0.2), radius: 10, x: 10, y: 10)
                    .shadow(color: Color.primaryWhite.opacity( 0.7), radius: 10, x: -5, y: -5)
                
                // trim 0.2 -> 80%
                Circle()
                    .trim(from: CGFloat( 1.0 - self.nVeces) , to: 1)
                .stroke(LinearGradient(gradient: Gradient(colors: [.lightBlue, .primaryRed]), startPoint: .topLeading, endPoint: .bottomTrailing),
                        style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [0, 0], dashPhase: 0))
                .rotationEffect(Angle(degrees: 90))
                .rotation3DEffect(.degrees(180), axis: (x: 1 , y: 0, z: 0) )
                .frame(width: 140, height: 140)
                
                VStack {
                    Text("\(String(format: "%.2f", 100 * self.nVeces) ) %").font(.system(size:25)).bold()
                }
            }
        }.padding()
    }
}
