//
//  ContentView.swift
//  WeatherApp
//
//  Created by Кирилл Коновалов on 26.05.2025.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
	@StateObject var viewModel = WeatherViewModel()
	@StateObject var locationManager = LocationManager()

	var body: some View {
		NavigationView {
			if viewModel.isLoading {
				ProgressView("Загрузка...")
					.navigationTitle("Погода")
			} else if let error = viewModel.errorMessage {
				Text(error)
					.foregroundColor(.red)
					.padding()
					.navigationTitle("Ошибка")
			} else {
				List(viewModel.forecastDays, id: \.date) { day in
					HStack(alignment: .top) {
						AsyncImage(url: URL(string: "https:\(day.day.condition.icon)")) { image in
							image.resizable()
						} placeholder: {
							ProgressView()
						}
						.frame(width: 50, height: 50)

						VStack(alignment: .leading, spacing: 4) {
							Text(day.date).font(.headline)
							Text(day.day.condition.text)
							Text("🌡 \(day.day.avgtemp_c, specifier: "%.1f")°C")
							Text("💨 \(day.day.maxwind_kph, specifier: "%.1f") kph")
							Text("💧 \(day.day.avghumidity, specifier: "%.1f")%")
						}
					}
					.padding(.vertical, 4)
				}
				.navigationTitle("Погода: \(viewModel.cityName)")
			}
		}
		.onAppear {
			Task {
				await viewModel.loadWeather(for: locationManager.location)
			}
		}
	}
}

#Preview {
    ContentView()
}
