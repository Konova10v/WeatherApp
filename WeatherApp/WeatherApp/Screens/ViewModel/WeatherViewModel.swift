//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Кирилл Коновалов on 26.05.2025.
//

import Foundation
import CoreLocation

@MainActor
class WeatherViewModel: ObservableObject {
	@Published var forecastDays: [ForecastDay] = []
	@Published var cityName: String = "Загрузка..."
	@Published var isLoading = false
	@Published var errorMessage: String?

	private let apiKey = "87a7d4e3259642f1997114527252605"

	func loadWeather(for location: CLLocation?) async {
		isLoading = true
		errorMessage = nil

		do {
			let weather: WeatherResponse
			if let location = location {
				weather = try await fetchWeather(query: "\(location.coordinate.latitude),\(location.coordinate.longitude)")
			} else {
				weather = try await fetchWeather(query: "Moscow")
			}

			self.cityName = weather.location.name
			self.forecastDays = weather.forecast.forecastday
		} catch {
			self.cityName = "Неизвестно"
			self.errorMessage = "Ошибка: \(error.localizedDescription)"
		}

		isLoading = false
	}

	private func fetchWeather(query: String) async throws -> WeatherResponse {
		guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
			throw URLError(.badURL)
		}

		let urlString = "https://api.weatherapi.com/v1/forecast.json?q=\(encodedQuery)&days=5&key=\(apiKey)"
		guard let url = URL(string: urlString) else {
			throw URLError(.badURL)
		}

		let (data, response) = try await URLSession.shared.data(from: url)

		guard let httpResponse = response as? HTTPURLResponse,
			  (200...299).contains(httpResponse.statusCode) else {
			throw URLError(.badServerResponse)
		}

		return try JSONDecoder().decode(WeatherResponse.self, from: data)
	}
}
