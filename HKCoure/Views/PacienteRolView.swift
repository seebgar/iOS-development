//
//  PacienteRolView.swift
//  HKCoure
//
//  Created by Pipe on 26/04/20.
//  Copyright © 2020 Sebastian. All rights reserved.
//
import SwiftUI
import FirebaseDatabase

struct PacienteRolView: View{
    @EnvironmentObject var store: Store
    
    @State private var showProfile: Bool = false
    
    var body : some View{
        ZStack {
            VStack {
                //HEADER
                Header(showProfile: self.$showProfile, store: self.store)
                
                VStack (spacing: 24) {
                    
                    HStack (spacing: 16) {
                        Spacer()
                        VStack {
                            Text("¡Hola!").font(.headline)
                            Text("\(self.store.pacienteActual.nombre!)").font(.body)
                        }
                        
                        Spacer()
                    }.padding(.vertical, 32)
                    
                    HStack (spacing: 16) {
                        Spacer()
                        VStack {
                            Text("Motivo").font(.headline).frame(alignment: .leading)
                            Text("\(self.store.pacienteActual.motivo!)").font(.body)
                        }
                        Spacer()
                        VStack {
                            Text("Alergias").font(.headline).frame(alignment: .leading)
                            Text("\(self.store.pacienteActual.alergias!)").font(.body)
                        }
                        Spacer()
                    }
                    
                    HStack (spacing: 16) {
                        Spacer()
                        VStack {
                            Text("Sintomas").font(.headline).frame(alignment: .leading)
                            Text("\(self.store.pacienteActual.sintomas!)").font(.body)
                        }
                        Spacer()
                        VStack {
                            Text("Pulso").font(.headline).frame(alignment: .leading)
                            Text("\(self.store.pacienteActual.pulso)").font(.body)
                        }
                        Spacer()
                    }
                    
                    HStack (spacing: 16) {
                        Spacer()
                        VStack {
                            Text("Respiración").font(.headline).frame(alignment: .leading)
                            Text("\(self.store.pacienteActual.saturacion)").font(.body)
                        }
                        Spacer()
                        VStack {
                            Text("Temperatura").font(.headline).frame(alignment: .leading)
                            Text("\(self.store.pacienteActual.temperatura)").font(.body)
                        }
                        Spacer()
                    }
                    
                    HStack (spacing: 16) {
                        Spacer()
                        VStack {
                            
                            Text("Tensión").font(.headline).frame(alignment: .leading)
                            Text("\(self.store.pacienteActual.tension!)").font(.body)
                        }
                        Spacer()
                        VStack {
                            Text("Área").font(.headline).frame(alignment: .leading)
                            Text("\(self.store.pacienteActual.area)").font(.body)
                        }
                        Spacer()
                        VStack {
                            Text("Triage").font(.headline).frame(alignment: .leading)
                            Text("\(self.store.pacienteActual.triage)").font(.body)
                        }
                        Spacer()
                    }
                    
                    
                    Spacer()
                }.padding()
                Spacer()
            }
        }
    }
}

private struct Header: View {
    @Binding var showProfile: Bool
    var store: Store
    var body: some View {
        ZStack {
            HStack {
                Text("HK Coure")
                    .font(.title)
                    .foregroundColor(.primaryBlack)
                Spacer()
                Button(action: {
                    self.store.listView = false
                    self.store.isLogged = false
                    self.store.isPacient = false
                }) {
                    Text("Salir").font(.body)
                }
            }
            .padding(.top, deviceBounds.width < 700 ? 64 : 80)
            .padding(.bottom, 48)
        }.frame(width: deviceBounds.width < 700 ? deviceBounds.width * 0.8 : deviceBounds.width * 0.6)
    }
}



