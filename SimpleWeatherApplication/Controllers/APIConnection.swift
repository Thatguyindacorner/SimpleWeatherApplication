//
//  APIConnection.swift
//  SimpleWeatherApplication
//
//  Created by Alex Olechnowicz on 2023-05-30.
//

import Foundation

class APIConnection: ObservableObject{
    
    @Published var fiveDayForcast: WeatherObject = WeatherObject()
    
    var baseURL: String = "https://api.open-meteo.com/v1/forecast?"
    
    var latlng: String = "latitude=43.70&longitude=-79.42" //needed (Toronto)
    var timezone: String = "&timezone=America%2FNew_York" //needed (EST)
    
    //required parameters
    var parameters: String = "&daily=temperature_2m_max,temperature_2m_min,precipitation_probability_mean"
    
    //each call will refresh
    func get5DayForcast() async {
        
        guard let api = URL(string: "\(baseURL)\(latlng)\(timezone)\(parameters)")
        else{
            print(#function, "Unable to convert string to URL")
            return
        }
        
        URLSession.shared.dataTask(with: api){ (data: Data?, response: URLResponse?, error: Error?) in
            
            guard error == nil
            else{
                //some error occured getting data
                print(#function, error!.localizedDescription)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse
            else{
                //error getting / converting code
                print(#function, response!)
                return
            }
            
            guard httpResponse.statusCode == 200
            else{
                //error code
                print(httpResponse.statusCode)
                return
            }
            
            guard data != nil
            else{
                //no data to read
                print("no data")
                return
            }
            
            let jsonDecoder = JSONDecoder()
            do{
                let weather = try jsonDecoder.decode(WeatherObject.self, from: data!)
                DispatchQueue.main.sync {
                    self.fiveDayForcast = weather
                    self.removeExtraDaysFromForcastToMake5Day()
                    print(#function, "api data successfully converted and assigned to variable")
                }
            }
            catch{
                print(#function, "could not decode data to WeatherObject")
            }
            
        }.resume()
        
    }
    
    private func removeExtraDaysFromForcastToMake5Day(){
        
        guard self.fiveDayForcast.datesOfWeatherForcast != nil
        else{
            print(#function, "forcast not found yet")
            return
        }
        
        if self.fiveDayForcast.datesOfWeatherForcast!.count > 5{
            let extraDays = self.fiveDayForcast.datesOfWeatherForcast!.count - 5
            for _ in (1...extraDays){
                self.fiveDayForcast.datesOfWeatherForcast!.removeLast()
                self.fiveDayForcast.highTemperatures!.removeLast()
                self.fiveDayForcast.lowTemperatures!.removeLast()
                self.fiveDayForcast.probabilitiesOfPercipitation!.removeLast()
            }
        }
        
    }
    
}
