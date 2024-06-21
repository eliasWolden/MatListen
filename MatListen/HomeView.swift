import SwiftUI

struct HouseholdView: View {
    @Binding var shoppingList: [Item]
    @Binding var user: User
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    VStack {
                        Text("Household")
                            .customFont(size: 30, weight: .thin)
                            .padding()
                        HStack  {
                            Spacer(minLength: 320)
                            NavigationLink(destination: HouseHoldCrudView(user: $user)) {
                                Image("white-gear-icon")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .padding()
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .none)
                        .backgroundColor(Color.white)                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .none)
                .backgroundColor(Color.white)

                Spacer()

                HouseholdList(user: $user)
                
                Spacer()

                ShoppingListView(shoppingList: $shoppingList)
                
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(Color(.systemGray6))
        }
    }
}
