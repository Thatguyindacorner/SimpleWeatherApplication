//
//  WeatherObject.swift
//  SimpleWeatherApplication
//
//  Created by Alex Olechnowicz on 2023-05-30.
//

import Foundation

class WeatherObject: Codable{
    
    var datesOfWeatherForcast: [String]?
    var highTemperatures: [String]?
    var lowTemperatures: [String]?
    var probabilitiesOfPercipitation: [String]?
    
    init(datesOfWeatherForcast: [String]? = nil, highTemperatures: [String]? = nil, lowTemperatures: [String]? = nil, probabilitiesOfPercipitation: [String]? = nil) {
        self.datesOfWeatherForcast = datesOfWeatherForcast
        self.highTemperatures = highTemperatures
        self.lowTemperatures = lowTemperatures
        self.probabilitiesOfPercipitation = probabilitiesOfPercipitation
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: WeatherKeys.self)
        
        let dailyContainer = try container.nestedContainer(keyedBy: WeatherKeys.ParameterKeys.self, forKey: .daily)
        
        self.datesOfWeatherForcast = try dailyContainer.decodeIfPresent([String].self, forKey: .time)
        
        self.highTemperatures = try dailyContainer.decodeIfPresent([String].self, forKey: .temperature_2m_max)
        self.lowTemperatures = try dailyContainer.decodeIfPresent([String].self, forKey: .temperature_2m_min)
        self.probabilitiesOfPercipitation = try dailyContainer.decodeIfPresent([String].self, forKey: .precipitation_probability_mean)
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
