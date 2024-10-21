//
//  OrderViewModel.swift
//  MyPizzaOrderSasidurka
//
//  Created by Sasidurka on 2024-10-20.
//

import Foundation
import CoreData
import SwiftUI

class MyPizzaOrderDataModel: ObservableObject {
    @Published var orders: [OrderEntity] = []
    let context: NSManagedObjectContext  // CoreData context
    
    // Initialize the ViewModel with the CoreData context
    init() {
        self.context = PersistenceController.shared.container.viewContext
    }
    
    // Fetch Orders from CoreData
    func fetchOrders() {
        let request: NSFetchRequest<OrderEntity> = OrderEntity.fetchRequest() 
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            orders = try context.fetch(request)  // Fetch the orders and update the orders array
        } catch {
            print("Error fetching orders: \(error)")
        }
    }
    
    // Add a new order to CoreData
    func addOrder(size: String, topping: String, crust: String, quantity: Int) {
        let newOrder = OrderEntity(context: context)
        newOrder.id = UUID()
        newOrder.pizza_type = topping
        newOrder.size = size
        newOrder.quantity = Int16(quantity)
        newOrder.date = Date()
        
        saveContext()  // Save the new order
        fetchOrders()  // Refresh the list after adding
    }
    
    // Update the quantity of an existing order
    func updateOrder(order: OrderEntity, newQuantity: Int) {
        order.quantity = Int16(newQuantity)  // Update quantity
        saveContext()  // Save the changes
        fetchOrders()  // Refresh the list after updating
    }
    
    // Delete an order from CoreData
    func deleteOrder(order: OrderEntity) {
        context.delete(order)  // Delete the order
        saveContext()  // Save the context after deletion
        fetchOrders()  // Refresh the list after deletion
    }
    
    // Save changes to CoreData
    private func saveContext() {
        do {
            try context.save()  // Persist changes
        } catch {
            print("Error saving context: \(error)")
        }
    }
}

// CoreData Persistence Controller
struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "MyOrderDataModel")  // Make sure the name matches the .xcdatamodeld filename
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Error loading Core Data: \(error)")
            }
        }
    }
}


