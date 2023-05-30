//
//  WeatherObject.swift
//  SimpleWeatherApplication
//
//  Created by Alex Olechnowicz on 2023-05-30.
//

import Foundation

class WeatherObject: Codable{
    
    var datesOfWeatherForcast: [String]?
    var highTemperatures: [Double]?
    var lowTemperatures: [Double]?
    var probabilitiesOfPercipitation: [Double]?
    
    init(datesOfWeatherForcast: [String]? = nil, highTemperatures: [Double]? = nil, lowTemperatures: [Double]? = nil, probabilitiesOfPercipitation: [Double]? = nil) {
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
    }
    
}
