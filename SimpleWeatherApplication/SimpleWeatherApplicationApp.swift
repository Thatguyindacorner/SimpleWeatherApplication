//
//  SimpleWeatherApplicationApp.swift
//  SimpleWeatherApplication
//
//  Created by Alex Olechnowicz on 2023-05-30.
//

import SwiftUI

@main
struct SimpleWeatherApplicationApp: App {
    
    var apiConnection = APIConnection()
    
    var body: some Scene {
        WindowGroup {
            ForecastView().environmentObject(apiConnection)
        }
    }
}
