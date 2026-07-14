//
//  DirectMapPicker.swift
//  NomiApp
//
//  Created by Jessica Evangeline Winardy on 16/06/26.
//

import SwiftUI
import MapKit
import CoreLocation

final class DirectMapPickerLocationService: NSObject, CLLocationManagerDelegate {
    var onLocationUpdate: ((CLLocation) -> Void)?
    var onLocationFailure: ((Error) -> Void)?

    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func requestLocationPermission() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .denied, .restricted:
            break
        @unknown default:
            break
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            manager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        onLocationUpdate?(location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        onLocationFailure?(error)
    }
}

struct DirectMapPicker: View {
    @Environment(\.dismiss) private var dismiss

    @State private var cameraPosition: MapCameraPosition
    @State private var centerCoordinate: CLLocationCoordinate2D
    @State private var isResolvingUserLocation = true
    @State private var locationService = DirectMapPickerLocationService()

    // Callback untuk melempar data Kota, Negara, dan koordinat terakhir sekaligus
    var onLocationPicked: (String, String, CLLocationCoordinate2D) -> Void

    init(
        initialCoordinate: CLLocationCoordinate2D? = nil,
        onLocationPicked: @escaping (String, String, CLLocationCoordinate2D) -> Void
    ) {
        self.onLocationPicked = onLocationPicked

        let fallbackCoordinate = CLLocationCoordinate2D(latitude: -6.2088, longitude: 106.8456)
        let startingCoordinate = initialCoordinate ?? fallbackCoordinate

        _cameraPosition = State(
            initialValue: .userLocation(
                fallback: .region(
                    MKCoordinateRegion(
                        center: startingCoordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    )
                )
            )
        )
        _centerCoordinate = State(initialValue: startingCoordinate)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Map(position: $cameraPosition) {
                    UserAnnotation()
                }
                .ignoresSafeArea(edges: .bottom)
                .onMapCameraChange(frequency: .onEnd) { context in
                    centerCoordinate = context.camera.centerCoordinate
                }

                Image(systemName: "mappin")
                    .font(.title)
                    .foregroundColor(.red)
                    .offset(y: -15)

                if isResolvingUserLocation {
                    VStack(spacing: 8) {
                        ProgressView()
                        Text("Finding your current location...")
                            .font(.footnote.weight(.semibold))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 4)
                    .padding(.top, 72)
                    .frame(maxHeight: .infinity, alignment: .top)
                }

                VStack {
                    Spacer()
                    Button("Use this location") {
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
            .navigationTitle("Choose on Map")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                isResolvingUserLocation = true
                locationService.onLocationUpdate = { location in
                    DispatchQueue.main.async {
                        centerCoordinate = location.coordinate
                        cameraPosition = .region(
                            MKCoordinateRegion(
                                center: location.coordinate,
                                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                            )
                        )
                        isResolvingUserLocation = false
                    }
                }

                locationService.onLocationFailure = { error in
                    DispatchQueue.main.async {
                        isResolvingUserLocation = false
                    }
                    print("Location update failed: \(error.localizedDescription)")
                }

                locationService.requestLocationPermission()
            }
        }
    }

    @MainActor
    private func extractCityAndCountry() async {
        let location = CLLocation(
            latitude: centerCoordinate.latitude,
            longitude: centerCoordinate.longitude
        )

        guard let request = MKReverseGeocodingRequest(location: location) else {
            onLocationPicked("Unknown City", "Unknown Country", centerCoordinate)
            dismiss()
            return
        }

        do {
            let mapItems = try await request.mapItems
            if let address = mapItems.first?.addressRepresentations {
                let kota = address.cityName ?? "Unknown City"
                let negara = address.regionName ?? "Unknown Country"

                onLocationPicked(kota, negara, centerCoordinate)
            } else {
                onLocationPicked("Unknown City", "Unknown Country", centerCoordinate)
            }
        } catch {
            onLocationPicked("Unknown City", "Unknown Country", centerCoordinate)
        }
        dismiss()
    }
}
