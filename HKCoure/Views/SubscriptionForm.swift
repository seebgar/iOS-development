//
//  SubscriptionForm.swift
//  HKCoure
//
//  Created by Sebastian on 2/29/20.
//  Copyright © 2020 Sebastian. All rights reserved.
//

import SwiftUI

struct SubscriptionForm: View {
    
    @EnvironmentObject var store: Store
    
    @State private var nombres: String = ""
    @State private var apellidos: String = ""
    @State private var cedula: String = ""
    @State private var showAlertSend: Bool = false
    
    var body: some View {
        ZStack {
            Color.offWhite
            
            NavigationView {
                Form {
                    
                    Section (header: Text("Datos generales")) {
                        HStack {
                            Text("Nombres")
                                .frame(width: 100)
                            Spacer()
                            TextField("", text: self.$nombres)
                        }
                        
                        HStack {
                            Text("Apellidos")
                                .frame(width: 100)
                            Spacer()
                            TextField("", text: self.$apellidos)
                        }
                        
                        HStack {
                            Text("No. Cédula")
                                .frame(width: 100)
                            Spacer()
                            TextField("", text: self.$cedula)
                        }
                    }
                    
                    Section (header: Text("Datos escaneados")) {
                        VStack {
                            ForEach ( recognizedTextResults, id: \.self ) {
                                Text("\($0)")
                            }
                        }
                    }
                    
                }
                .navigationBarTitle(Text("Inscripción"))
                .navigationBarItems(leading:
                    Button(action: {
                        self.store.showSubscriptionForm = false
                    }) {
                        Text("Cancelar")
                    },
                                    trailing:
                    Button(action: {
                        self.showAlertSend = true
                    }) {
                        Text("Enviar")
                    }
                )
            }
            .alert(isPresented: self.$showAlertSend) {
                Alert(title: Text("Inscripción realizada."), message: nil, dismissButton: .default(Text("OK"), action: {
                    recognizedTextResults = []
                    self.store.showSubscriptionForm = false
                }))
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .background(Color.offWhite)
        }
        .frame(maxWidth: .infinity)
        .background(Color.offWhite)
        .onAppear {
            // esto no se debería hacer
            while recognizedTextResults.isEmpty {
                sleep(1)
            }
            self.store.procesandoTexto = false
            if recognizedTextResults.count > 7 {
                self.nombres = recognizedTextResults[6]
                self.apellidos = recognizedTextResults[4]
                self.cedula = recognizedTextResults[3]
            }
            print(recognizedTextResults)
        }
    }
}

