//
//  ForecastView.swift
//  SimpleWeatherApplication
//
//  Created by Alex Olechnowicz on 2023-05-30.
//

import SwiftUI

extension Double{
    func asTemperature(unit: TemperatureUnit) -> String{
        return String(format: "%.1f", self) + unit.symbol()
    }
    func asPercent() -> String{
        return String(format: "%.0f", self) + "%"
    }
}

enum TimesOfDay: String{
    
    static var all: [TimesOfDay] = [.sunrise, .morining, .afternoon, .evening, .sunset, .night]
    
    case sunrise = "5 AM,6 AM"
    case morining = "7 AM,8 AM,9 AM,10 AM"
    case afternoon = "11 AM,12 PM,1 PM,2 PM,3 PM"
    case evening = "4 PM,5 PM,6 PM,7 PM"
    case sunset = "8 PM,9 PM"
    case night = "10 PM,11 PM,12 AM,1 AM,2 AM,3 AM,4 AM"
    
    func formattedHours() -> [String]{
        let substringHours: [Substring] = self.rawValue.split(separator: ",")
        var stringHours: [String] = []
        for hour in substringHours{
            stringHours.append(String(hour))
        }
        return stringHours
    }
}

enum TemperatureUnit: String{
    case C = "celsius"
    case K = "fahrenheit"
    
    mutating func toggle(){
        switch self{
        case .C:
            self = .K
        case .K:
            self = .C
        }
    }
    
    func symbol() -> String{
        switch self{
        case .C:
            return UnitTemperature.celsius.symbol
        case .K:
            return UnitTemperature.fahrenheit.symbol
        }
    }
}

struct ForecastView: View {
    
    @State var cityOfForecast: String = "Toronto"
    
    @State var usingUnit: TemperatureUnit = .C
    
    @EnvironmentObject var api: APIConnection
    
    @State var timeSelected: TimesOfDay = .afternoon
    
    @State var cardColor: Color = Color.white
    @State var backgroundGradient: LinearGradient = LinearGradient(
        colors: [Color.yellow,Color.cyan, Color.blue],
        startPoint: .topTrailing, endPoint: .bottomLeading)
    
    let sunriseGradient = LinearGradient(
        colors: [Color.orange,Color.indigo, Color.black],
        startPoint: .topTrailing, endPoint: .bottomLeading)
    let sunsetGradient = LinearGradient(
        colors: [Color.yellow,Color.indigo, Color.black],
        startPoint: .topLeading, endPoint: .bottomTrailing)
    
    let morningGradient = LinearGradient(
        colors: [Color.yellow,Color.blue, Color.indigo],
        startPoint: .topTrailing, endPoint: .bottomLeading)
    let afternoonGradient = LinearGradient(
        colors: [Color.yellow,Color.cyan, Color.blue],
        startPoint: .top, endPoint: .bottom)
    let eveningGradient = LinearGradient(
        colors: [Color.yellow,Color.blue, Color.indigo],
        startPoint: .topLeading, endPoint: .bottomTrailing)
    
    let nightGradient = LinearGradient(
        colors: [Color.indigo, Color.black],
        startPoint: .top, endPoint: .bottom)
    
    var body: some View {
        
        NavigationView{
            ZStack{
                backgroundGradient.ignoresSafeArea()
                VStack{
//                    Picker("", selection: $timeSelected){
//                        Text("Sunrise").tag(TimesOfDay.sunrise)
//                        Text("Morning").tag(TimesOfDay.morining)
//                        Text("Afternoon").tag(TimesOfDay.afternoon)
//                        Text("Evening").tag(TimesOfDay.evening)
//                        Text("Sunset").tag(TimesOfDay.sunset)
//                        Text("Night").tag(TimesOfDay.night)
//                    }.onChange(of: timeSelected){newValue in
//                        switch newValue{
//                        case .sunrise:
//                            backgroundGradient = sunriseGradient
//                            cardColor = Color.orange
//                        case .morining:
//                            backgroundGradient = morningGradient
//                            cardColor = Color.yellow
//                        case .afternoon:
//                            backgroundGradient = afternoonGradient
//                            cardColor = Color.white
//                        case .evening:
//                            backgroundGradient = eveningGradient
//                            cardColor = Color.yellow
//                        case .sunset:
//                            backgroundGradient = sunsetGradient
//                            cardColor = Color.orange
//                        case .night:
//                            backgroundGradient = nightGradient
//                            cardColor = Color.purple
//                        }
//                    }.pickerStyle(.segmented)
                    ScrollView{
                        if api.fiveDayForcast.datesOfWeatherForcast != nil{
                            ForEach(0..<5){index in
                                WeatherCardView(fiveDayForecast: api.fiveDayForcast, dayIndex: index, darkestColor: cardColor, unit: usingUnit)
                            }
                        }
                        else{
                            Text("Error geting weather data, try connecting to the internet")
                        }
                    }
                }.padding(.top, 85)
            }
            
            
            .onAppear{
                self.refreshAPI()
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    //Spacer()
                    VStack{
                        Spacer()
                        //choosen city
                        Text(cityOfForecast).font(.largeTitle).bold().foregroundColor(Color.white).shadow(color: Color.black, radius: 5, x: 2, y: 2)
                        Text("\(api.fiveDayForcast.temperature?.asTemperature(unit: usingUnit) ?? "N/A")").font(.custom("temp", size: 65)).foregroundColor(Color.white).shadow(color: Color.black, radius: 5, x: 2, y: 2)
                    }.padding(.top, 70)
                    
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    //choosen city
                    Button(action:{
                        self.refreshAPI()
                    }){
                        Image(systemName: "arrow.clockwise")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    //choosen city
                    Button(action:{
                        usingUnit.toggle()
                        self.refreshAPI()
                    }){
                        HStack{
                            Text(UnitTemperature.celsius.symbol)
                            Text("/")
                            Text(UnitTemperature.fahrenheit.symbol)
                        }
                    }
                }
            }//.padding(.top, 5)
            .navigationBarTitleDisplayMode(.inline)
            //.toolbarBackground(cardColor, for: .navigationBar)
            //.toolbarBackground(.hidden, for: .navigationBar)
            
        }
        
    }
    
    func refreshAPI(){
        Task{
            await api.get5DayForcast(inDegree: usingUnit.rawValue)
            let hour: String = Date.now.formatted(.dateTime.hour())
            
            for partOfDay in TimesOfDay.all{
                if partOfDay.formattedHours().contains(hour){
                    switch partOfDay{
                    case .sunrise:
                        backgroundGradient = sunriseGradient
                        cardColor = Color.orange
                    case .morining:
                        backgroundGradient = morningGradient
                        cardColor = Color.yellow
                    case .afternoon:
                        backgroundGradient = afternoonGradient
                        cardColor = Color.white
                    case .evening:
                        backgroundGradient = eveningGradient
                        cardColor = Color.yellow
                    case .sunset:
                        backgroundGradient = sunsetGradient
                        cardColor = Color.orange
                    case .night:
                        backgroundGradient = nightGradient
                        cardColor = Color.purple
                    }
                    break
                }
            }
        }
    }
    
}

struct ForecastView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastView()
    }
}
