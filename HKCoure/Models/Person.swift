//
//  Person.swift
//  HKCoure
//
//  Created by Sebastian on 2/28/20.
//  Copyright © 2020 Sebastian. All rights reserved.
//

import SwiftUI

struct Person {
    var uid: String
    var email: String?
    
    init(uid: String, email: String?) {
        self.uid = uid
        self.email = email
    }
    
}

struct PacienteHK {
    
    var cedula: Int64
    var estatura: Double
    var fechNaci: Date?
    var lugar: String?
    var motivo: String?
    var nombre: String?
    var sexo: String?
    var telefono: Int64
    var tipoSangre: String?
    var alergias: String?
    var pulso: Int16
    var saturacion: Int16
    var sintomas: String?
    var temperatura: Double
    var tension: String?
    var triage: Int16
    var area: String
    var visitas: Int16
    var estado: String

    init(cedula:Int64, estatura: Double, fechNaci: Date?, lugar:String?, motivo: String?, nombre: String?, sexo: String?, telefono: Int64, tipoSangre: String?, alergias: String?, pulso:Int16, saturacion: Int16, sintomas:String?, temperatura:Double, tension: String?, triaje: Int16, area: String, visitas: Int16, estado: String){
        self.cedula=cedula
        self.estatura = estatura
        self.fechNaci = fechNaci
        self.lugar = lugar
        self.motivo = motivo
        self.nombre = nombre
        self.sexo = sexo
        self.telefono = telefono
        self.tipoSangre = tipoSangre
        self.alergias = alergias
        self.pulso = pulso
        self.saturacion = saturacion
        self.sintomas = sintomas
        self.temperatura = temperatura
        self.tension = tension
        self.triage = triaje
        self.area = area
        self.visitas = visitas
        self.estado = estado
    }
    
}

