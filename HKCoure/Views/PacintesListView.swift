//
//  PacintesListView.swift
//  HKCoure
//
//  Created by Pipe on 22/04/20.
//  Copyright © 2020 Sebastian. All rights reserved.
//

import SwiftUI
import CoreData
import FirebaseDatabase
import Network

struct PacientesListView: View{
    
    
    @State private var msg: String = ""
    @State private var conexion: Bool = false
    @State private var alert: Bool = false
    
    @State var paciList: [Paci] = []
    @State var prueba: [Any] = []
    @EnvironmentObject var store: Store
    
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var body: some View{
        NavigationView(){
            List(paciList){ p in
                VStack{
                    HStack{
                        Text("Cédula").font(.system(size: 18, weight: .bold))
                        Text(p.ced)
                        Text("Triaje").font(.system(size: 18, weight: .bold))
                        Text(p.tri)
                    }
                    HStack{
                        Text("Nombre").font(.system(size: 18, weight: .bold))
                        Text(p.nom)
                    }
                }
                }
            .navigationBarTitle(Text("Pacientes"))
        .navigationBarItems(leading:
                Button(action: {
                    self.store.listView = false
                }) {
                    Text("Atras").foregroundColor( Color.red)
                }
            )
        }.onAppear{
            self.conectionTest()
            
        }
        .alert(isPresented: $alert){
        Alert(title: Text("Sin conexión a internet"), message: Text(self.msg), dismissButton: .default(Text("Okay")))}
    }
    
    // Listado de pacientes en la base de datos
    func leerDatos(){
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
        
        }){(error) in
            print("----------------------Falla")
            print(error.localizedDescription)
            }
    }
    
    // Verifica la conexión con wifi
    func conectionTest()
    {
        let nwkMonitor = NWPathMonitor(requiredInterfaceType: .wifi)
        nwkMonitor.pathUpdateHandler = {
            path in
            if path.status == .satisfied{
                self.conexion = true
                self.leerDatos()
            }
            else
            {
                self.alert = true
                self.conexion = false
                self.msg = "En este momento no te encuentras conectado a internet, solo podrás listar los pacientes guardados localmente"
                self.getData()

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
    
    // Lista los pacientes que están localmente guardados
    func getData() -> Bool{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Paciente")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]
            {
                let actual = Paci(ced: String(data.value(forKey: "cedula") as! Int64), nom: data.value(forKey: "nombre") as! String, tri: String(data.value(forKey: "triage") as! Int16 ?? 0), sex: data.value(forKey: "sexo") as! String, ciu: data.value(forKey: "lugar") as! String)
                self.paciList.append(actual)
                
            }
            return false
        }
        catch {
            return false
        }
    }
    
}

// Estructura para listas y analytics
struct Paci: Identifiable{
    var id = UUID()
    
    
    var ced: String
    var nom: String
    var tri: String
    var sex: String
    var ciu: String
}
