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
        //let dayOfWeek: String = date!.formatted(.dateTime.weekday())
        //let today: String = Date.now.formatted(.dateTime.weekday())
            
//        if today == dayOfWeek{
//            return "Today\n\(expectedOutputFormat)"
//        }
//        else{
//            return dayOfWeek
//        }
        
        return expectedOutputFormat
            
            
        
    }
}

struct WeatherCardView: View {
    
    var fiveDayForecast: WeatherObject
    var dayIndex: Int
    var darkestColor: Color

    
    var body: some View {
        
        let cardGradient: EllipticalGradient = EllipticalGradient(colors: [Color.white, Color.clear], startRadiusFraction: 0.01, endRadiusFraction: 0.7)
        
            VStack{
                ZStack{
                    
                    cardGradient.edgesIgnoringSafeArea(.vertical)
                    VStack{
                        Text(fiveDayForecast.datesOfWeatherForcast![dayIndex].convertToDayOfWeek()).font(.title2).bold()
                        Spacer()
                        HStack(alignment: .center, spacing: 45){
                            //Spacer()
                            
                            VStack(alignment: .leading){
                                
                                Label("\(fiveDayForecast.highTemperatures![dayIndex].asTemperature(unit: UnitTemperature.celsius))", systemImage: "thermometer.sun")
                                Label("\(fiveDayForecast.lowTemperatures![dayIndex].asTemperature(unit: UnitTemperature.celsius))", systemImage: "thermometer.snowflake")
                                
                            }
                            //Spacer()
                            
                            VStack(alignment: .trailing){
                                Label("\(fiveDayForecast.probabilitiesOfPercipitation![dayIndex].asPercent())", systemImage: "cloud.rain")
                            }
                            
                            //Spacer()
                        }
                    }.padding(.vertical, 25)
                    
                }.onAppear{
//                cardGradient = EllipticalGradient(colors: [darkestColor, Color.clear], startRadiusFraction: 0.04, endRadiusFraction: 0.55)
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.9, height: 115).cornerRadius(75)//.border(.black)
        
        
        
    }
}

