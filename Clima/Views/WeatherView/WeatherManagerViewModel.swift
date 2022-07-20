//
//  WeatherManager.swift
//  Clima
//
//  Created by admin on 27/06/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation


enum StatusLogOut {
    case Successed
    case Failed
}

protocol WeatherManagerDelegate: AnyObject {
    func didUpdateWeather(_ weatherManger: WeatherManagerViewModel, weather: WeatherModel)
    func didFailWithError(error: Error)
}

class WeatherManagerViewModel {
        
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=c9db25feaa50da245b8f05b969e3136f&units=metric"
    weak var delegate: WeatherManagerDelegate?
    
    func fetchWeather(city: String) {
        let urlString = "\(weatherURL)&q=\(city)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(longtitude: CLLocationDegrees, latitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lon=\(longtitude)&lat=\(latitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        
        //1.Create a URL
        if let url = URL(string: urlString) {
            
            //2. Create a URL Session
            let session = URLSession(configuration: .default)
            
            //3. Give the session a task
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    self.delegate?.didFailWithError(error: error)
                    return
                }
                if let safeData = data {
                    //let dataString = String(data: safeData, encoding: .utf8) Using to print String data encoding .uft8
                    //print(dataString)
                    if  let weather = self.parseJSON(safeData) { // Unwrap Optional weathermodel
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            //4.Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
          let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id // Get id from data feedback from server
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    
    }
}
