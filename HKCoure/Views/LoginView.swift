//
//  LoginView.swift
//  HKCoure
//
//  Created by Sebastian on 2/28/20.
//  Copyright © 2020 Sebastian. All rights reserved.
//

import SwiftUI
import LocalAuthentication
import FirebaseDatabase
import FirebaseAuth
import Network

struct LoginView: View {
    
    @State var email: String = ""
    @State var pass: String = ""
    @State var msg: String = ""
    @State var shown: Bool = false
    @State var paciente: Bool = false
    
    @State private var keyboardHeight: CGFloat = 0
    
    private func keyboardGuard() -> Void {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (notification) in
            let keyboardRect = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            let height = keyboardRect.height
            self.keyboardHeight = height
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (notification) in
            self.keyboardHeight = 0
        }
    }
    
    private func authenticate(){
        
    }
    
    var body: some View {
        ZStack {
            LinearGradient(Color.offRed, Color.offRed)
            VStack {
                // CONTENT
                LoginContent(keyboardHeight: self.$keyboardHeight, email: self.$email, pass: self.$pass, msg: self.$msg, shown: self.$shown, paciente: self.$paciente)
            }
            .offset(y: -self.keyboardHeight)
            .animation(.customSpring)
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            self.keyboardGuard()
        }
    }
}



private struct LoginContent: View {
    @Binding var keyboardHeight: CGFloat
    @Binding var email: String
    @Binding var pass: String
    @Binding var msg: String
    @Binding var shown: Bool
    @Binding var paciente: Bool
    var body: some View {
        VStack {
            //HEADER
            Header(keyboardHeight: self.$keyboardHeight)
            VStack {
                // FORM
                LoginForm(email: self.$email, pass: self.$pass, paciente: self.$paciente)
                // BUTTON
                EnterButton(email: self.$email, pass: self.$pass, msg: self.$msg, shown: self.$shown, paciente: self.$paciente)
            }
            .padding(.horizontal, 32)
            .frame(maxWidth: .infinity)
            .offset(x: 0, y: -60)
        }
    }
}



private struct Header: View {
    @Binding var keyboardHeight: CGFloat
    var body: some View {
        VStack (alignment: .leading) {
            ZStack {
                HStack (alignment: .top) {
                    VStack (alignment: .leading) {
                        Text("Hospital").font(.system(size: 44)).foregroundColor(.primaryWhite)
                        Text("Kennedy").font(.system(size: 44)).foregroundColor(.primaryWhite)
                        Text("Desarrollado por Coure").font(.system(size: 12)).foregroundColor(.primaryWhite)
                    }
                    if deviceBounds.width < 700 { Spacer() }
                }
                .padding(.horizontal, 32)
                .padding(.top, 64)
                .padding(.bottom, 64)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: deviceBounds.height * 0.6)
        .offset(y: -self.keyboardHeight * 0.35)
        .animation(.customSpring)
    }
}



private struct LoginForm: View {
    @Binding var email: String
    @Binding var pass: String
    @Binding var paciente: Bool
    var body: some View {
        VStack {
            VStack {
                HStack (spacing: 20) {
                    if self.paciente == false {
                    Image(systemName: "envelope")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 26, height: 26)
                        .foregroundColor(Color.offWhite)}
                    else if self.paciente == true {
                        Image(systemName: "person")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 26, height: 26)
                        .foregroundColor(Color.offWhite)
                    }
                    ZStack(alignment: .leading) {
                        if self.email.isEmpty && self.paciente == false { Text("correo electrónico").foregroundColor(Color.primaryWhite.opacity(0.8)) }
                        else if self.email.isEmpty && self.paciente == true { Text("cédula de ciudadania").foregroundColor(Color.primaryWhite.opacity(0.8)) }
                        TextField("", text: self.$email)
                            .foregroundColor(Color.primaryWhite)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                    }
                }
                Divider().background(Color.primaryWhite)
            }
            .padding()
            VStack {
                HStack (spacing: 20) {
                    Image(systemName: "lock")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 26, height: 26)
                        .foregroundColor(Color.offWhite)
                    ZStack(alignment: .leading) {
                        if self.pass.isEmpty { Text("contraseña").foregroundColor(Color.primaryWhite.opacity(0.8)) }
                        SecureField("", text: self.$pass)
                            .foregroundColor(Color.primaryWhite)
                            .autocapitalization(.none)
                    }
                }
                Divider().background(Color.offWhite)
            }
            .padding()
        }
    .frame(width: deviceBounds.width < 700 ? deviceBounds.width * 0.88 :  deviceBounds.width * 0.6)
    }
}



private struct EnterButton: View {
    
    @EnvironmentObject var store: Store
    @Binding var email: String
    @Binding var pass: String
    @Binding var msg: String
    @Binding var shown: Bool
    @State private var alert: Bool = false
    @Binding var paciente: Bool
    @State var encontrado: Bool = false
    
    @State private var conexion : Bool = false
    
