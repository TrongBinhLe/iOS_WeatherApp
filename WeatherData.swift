
import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Weather: Decodable {
    let description: String
    let id: Int
}

struct Main : Decodable {
    let temp: Double
}
