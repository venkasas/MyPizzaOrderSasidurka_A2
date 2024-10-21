//  Sasidurka Venkatesan 991542294
//  ContentView.swift
//  MyPizzaOrderSasidurka
//
//  Created by Sasidurka on 2024-09-29.
//


import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = MyPizzaOrderDataModel()  // ViewModel to manage orders
    @State private var selectedSize = "Small"
    @State private var selectedTopping = "Cheese"
    @State private var selectedCrust = 0  // This is the index of the selected crust
    @State private var quantity = 1
    
    let crustOptions = ["Thin", "Regular", "Thick"]  // Available crust options
    let pizzaSizes = ["Small", "Medium", "Large"]
    let pizzaToppings = ["Cheese", "Pepperoni", "Veggie", "Meat Lovers"]
    
    var body: some View {
        NavigationView {
            VStack {
                // Pizza Size Picker
                Picker("Pizza Size", selection: $selectedSize) {
                    ForEach(pizzaSizes, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Pizza Toppings Picker
                Picker("Toppings", selection: $selectedTopping) {
                    ForEach(pizzaToppings, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .padding()
                
                // Crust Type Picker
                Picker("Crust", selection: $selectedCrust) {
                    ForEach(0..<crustOptions.count) {
                        Text(self.crustOptions[$0])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Quantity Stepper
                Stepper(value: $quantity, in: 1...10) {
                    Text("Quantity: \(quantity)")
                }
                .padding()
                
                // Add Order Button
                Button("Add Order") {
                    let crust = crustOptions[selectedCrust]  // Get the selected crust
                    viewModel.addOrder(size: selectedSize, topping: selectedTopping, crust: crust, quantity: quantity)
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                // Navigation Button to go to the next screen
                NavigationLink(destination: OrderListView(viewModel: viewModel)) {
                    Text("Show My Orders")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .navigationTitle("Pizza Order")
            .padding()
        }
    }
}
