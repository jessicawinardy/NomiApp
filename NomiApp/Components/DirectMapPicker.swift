//
//  DirectMapPicker.swift
//  NomiApp
//
//  Created by Jessica Evangeline Winardy on 16/06/26.
//

import SwiftUI
import MapKit
import CoreLocation

struct DirectMapPicker: View {
    @Environment(\.dismiss) private var dismiss
    
    // Titik awal peta
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -6.2088, longitude: 106.8456),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: -6.2088, longitude: 106.8456),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )
    
    // Callback untuk melempar data Kota dan Negara sekaligus
    var onLocationPicked: (String, String) -> Void
    
    var body: some View {
        NavigationStack {
            ZStack {
                Map(position: $cameraPosition)
                    .ignoresSafeArea(edges: .bottom)
                    .onMapCameraChange(frequency: .onEnd) { context in
                        region = context.region
                    }
                
                // Pin penunjuk tengah layar
                Image(systemName: "mappin")
                    .font(.title)
                    .foregroundColor(.red)
                    .offset(y: -15)
                
                VStack {
                    Spacer()
                    Button("Gunakan Lokasi Ini") {
                        Task {
                            await extractCityAndCountry()
                        }
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .clipShape(Capsule())
                    .padding()
                }
            }
            .navigationTitle("Pilih di Peta")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // Fungsi mengubah koordinat menjadi teks fisik Kota & Negara
    @MainActor
    private func extractCityAndCountry() async {
        let location = CLLocation(latitude: region.center.latitude, longitude: region.center.longitude)

        guard let request = MKReverseGeocodingRequest(location: location) else {
            onLocationPicked("Unknown City", "Unknown Country")
            dismiss()
            return
        }

        do {
            let mapItems = try await request.mapItems
            if let address = mapItems.first?.addressRepresentations {
                let kota = address.cityName ?? "Unknown City"
                let negara = address.regionName ?? "Unknown Country"

                onLocationPicked(kota, negara) // Kirim dua data terpisah
            } else {
                onLocationPicked("Unknown City", "Unknown Country")
            }
        } catch {
            onLocationPicked("Unknown City", "Unknown Country")
        }

        dismiss()
    }
}
