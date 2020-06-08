//
//  SearchView.swift
//  HKCoure
//
//  Created by Andres Rodriguez on 4/04/20.
//  Copyright © 2020 Sebastian. All rights reserved.
//
import SwiftUI
import UIKit
import FirebaseDatabase
import Foundation
import CoreData
import Network


struct SearchView: View {
    
    
    @State private var didFinishCamera: Bool = false
    @State private var showSheet: Bool = false
    @EnvironmentObject var store: Store
    @State private var cedula = ""
    
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @State private var conexion: Bool = false
    @State private var alertConection: Bool = false
    @State private var alertFind: Bool = false
    @State private var alertCedula: Bool = false
    
    @State var dispatch = DispatchGroup()
    @State var find : Bool = false
    
    
    @State private var msg: String = "Lo sentimos pero no en este momento no tiene acceso a internet, las búsquedas se harán sobre los expedientes guardados localmente en la aplicación"
    
    var body: some View{
        ZStack{
            Color.offWhite
            NavigationView{
                Form{
                    TextField("Cédula" , text:$cedula).keyboardType(.numberPad)
                    
                    Button( action: {
                        
                        self.showSheet = true
                        print(self.store.$textRecognitionResults)
                        
                    }){
                        Text("Escanear")
                    }
                   
                }.navigationBarTitle( Text("Buscar paciente"))
                .navigationBarItems(leading:
                    Button(action: {
                        self.store.serachView = false

                    }) {
                        Text("Atras").foregroundColor( Color.red)
                    },
                    trailing:
                    Button(action: {
                        if self.cedula ==  "" || self.cedula == " "{
                            self.msg = "Ingrese un número de identificación válido"
                            self.alertCedula = true
                            
                        }else{
                            
                             self.buscar()
                        }
                        
                    }) {
                        Text("Buscar")
                    }
                    .disabled(self.cedula.isEmpty)
                    .alert(isPresented: $alertFind){
                    Alert(title: Text("Paciente no encontrado"), message: Text(self.msg), dismissButton: .default(Text("Okay")))}
                )
            }
        }.onAppear(perform: self.conectionTest)
            .alert(isPresented: $alertCedula){
            Alert(title: Text("Identificación invalida"), message: Text(self.msg), dismissButton: .default(Text("Okay")))}
        .alert(isPresented: $alertConection){
        Alert(title: Text("Conexión a internet"), message: Text(self.msg), dismissButton: .default(Text("Okay")))}
        
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
                    }
                }
            }
        }
    }
    
    func run(after seconds: Int, completion: @escaping () -> Void){
           let deadline = DispatchTime.now() + .seconds(seconds)
           DispatchQueue.main.asyncAfter(deadline: deadline) {
               completion()
           }
       }
    
    //Busca en firebase al paciente
    func searchPaciente(){
        
        self.dispatch.enter()
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
    
        ref.child("pacientes").child(self.cedula).observeSingleEvent(of: .value, with: {(snapshot) in

            let value = snapshot.value as? NSDictionary
            print("Entra")
            let cedula = Int64(self.cedula)
            let nombre:String = value?["Nombre"] as? String ?? ""
            let otroNombre = nombre
            let fecha = value?["Fecha"] as? String ?? ""
            
            let formatter4 = DateFormatter()
            formatter4.dateFormat = "dd/MM/yyyy"
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
            let visitas = Int16(value?["Visitas"] as? Int ?? 0)
            let estado = value?["Estado"] as? String ?? "0"
            print(visitas)

            let pacienteN = PacienteHK(cedula: cedula ?? 111, estatura: Double(estatura ?? 0), fechNaci: fechNaci, lugar: lugar, motivo: motivo, nombre: otroNombre, sexo: sexo, telefono: telefono ?? 0, tipoSangre: tipoSangre, alergias: alergias, pulso: pulso ?? 0, saturacion: respiracion ?? 0, sintomas: sintomas, temperatura: temperatura ?? 0, tension: tension, triaje: triaje ?? 0, area: area, visitas: visitas ?? 0, estado : estado)
            self.store.pacienteActual = pacienteN
            let defaults = UserDefaults.standard
            var crearTime = defaults.object(forKey:"ConexionTime") as? [Double] ?? [0,0]
            crearTime[0] = crearTime[0] 
            crearTime[1] = crearTime[1] + 1
            defaults.set(crearTime, forKey:"ConexionTime")
            self.store.searchPacientDetail = true
            self.store.serachView = false
            self.find = true
            print("A")

        }){(error) in
            print("----------------------Falla")
            print(error.localizedDescription)
            }
        self.run(after: 2) {
            print("B")
        print(self.find)
            self.dispatch.leave()}

    }
    
    //Se encarga leer la información guardada localmente en CoreData
    func getData(){
        self.dispatch.enter()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Paciente")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]
            {
                print(String(data.value(forKey: "cedula") as! Int64))
                if (String(data.value(forKey: "cedula") as! Int64)) == self.cedula{
                    let cedula = data.value(forKey: "cedula") as! Int64
                    let nombres = data.value(forKey: "nombre") as! String
                    let fechNaci = data.value(forKey: "fechNaci") as! Date
                    let lugar = data.value(forKey: "lugar") as! String
                    let estatura = data.value(forKey: "estatura")  as! Double
                    let tipoSangre = data.value(forKey: "tipoSangre") as! String
                    let sexo = data.value(forKey: "sexo") as! String
                    let telefono = data.value(forKey: "telefono") as! Int64
                    let motivo = data.value(forKey: "motivo") as! String
                    let pacienteNuevo = PacienteHK(cedula: cedula, estatura: estatura, fechNaci: fechNaci, lugar: lugar, motivo: motivo, nombre: nombres, sexo: sexo, telefono: telefono, tipoSangre: tipoSangre, alergias: "alergias", pulso: 0, saturacion: 0, sintomas: "", temperatura: 0, tension: "", triaje: 0, area: "", visitas: 1, estado: "1")
                    self.store.pacienteActual = pacienteNuevo
                    self.find = true
                    break
                }
                
            }
            self.run(after: 1) {
                self.dispatch.leave()
            }
            

        }
        catch {
            self.dispatch.leave()
        }
    }
    
    // Se encarga de verificar la conexión a red wifi
    func buscar(){
        self.conectionTest2()
        self.dispatch.notify(queue: .main){
            if self.conexion == true{
                self.searchPaciente()
                self.dispatch.notify(queue: .main){
                    if self.find == true{
                        self.store.searchPacientDetail = true
                        self.store.serachView = false
                    }
                    else{
                        self.alertFind = true
                        self.msg = "El paciente con la cedula \(self.cedula) no se encuentra registrado en la base de datos"
                    }
                }
            }
            else{
                self.getData()
                self.dispatch.notify(queue: .main){
                    if self.find == true{
                        self.store.searchPacientDetail = true
                        self.store.serachView = false
                    }
                    else{
                        self.alertFind = true
                        self.msg = "El paciente con la cedula \(self.cedula) no se encuentra guardado localmente"
                    }
                }
            }
        }
    }
    
    // Se encarga de verificar la conexión a la red wifi
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
                self.alertConection = true
                self.conexion = false
                self.msg = "Lo sentimos pero en este momento no tiene acceso a internet, las búsquedas se harán sobre los expedientes guardados localmente en la aplicación y pueden no estar actualizados"

            }
        }
        let queue = DispatchQueue(label: "Monitor")
        nwkMonitor.start(queue: queue)
        nwkMonitor.cancel()
    }
    
    
    func conectionTest2()
    {
        self.dispatch.enter()
        let nwkMonitor = NWPathMonitor(requiredInterfaceType: .wifi)
        nwkMonitor.pathUpdateHandler = {
            path in
            if path.status == .satisfied{
                self.conexion = true
            }
            else
            {
                self.conexion = false
            }
        }
        let queue = DispatchQueue(label: "Monitor")
        nwkMonitor.start(queue: queue)
        nwkMonitor.cancel()
        self.dispatch.leave()
    }
}