    var body: some View {
        VStack {
            HStack{
                
                Toggle(isOn: $paciente){Text("Ingrese como paciente").foregroundColor(.primaryWhite)}
            }.padding(.all, 5)
            Button(action: {
                hideKeyboard()
                if self.paciente == false {
                    Auth.auth().signIn(withEmail: self.email, password: self.pass){(res,err) in
                        if err != nil{
                            print((err!.localizedDescription))
                            self.msg = err!.localizedDescription
                            self.shown.toggle()
                            self.alert = true
                            //Alert(title: Text("Error al iniciar sesión"), message: Text(self.msg), dismissButton: .default(Text("Okay")))
                            return
                        }
                        self.msg = "Success"
                        self.shown.toggle()
                        self.store.isLogged = true
                        
                    }
                }
                else {

                    self.conectionTest()
                }

            }) {
                Text("Entrar").foregroundColor(.primaryWhite).bold()
            }
            .buttonStyle(DarkButtonStyle(paddingHorizontal: 80))
            .alert(isPresented: $alert){
                Alert(title: Text("Error al iniciar sesión"), message: Text(self.msg), dismissButton: .default(Text("Okay")))
            }
            
            Button(action: {
                let context = LAContext()
                var error: NSError?
                if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                    let reason = "Utiliza la huella para iniciar sesión en HK Coure"
                    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                        success, authenticationError in
                        if authenticationError != nil { return }
                        DispatchQueue.main.async {
                            self.store.isLogged = success
                        }
                    }
                } else{
                    // NO BIOMETRICS
                    print("*--> Device has no biometrics.")
                }
            }) {
                if self.paciente {

                    Text("Entrar con huella").foregroundColor(.offRed).bold()
                }
                else{

                    Text("Entrar con huella").foregroundColor(.offWhite).bold()
                }
            }
            .padding(.top, 32)
            .disabled(self.paciente)
            
        }
        .padding(.top, 24)
    }
    
    func searchPaciente() -> Bool{
        
        if self.encontrado {
            
        }
        else {
            print("usuario no encontrado")
        }
        return self.encontrado
    }
    
    func conectionTest()
    {
        let nwkMonitor = NWPathMonitor(requiredInterfaceType: .wifi)
        nwkMonitor.pathUpdateHandler = {
            path in
            if path.status == .satisfied{
                self.conexion = true
                var ref: DatabaseReference!
                          ref = Database.database().reference()
                              
                       ref.child("pacientes").child(self.email).observeSingleEvent(of: .value, with: {(snapshot) in
                                      self.encontrado = snapshot.exists()
                                      let value = snapshot.value as? NSDictionary
                                      print("Entra")
                                      let cedula = Int64(self.email)
                                      let nombre:String = value?["Nombre"] as? String ?? ""
                                      let otroNombre = nombre
                                      let fecha = value?["Fecha"] as? String ?? ""
                                      
                                      let formatter4 = DateFormatter()
                                      formatter4.dateFormat = "dd/MMM/yyyy"
                                      let fechNaci = formatter4.date(from: fecha) ?? Date()
                                      
                                      let lugar = value?["Lugar"] as? String ?? ""
                                      let estatura = Double(value?["Altura"] as? String ?? "")
                                      let tipoSangre = value?["Sangre"] as? String ?? ""
                                      let sexo = value?["Sexo"] as? String ?? ""
                                      let telefono = Int64(value?["Telefono"] as? String ?? "")
                                      let motivo = value?["Motivo"] as? String ?? ""
                                      let sintomas = value?["Sintomas"] as? String ?? ""
                                      let pulso = Int16(value?["Pulso"] as? String ?? "")
                                      let respiracion = Int16(value?["Respiracion"] as? String ?? "")
                                      let temperatura = Double (value?["Temperatura"] as? String ?? "")
                                      let tension = value?["Tension"] as? String ?? ""
                                      let area = value?["Area"] as? String ?? ""
                                      let alergias = value?["Alergias"] as? String ?? ""
                                      let triaje = Int16(value?["Triage"] as? String ?? "")
                                      let estado = value?["Estado"] as? String ?? "1"

                        let pacienteN = PacienteHK(cedula: cedula ?? 111, estatura: Double(estatura ?? 0), fechNaci: fechNaci, lugar: lugar, motivo: motivo, nombre: otroNombre, sexo: sexo, telefono: telefono ?? 0, tipoSangre: tipoSangre, alergias: alergias, pulso: pulso ?? 0, saturacion: respiracion ?? 0, sintomas: sintomas, temperatura: temperatura ?? 0, tension: tension, triaje: triaje ?? 0, area: area, visitas: 0, estado: estado)
                                      self.store.pacienteActual = pacienteN
                                      self.store.serachView = false
                                      self.encontrado = true
                                      if self.pass == "HK227"{
                                          self.store.isLogged = true
                                          self.store.isPacient = true
                                      }

                          }){(error) in
                              self.msg = error.localizedDescription
                                      self.shown.toggle()
                                      self.alert = true
                                      }

                
            }
            else
            {
                self.alert = true
                self.conexion = false
                self.msg = "En este momento no te encuentras conectado a internet, intentalo más tarde"

            }
        }
        let queue = DispatchQueue(label: "Monitor")
        nwkMonitor.start(queue: queue)
        nwkMonitor.cancel()
        if self.conexion == true{
            
        }
        else{

        }
    }
}


