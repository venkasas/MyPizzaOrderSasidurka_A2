//  Sasidurka Venkatesan 991542294
//  OrderListView.swift
//  MyPizzaOrderSasidurka
//
//  Created by Sasidurka on 2024-09-29.
//

import SwiftUI

struct OrderListView: View {
    @ObservedObject var viewModel: MyPizzaOrderDataModel  // ViewModel to fetch and manage the orders

    // DateFormatter to format the date
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium  // You can use .short, .long, or .full depending on your preference
        formatter.timeStyle = .none  // If you want to omit the time
        return formatter
    }
    
    var body: some View {
        List {
            ForEach(viewModel.orders, id: \.self) { order in
                HStack {
                    VStack(alignment: .leading) {
                        Text("Pizza Type: \(order.pizza_type ?? "Unknown")")
                        Text("Size: \(order.size ?? "Unknown")")
                        Text("Crust: \(order.crust ?? "Unknown")")  // Display the crust type
                        Text("Quantity: \(order.quantity)")
                        
                        // Check if the order date exists, format it if it does, otherwise show "Unknown"
                        if let orderDate = order.date {
                            Text("Date: \(orderDate, formatter: dateFormatter)")
                        } else {
                            Text("Date: Unknown")
                        }
                    }
                    Spacer()
                    Stepper(value: Binding(
                        get: { Int(order.quantity) },  // Convert Int16 to Int for Stepper
                        set: { newValue in
                            viewModel.updateOrder(order: order, newQuantity: Int16(newValue))  // Convert Int back to Int16
                        }
                    ), in: 1...10) {
                        Text("\(order.quantity)")
                    }
                }
            }
            .onDelete(perform: deleteOrder)
        }
        .onAppear {
            viewModel.fetchOrders()  // Fetch orders when the view appears
        }
        .navigationTitle("My Orders")
    }

    // Function to delete an order
    private func deleteOrder(at offsets: IndexSet) {
        offsets.forEach { index in
            let order = viewModel.orders[index]
            viewModel.deleteOrder(order: order)  // Call ViewModel to delete the order
        }
    }
}
