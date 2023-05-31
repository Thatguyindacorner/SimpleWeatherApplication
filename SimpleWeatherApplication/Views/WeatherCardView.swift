//
//  WeatherCardView.swift
//  SimpleWeatherApplication
//
//  Created by Alex Olechnowicz on 2023-05-30.
//

import SwiftUI

extension String{
    func convertToDayOfWeek() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
            let date = dateFormatter.date(from: self)
            guard date != nil
            else{
                print(#function, "Formatting failed")
                return self
            }
        
        let expectedOutputFormat = date!.formatted(.dateTime.weekday(.wide).month().day(.defaultDigits))
        
        return expectedOutputFormat
            
            
        
    }
}

struct WeatherCardView: View {
    
    var fiveDayForecast: WeatherObject
    var dayIndex: Int
    var darkestColor: Color
    var unit: TemperatureUnit

    
    var body: some View {
        
        let cardGradient: EllipticalGradient = EllipticalGradient(colors: [Color.white, Color.clear], startRadiusFraction: 0.01, endRadiusFraction: 0.7)
        
        VStack{
            ZStack{
                
                cardGradient.edgesIgnoringSafeArea(.vertical)
                VStack{
                    Text(fiveDayForecast.datesOfWeatherForcast![dayIndex].convertToDayOfWeek())
                        .font(.title2)
                        .bold()
                        .foregroundColor(.black)

                    Spacer()
                    
                    HStack(alignment: .center, spacing: 25){
                        VStack(alignment: .leading){
                            
                            Label("\(fiveDayForecast.highTemperatures![dayIndex].asTemperature(unit: unit))", systemImage: "thermometer.sun")
                                .foregroundColor(.black)
                            Label("\(fiveDayForecast.lowTemperatures![dayIndex].asTemperature(unit: unit))", systemImage: "thermometer.snowflake")
                                .foregroundColor(.black)
                        }
                        
                        VStack(alignment: .trailing){
                            Label("\(fiveDayForecast.probabilitiesOfPercipitation![dayIndex].asPercent())", systemImage: "cloud.rain")
                                .foregroundColor(.black)
                        }
                        
                    }
                }.padding(.vertical, 25)
                
            }
        }.frame(width: UIScreen.main.bounds.width * 0.9, height: 115).cornerRadius(75)
    }
}

