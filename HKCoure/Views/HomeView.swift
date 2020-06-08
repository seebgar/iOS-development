//
//  HomeView.swift
//  HKCoure
//
//  Created by Sebastian on 2/28/20.
//  Copyright © 2020 Sebastian. All rights reserved.
//

import SwiftUI
import FirebaseDatabase

struct HomeView: View {
    
    @EnvironmentObject var store: Store
    
    
    let defaults = UserDefaults.standard
    
    var usuario: String
    
    @State private var showCamera: Bool = false
    @State private var showPhoto: Bool = false
    @State private var showSheet: Bool = false
    @State private var showProfile: Bool = false
    @State private var profileHeightModifier: CGSize = CGSize.zero
    @State private var didFinishImagePicker: Bool = false
    @State private var didFinishCamera: Bool = false
    @State private var showForm: Bool = false
    @State private var showList: Bool = false
    @State private var promCreacion: Double = 0.0
    @State private var promBuscar: Double = 0.0
    @State private var numPas: String = "..."
    @State private var paciList: [Paci] = []
    
    var body: some View {
        ZStack {
            
            Color.offWhite
            
            VStack {
                //HEADER
                Header(showProfile: self.$showProfile)
                
                StadisticsContent(numPas: self.$numPas, promCre: self.$promCreacion, promBus: self.$promBuscar)
                
                //CARDS
                CardsContent(showPhoto: self.$showPhoto, showCamera: self.$showCamera, showSheet: self.$showSheet, showForm: self.$showForm, showList: self.$showList)
                
                Spacer()
                
            }
            .scaleEffect(x: showProfile ? 0.86 : 1, y: showProfile ? 0.86 : 1)
            .animation(.default)
            
            Color.offBlack.opacity(self.showProfile ? 0.2 : 0.0).onTapGesture {self.showProfile.toggle()}.animation(.customSpring)
            
            ProfileView()
                .offset(y: self.showProfile ? 0.0 :  deviceBounds.height)
                .offset(y: self.profileHeightModifier.height)
                .gesture(DragGesture().onChanged({
                    self.profileHeightModifier = $0.translation
                }).onEnded({ value in
                    if self.profileHeightModifier.height > 50 {
                        self.showProfile = false
                    }
                    self.profileHeightModifier = .zero
                }))
                .animation(.customSpring)
            
            
            //LOADER
            if self.store.procesandoTexto {
                LoadingView()
            }
            
            
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear{
            self.analitica()
            var crearTime = self.defaults.object(forKey:"CrearTime") as? [Int] ?? [0,1]
            self.promCreacion = Double(crearTime[0]/crearTime[1])
            var buscarTime = self.defaults.object(forKey:"BuscarTime") as? [Int] ?? [0,1]
            self.promBuscar = Double(buscarTime[0]/buscarTime[1])
        }
        .sheet(isPresented: self.$showSheet) {
            Group {
                if self.showPhoto {
                    TextRecognitionView(didFinishPicker: self.$didFinishImagePicker)
                        .onAppear {
                            self.store.procesandoTexto = true
                    }
                    .onDisappear {
                        self.store.showSubscriptionForm = self.didFinishImagePicker
                    }
                }
                else if self.showForm {
                    
                }
                else if self.showList{
                    //PacientesLis
                }
                else {
                    DocumentRecognitionView(didFinishCamera: self.$didFinishCamera)
                        .onAppear {
                            self.store.procesandoTexto = true
                    }
                    .onDisappear {
                        self.store.showSubscriptionForm = self.didFinishCamera 
                    }
                }
            }
        }
        
    }
    
    // Solicita la información a la base de datos e informa en el inicio de la aplicación
    func analitica(){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.observeSingleEvent(of: .value,  with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            let content = value?["pacientes"] as? NSDictionary
            var pacientes = content?.allKeys
            for i in (0..<pacientes!.count ?? Range(-1...(-1))){
                let cedula = pacientes?[i] as? String
                let val = content?[cedula] as? NSDictionary
                let actual = Paci(ced: cedula!, nom: val?["Nombre"] as? String ?? "", tri: val?["Triage"] as? String ?? "", sex: val?["Sexo"] as? String ?? "", ciu: val?["Lugar"] as? String ?? "")
                self.paciList.append(actual)
                
            }
            self.numPas = String(self.paciList.count)
            
        }){(error) in
            print("----------------------Falla")
            print(error.localizedDescription)
        }
    }
}



