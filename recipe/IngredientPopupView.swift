//
//  IngredientPopupView.swift
//  recipe
//
//  Created by Joury on 19/04/1446 AH.
//
import SwiftUI

struct IngredientPopupView: View {
    @State private var ingredientName = ""
    @State private var ingredientMearurement = "Spoon"
    let measurementOptions = ["Spoon", "Cup"]
    @State private var ServingtQuantity = "1"
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Ingredient Name")
                .font(.system(size: 24))
                .fontWeight(.bold)
            
            TextField("Ingredient Name", text: $ingredientName)
                .padding()
                .background(Color.gray.opacity(0.2))
                .frame(width: 380, height: 44)
                .cornerRadius(8)
            Text("Measurment")
                .font(.system(size: 24))
                .fontWeight(.bold)
            HStack{
                Button("🥄 Spoon") {
                    /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.gray.opacity(0.2))
                
                Spacer()
            }
        }
    }
}


