//
//  LocationService.swift
//  WeatherApp
//
//  Created by Дмитрий Войтович on 02.05.2022.
//

import CoreLocation

enum LocationError: Error {
    case resticted
    case denied
}

struct LocationResponse {
    let city: String
    let country: String
}

protocol LocationServiceDelegate: AnyObject {
    func locationServiceDidUpdateLocation(_ location: LocationResponse)
    func locationServiceDidFailWithError(_ error: Error)
}

final class LocationService: NSObject {
    override init() {
        super.init()
        
        locationManager.delegate = self
    }
    
    private let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        return manager
    }()
    
    var onLocationUpdated: ((Result<CLLocation, Error>) -> Void)?
    
    weak var delegate: LocationServiceDelegate?
    
    func requestLocation() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        case .denied:
            onLocationUpdated?(.failure(LocationError.denied))
        case .restricted:
            onLocationUpdated?(.failure(LocationError.resticted))
        @unknown default:
            break
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        case .denied:
            onLocationUpdated?(.failure(LocationError.denied))
        case .restricted:
            onLocationUpdated?(.failure(LocationError.resticted))
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        onLocationUpdated?(.success(location))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        onLocationUpdated?(.failure(error))
    }
}

extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self, preferredLocale: Locale(identifier: "en_US")) {
            completion($0?.first?.locality, $0?.first?.country, $1)
        }
    }
}
