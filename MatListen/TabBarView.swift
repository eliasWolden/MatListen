//
//  TabBarView.swift
//  MatListen
//
//  Created by Elias Wolden on 19/06/2024.
//

import Foundation
import SwiftUI

struct TabBarView: View {
    @State private var selectedTab = 0
    @State private var shoppingList: [Item] = []
    @Binding var user: User

    var body: some View {
        GeometryReader { geometry in
            VStack {
                TabView(selection: $selectedTab) {
                    HouseholdView(shoppingList: $shoppingList, user: $user)
                        .tabItem {
                            iconView(name: "home-icon", isSelected: selectedTab == 0)
                        }
                        .tag(0)
                        .frame(width: geometry.size.width, height: geometry.size.height - 50)
                    
                    ProductView(shoppingList: $shoppingList)
                        .tabItem {
                            iconView(name: "search-icon", isSelected: selectedTab == 1)
                        }
                        .tag(1)
                        .frame(width: geometry.size.width, height: geometry.size.height - 50)

                    NutritionView()
                        .tabItem {
                            iconView(name: "eat-icon", isSelected: selectedTab == 2)
                        }
                        .tag(2)
                        .frame(width: geometry.size.width, height: geometry.size.height - 50)

                    NotificationsView()
                        .tabItem {
                            iconView(name: "notifcation-icon", isSelected: selectedTab == 3)
                        }
                        .tag(3)
                        .frame(width: geometry.size.width, height: geometry.size.height - 50)
                }
                .accentColor(.navBarIconColor)
                .onAppear {
                    let tabBarAppearance = UITabBarAppearance()
                    tabBarAppearance.configureWithOpaqueBackground()
                    tabBarAppearance.backgroundColor = UIColor.navBarBackground
                    UITabBar.appearance().standardAppearance = tabBarAppearance
                    UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
                }
                Spacer()
                    .frame(height: 20)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
    
    private func iconView(name: String, isSelected: Bool) -> some View {
        ZStack {
            if isSelected {
                Circle()
                    .strokeBorder(Color.navBarIconColor, lineWidth: 3)
                    .frame(width: 50, height: 50)
            }
            Image(name)
                .renderingMode(.template)
                .foregroundColor(isSelected ? .navBarIconColor : .white)
        }
    }
}
