import SwiftUI

struct IngredientPopupView: View {
    @Binding var showPopup: Bool // Controls popup visibility
    @Binding var ingredientName: String // Ingredient name input
    @Binding var quantity: Int // Quantity input
    var addIngredientAction: () -> Void // Action for "Add" button
    
    @ObservedObject var viewModel: RecipeIngredientViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            /// Ingredient Name Section
            Text("Ingredient Name")
                .font(.system(size: 18))
                .fontWeight(.bold)
            
            TextField("Ingredient Name", text: $ingredientName)
                .frame(width:270,height:10)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            
            
            /// Measurement Section
            Text("Measurement")
                .font(.system(size: 18))
                .fontWeight(.bold)

            /// Measurement Buttons
            HStack(spacing: 20) {
                Button(action: {
                    viewModel.updateMeasurement(to: .spoon)
                }) {
                    Text("🥄 Spoon")
                        .padding()
                        .frame(width: 120, height: 30)
                        .background(viewModel.measurement == .spoon ? Color.gray.opacity(0.2) : Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
             
               
                Button(action: {
                    viewModel.updateMeasurement(to: .cup)
                }) {
                    Text("🥛 Cup")
                        .padding()
                        .frame(width: 120, height: 30)
                        .background(viewModel.measurement == .cup ? Color.gray.opacity(0.2) : Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
                .contentShape(Rectangle())
            }
            
            

            /// Serving and Measurement Section combined
            VStack {
                Text("Serving")
                    .font(.system(size: 18))
                    .fontWeight(.bold)
            }
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 250, height: 30)
                    .cornerRadius(5)
                
                HStack {
                    Button(action: {
                        viewModel.decrementServing()
                    }) {
                        Image(systemName: "minus.square")
                            .font(.system(size: 20))
                            .foregroundColor(.accentColor)
                    }
                    Text("\(quantity)")
                        .frame(width: 40)
                        .font(.system(size: 18))
                        .multilineTextAlignment(.center)

                    Button(action: {
                        viewModel.incrementServing()
                        
                    }) {
                        Image(systemName: "plus.square")
                            .font(.system(size: 20))
                            .foregroundColor(.accentColor)
                    }
                    .padding(.horizontal, 10)
                    
                    Text(viewModel.measurement.rawValue)
                        .frame(width: 100, height: 10)
                        .padding(10)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
            }
            .padding(.bottom, 10)
            

            /// Action Buttons
            HStack(spacing: 20) {
                Button(action: {
                    showPopup = false
                }) {
                    Text("Cancel")
                        .foregroundColor(.accentColor)
                        .frame(width: 120, height: 30)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(5)
                }
                Button(action: {
                    addIngredientAction()
                    showPopup = false
                }) {
                    Text("Add")
                        .foregroundColor(.white)
                        .frame(width: 120, height: 30)
                        .background(Color.accentColor)
                        .cornerRadius(5)
                }
            }
        }
        
        ///POP-UP FRAME 
        .padding()
        .frame(width: 320, height: 400)
        .background(Color("popup_back"))
        .cornerRadius(12)
        .shadow(radius: 10)
    }
}

