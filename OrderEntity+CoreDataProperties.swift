//
//  OrderEntity+CoreDataProperties.swift
//  MyPizzaOrderSasidurka
//
//  Created by Sasidurka on 2024-10-21.
//
//

import Foundation
import CoreData

extension OrderEntity {
    @NSManaged public var id: UUID?
    @NSManaged public var pizza_type: String?
    @NSManaged public var size: String?
    @NSManaged public var quantity: Int16
    @NSManaged public var date: Date?
    @NSManaged public var crust: String?
}