private struct Header: View {
    @Binding var showProfile: Bool
    var body: some View {
        ZStack {
            HStack {
                Text("HK Coure")
                    .font(.title)
                    .foregroundColor(.primaryBlack)
                Spacer()
                Button(action: {
                    self.showProfile.toggle()
                }) {
                    Text("Perfil").font(.body)
//                    Image("person").renderingMode(.original).resizable()
//                        .frame(width: 64, height: 64)
//                        .clipShape(Circle())
//                        .overlay(Circle().stroke(Color.secondaryRed, lineWidth: 4))
                }
            }
            .padding(.top, deviceBounds.width < 700 ? 64 : 80)
            .padding(.bottom, 5)
        }.frame(width: deviceBounds.width < 700 ? deviceBounds.width * 0.8 : deviceBounds.width * 0.6)
    }
}

private struct StadisticsContent: View{
    @Binding var numPas: String
    @Binding var promCre: Double
    @Binding var promBus: Double

    @EnvironmentObject var store: Store
    
    var body: some View{
        VStack{
                        HStack{
                            VStack{
                                Text("Tiempo prom.").padding(.all, 3)
                                Text("por formulario")
                                Text("de consulta")
                                Text("\(String(format: "%.2f", self.promBus) )").font(.system(size:22)).bold().padding(.top,10)
                                Text("segundos")
           
                                  }
                            
                                   VStack{
                                           Text("Tiempo prom.").padding(.all, 3)
                                    Text("por formulario")
                                    Text("de creación")
                                    Text("\(String(format: "%.2f", self.promCre) )").font(.system(size:22)).bold().padding(.top,10)
                                    Text("segundos")
            
                                   }
                                   VStack{
                                    Text("").padding(.all, 3)
                                           Text("Pacientes")
                                    Text("recibidos")
                                    Text(numPas).font(.system(size:22)).bold().padding(.top,10)
                                    Text("personas")
                                   }
                        }.padding(.vertical, 15)
        }
        
    }
}



private struct CardsContent: View {
    
    @Binding var showPhoto: Bool
    @Binding var showCamera: Bool
    @Binding var showSheet: Bool
    @Binding var showForm: Bool
    @Binding var showList: Bool
    @EnvironmentObject var store: Store
    
    var body: some View {
        VStack (spacing: 30) {
            Button(action: {
                self.store.tiposAnalyticsView = true
                //self.store.analyticsView = true
                
            }) {
                Text("Ver Analytics")
                    .foregroundColor(.primaryBlack)
                    .bold()
            }.buttonStyle(CardButtonStyle())
            Button(action: {
                self.store.serachView = true
                
            }) {
                Text("Consultar")
                    .foregroundColor(.primaryBlack)
                    .bold()
            }
            .buttonStyle(CardButtonStyle())
            Button(action: {
                self.store.addPacien = true
            }) {
                Text("Nuevo Paciente")
                    .foregroundColor(.primaryBlack)
                    .bold()
            }
            .buttonStyle(CardButtonStyle())
            Button(action: {
                self.store.listView = true
            }) {
                Text("Listar pacientes")
                    .foregroundColor(.primaryBlack)
                    .bold()
            }
            .buttonStyle(CardButtonStyle())
            Button(action: {
                self.store.alarmView = true
            }) {
                Text("Ayuda")
                    .foregroundColor(.primaryWhite)
                    .bold()
            }
            .buttonStyle(DarkButtonStyle(paddingHorizontal: 120))
        }
    }
}
