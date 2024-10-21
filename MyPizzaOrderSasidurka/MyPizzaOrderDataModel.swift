//  View Model File
//  MyPizzaOrderDataModel.swift
//  MyPizzaOrderSasidurka
//
//  Created by Sasidurka on 2024-10-20.
//

import Foundation
import CoreData

class MyPizzaOrderDataModel: ObservableObject {
    @Published var orders: [OrderEntity] = []  // Fetched orders from CoreData
    
    let context = PersistenceController.shared.container.viewContext  // CoreData context
    
    // Fetch orders from CoreData
    func fetchOrders() {
        let request: NSFetchRequest<OrderEntity> = OrderEntity.fetchRequest() as! NSFetchRequest<OrderEntity>
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            orders = try context.fetch(request)
            
            // Set a default crust if it's nil for any order
            for order in orders {
                if order.crust == nil {
                    order.crust = "Regular"  // Set a default crust for old orders
                }
            }
            saveContext()  // Save any changes
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
        newOrder.crust = crust  // Make sure to set the crust here
        
        saveContext()
        fetchOrders()
    }

    
    // Update an existing order's quantity in CoreData
    func updateOrder(order: OrderEntity, newQuantity: Int16) {
        order.quantity = newQuantity  // Update the quantity
        saveContext()  // Save the changes to CoreData
        fetchOrders()  // Fetch the updated orders list
    }
    
    // Delete an order from CoreData
    func deleteOrder(order: OrderEntity) {
        context.delete(order)  // Remove the order from CoreData
        saveContext()  // Save the changes
        fetchOrders()  // Fetch the updated orders list
    }
    
    // Helper function to save changes to CoreData
    private func saveContext() {
        do {
            try context.save()  // Persist the changes in CoreData
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    struct PersistenceController {
        static let shared = PersistenceController()

        let container: NSPersistentContainer

        init() {
            container = NSPersistentContainer(name: "MyPizzaOrderDataModel")  
            container.loadPersistentStores { (description, error) in
                if let error = error {
                    fatalError("Error loading Core Data: \(error)")
                }
            }
        }
    }
}
