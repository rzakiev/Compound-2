//
//  ContentView.swift
//  Compound 2
//
//  Created by Robert Zakiev on 20/07/2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    struct Restaurant: Identifiable {
        var id = UUID()
        var name: String
    }
    
    struct RestaurantRow: View, Identifiable {
        var id = UUID()
        var restaurant: Restaurant
        var body: some View {
            Text(restaurant.name)
        }
    }
    
    struct RestaurantView: View {
        let restaurant: Restaurant
        var body: some View {
            Text("Come and eat at \(restaurant.name)")
                .font(.largeTitle)
        }
    }
    
    var body: some View {
        //let effect = UIBlurEffect(style: .prominent)
        let firstRestaurant = Restaurant(name: "Pitcher")
        let secondRestaurant = Restaurant(name: "Teremok")
        let thirdRestaurant = Restaurant(name: "KFC")
        let restaurants = [firstRestaurant, secondRestaurant, thirdRestaurant]
        
        return NavigationView {
            List(restaurants) { restaurant in
                NavigationLink(restaurant.name, destination: RestaurantView(restaurant: restaurant))
            }.navigationBarTitle("Select a Restaurant")
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
