//
//  AnalyticsController.swift
//  HKCoure
//
//  Created by Pipe on 23/04/20.
//  Copyright © 2020 Sebastian. All rights reserved.
//

import Foundation
import FirebaseDatabase

public class AnalyticsController: ObservableObject{
    
    private var paciList: [Paci] = []
    private var snapData: [DataSnapshot] = []
    private var numPas: String = "..."
    
    init(){
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
    
    func getPacientesList() -> [Paci]{
        return self.paciList
    }
    
    func getNumPacientes() -> String {
        
        return self.numPas
    }
    
    //if let snpashots = snapshot.children.allObjects as? [DataSanpshot]...
}
