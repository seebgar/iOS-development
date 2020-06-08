//
//  Paciente+CoreDataProperties.swift
//  HKCoure
//
//  Created by Andres Rodriguez on 17/04/20.
//  Copyright © 2020 Sebastian. All rights reserved.
//
//

import Foundation
import CoreData


extension Paciente {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Paciente> {
        return NSFetchRequest<Paciente>(entityName: "Paciente")
    }

    @NSManaged public var alergias: String?
    @NSManaged public var area: String?
    @NSManaged public var cedula: Int64
    @NSManaged public var estatura: Double
    @NSManaged public var fechNaci: Date?
    @NSManaged public var lugar: String?
    @NSManaged public var motivo: String?
    @NSManaged public var nombre: String?
    @NSManaged public var pulso: Int16
    @NSManaged public var saturacion: Int16
    @NSManaged public var sexo: String?
    @NSManaged public var sintomas: String?
    @NSManaged public var telefono: Int64
    @NSManaged public var temperatura: Double
    @NSManaged public var tension: String?
    @NSManaged public var tipoSangre: String?
    @NSManaged public var triage: Int16

}
