//
//  ViewController.swift
//  WeatherApp
//
//  Created by Дмитрий Войтович on 01.05.2022.
//

import UIKit

class MainViewController: UIViewController {
    private let weatcherService: WeatherService
    
    private let locationService = LocationService()
    
    init(weatherService: WeatherService) {
        self.weatcherService = weatherService
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureAllConstraints()

        getCurrentWeather()
        let image = UIImage(systemName: "tortoise.fill")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(didTapButton))
        navigationController?.navigationBar.tintColor = .systemIndigo
        
        weatcherService.weatherDidChange = { [weak self] in
            guard let self = self else { return }
            
            self.getCurrentWeather()
        }
        
        locationService.delegate = self
        
        locationService.onLocationUpdated = { [weak self] result in
            guard let self = self else { return }
            
            
            switch result {
            case .success(let location):
                location.fetchCityAndCountry { [weak self] city, country, error in
                    guard let self = self else { return }
                    
                    guard let city = city, let country = country, error == nil else { return }
                    print(city + "," + country)
                    let cityAndCountry = city + "," + country
                    self.weatcherService.city = cityAndCountry
                }
            case .failure(let error):
                if let locationError = error as? LocationError {
                    switch locationError {
                    case .resticted:
                        //...
                        break
                    case .denied:
                        //...
                        break
                    }
                } else {
                    
                }
            }
        }
        
        locationService.requestLocation()
    }
    
    @objc func didTapButton() {
        let citiesViewController = CitiesViewController(weatherService: weatcherService)
        navigationController?.pushViewController(citiesViewController, animated: true)
    }
    
    
    private func getCurrentWeather() {
        weatcherService.getWeatherInfo { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let info):
                self.cityNameLabel.text = info.address
                self.weatherImage.image = UIImage(named: info.days.first?.icon ?? "unpredicted-icon")
                self.feelsLikeLabel.text = info.days.first?.feelslikeString
                self.tempLabel.text = info.days.first?.tempString
                self.moistnessLabel.text = info.days.first?.humidityString
                self.precipitationLabel.text = info.days.first?.pressureString
                print(info)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    
    let cityNameLabel: UILabel = {
       let label = UILabel()
        label.tintColor = .black
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 40, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    let weatherImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let precipitationLabel: UILabel = {
       let label = UILabel()
        label.tintColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let moistnessLabel: UILabel = {
        let label = UILabel()
        label.tintColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tempLabel: UILabel = {
       let label = UILabel()
        label.tintColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 80, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let feelsLikeLabel: UILabel = {
       let label = UILabel()
        
        label.tintColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 34, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func configureAllConstraints() {
        
        view.addSubview(cityNameLabel)
        cityNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        cityNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cityNameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100).isActive = true
        
        view.addSubview(weatherImage)
        weatherImage.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor).isActive = true
        weatherImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        weatherImage.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        weatherImage.heightAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        view.addSubview(precipitationLabel)
        precipitationLabel.topAnchor.constraint(equalTo: weatherImage.bottomAnchor).isActive = true
        precipitationLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        precipitationLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(moistnessLabel)
        moistnessLabel.topAnchor.constraint(equalTo: weatherImage.bottomAnchor).isActive = true
        moistnessLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        moistnessLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(feelsLikeLabel)
        feelsLikeLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        feelsLikeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        feelsLikeLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    
        view.addSubview(tempLabel)
        tempLabel.bottomAnchor.constraint(equalTo: feelsLikeLabel.topAnchor).isActive = true
        tempLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tempLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
     
    }
    
}

extension MainViewController: LocationServiceDelegate {
    func locationServiceDidUpdateLocation(_ location: LocationResponse) {
        
    }
    
    func locationServiceDidFailWithError(_ error: Error) {
        
    }
}
