//
//  WeatherObject.swift
//  SimpleWeatherApplication
//
//  Created by Alex Olechnowicz on 2023-05-30.
//

import Foundation

class WeatherObject: Codable{
    
    var temperature: Double?
    var datesOfWeatherForcast: [String]?
    var highTemperatures: [Double]?
    var lowTemperatures: [Double]?
    var probabilitiesOfPercipitation: [Double]?
    
    init(temperature: Double? = nil, datesOfWeatherForcast: [String]? = nil, highTemperatures: [Double]? = nil, lowTemperatures: [Double]? = nil, probabilitiesOfPercipitation: [Double]? = nil) {
        self.temperature = temperature
        self.datesOfWeatherForcast = datesOfWeatherForcast
        self.highTemperatures = highTemperatures
        self.lowTemperatures = lowTemperatures
        self.probabilitiesOfPercipitation = probabilitiesOfPercipitation
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: WeatherKeys.self)
        
        print("passed container")
        
        let dailyContainer = try container.nestedContainer(keyedBy: WeatherKeys.ParameterKeys.self, forKey: .daily)
        
        print("passed daily container")
        
        let currentContainer = try container.nestedContainer(keyedBy: WeatherKeys.CurrentTempKey.self, forKey: .current_weather)
        
        print("passed current container")
        
        self.temperature = try currentContainer.decodeIfPresent(Double.self, forKey: .temperature)
        
        print(self.temperature!)
        
        self.datesOfWeatherForcast = try dailyContainer.decodeIfPresent([String].self, forKey: .time)
        
        print(self.datesOfWeatherForcast!)
        
        self.highTemperatures = try dailyContainer.decodeIfPresent([Double].self, forKey: .temperature_2m_max)
        
        print(self.highTemperatures!)
        
        self.lowTemperatures = try dailyContainer.decodeIfPresent([Double].self, forKey: .temperature_2m_min)
        
        print(self.lowTemperatures!)
        
        self.probabilitiesOfPercipitation = try dailyContainer.decodeIfPresent([Double].self, forKey: .precipitation_probability_mean)
        
        print(self.probabilitiesOfPercipitation!)
    }
    
    enum WeatherKeys: CodingKey{
        case daily
        
        enum ParameterKeys: CodingKey{
            
            case time
            case temperature_2m_max
            case temperature_2m_min
            case precipitation_probability_mean
            
        }
        
        case current_weather
        
        enum CurrentTempKey: CodingKey{
                case temperature
            }
    }
    
}
