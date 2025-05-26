//
//  WeatherModel.swift
//  Weather
//
//  Created by Кирилл Коновалов on 26.05.2025.
//

import Foundation

struct WeatherResponse: Decodable {
	let location: Location
	let forecast: Forecast
}

struct Location: Decodable {
	let name: String
	let region: String
	let country: String
}

struct Forecast: Decodable {
	let forecastday: [ForecastDay]
}

struct ForecastDay: Decodable {
	let date: String
	let day: Day
}

struct Day: Decodable {
	let avgtemp_c: Double
	let maxwind_kph: Double
	let avghumidity: Double
	let condition: Condition
}

struct Condition: Decodable {
	let text: String
	let icon: String
}
