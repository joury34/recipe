//
//  ContentView.swift
//  recipe
//
//  Created by Joury on 17/04/1446 AH.
//

import SwiftUI

struct FoodRecipes: View {
    var body: some View {
       
        NavigationView{
            ScrollView {
                VStack {
                    Image("recipe")
                        .resizable()
                        .padding()
                        .frame(width:325,height: 327)
                        .padding(.top,70)
                    Text("There's no recipe yet")
                        .padding()
                        .font(.system(size: 36))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    
                    Text("Please add your recipes")
                        .font(.system(size: 22))
                        .foregroundColor(.color3)
                    
                }
                
                .navigationTitle("Food Recipes")
                .toolbarBackground(Color.gray1, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                
                
                .navigationBarItems(trailing:
                                        NavigationLink(destination:AddRecipe()){
                    Image(systemName: "plus")
                    
                } )
                
                
                
                
            }//end of navigation view
        }
        
            
            
            
            
            
        }
        
    }
    

              

        
       
    

   
#Preview {
    FoodRecipes()
}
