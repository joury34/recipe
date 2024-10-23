//
//  IngredientPopupView.swift
//  recipe
//
//  Created by Joury on 19/04/1446 AH.
//
import SwiftUI

struct IngredientPopupView: View {
    @Binding var showPopup: Bool // Binding to control the visibility of the popup
    @Binding var ingredientName: String // Ingredient name input
    @Binding var measurement: String // Selected measurement (Spoon or Cup)
    @Binding var quantity: Int // Quantity input
    
    var addIngredientAction: () -> Void // Closure to handle the "Add" action

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Ingredient Name Section
            Text("Ingredient Name")
                .font(.system(size: 18))
                .fontWeight(.bold)
            
            TextField("Ingredient Name", text: $ingredientName)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            
            // Measurement Section
            Text("Measurement")
                .font(.system(size: 18))
                .fontWeight(.bold)

            // Measurement Buttons
            HStack(spacing: 20) {
                // Spoon Button
                Button(action: {
                    measurement = "Spoon"
                }) {
                    Text("🥄 Spoon")
                        .padding()
                        .frame(width: 120, height: 30)
                        .background(measurement == "Spoon" ? Color.gray.opacity(0.2) : Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                // Cup Button
                Button(action: {
                    measurement = "Cup"
                }) {
                    Text("🥛 Cup")
                        .padding()
                        .frame(width: 120, height: 30)
                        .background(measurement == "Cup" ? Color.gray.opacity(0.2) : Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
          
            // Serving and Measurement Section combined
            VStack{
                Text("Serving")
                    .font(.system(size: 18))
                    .fontWeight(.bold)
            }
            ZStack{
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 300, height: 30)
                    .cornerRadius(10)
                
                HStack {
                    // Minus button
                    Button(action: {
                        if quantity > 1 {
                            quantity -= 1
                        }
                    }) {
                        Image(systemName: "minus.square")
                            .font(.system(size: 20))
                            .foregroundColor(.accentColor)
                    }
                    
                    // Display the quantity in the center
                    Text("\(quantity)")
                        .frame(width: 40) // Adjust the width as needed to center properly
                        .font(.system(size: 18))
                        .multilineTextAlignment(.center)
                    
                    // Plus button
                    Button(action: {
                        if quantity < 10 {
                            quantity += 1
                        }
                    }) {
                        Image(systemName: "plus.square")
                            .font(.system(size: 20))
                            .foregroundColor(.accentColor)
                    }
                    
                    .padding(.horizontal, 10)
                    
                    // Selected Measurement Display
                    Text(measurement == "Spoon" ? "🥄 Spoon" : "🥛 Cup")
                        .frame(width:80, height: 20)
                        .padding(10)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    
                }
            }
            
            .padding(.bottom, 10)

            // Action Buttons (Cancel and Add)
            HStack {
                Button(action: {
                    showPopup = false // Dismiss the popup
                }) {
                    Text("Cancel")
                        .foregroundColor(.red)
                        .padding()
                }
                Spacer()
                Button(action: {
                    addIngredientAction() // Add the ingredient and dismiss the popup
                    showPopup = false
                }) {
                    Text("Add")
                        .foregroundColor(.blue)
                        .padding()
                }
            }
            .padding(.top, 10)
        }
        .padding()
        .frame(width: 400, height: 500)// Adjust these values as needed
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 10)
    }
}

