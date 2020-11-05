//
//  ViewController.swift
//  NewHudApp
//
//  Created by Владислав Никольский on 03.11.2020.
//  Copyright © 2020 Владислав Никольский. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    
    
    
    @IBOutlet weak var pathLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var gaugeView: GaugeView!
    @IBOutlet weak var resetButtonOutlet: UIButton!
    @IBAction func resetButtonAction(_ sender: UIButton) {
        traveledDistance = 0
    }
    @IBOutlet weak var avgSpeedOutlet: UILabel!
    @IBAction func hudButtonAction(_ sender: PushButton) {
        
        if isSet == false {
            view.flipY()
            UIScreen.main.brightness = CGFloat(1.0)
            isSet = !isSet
            view.backgroundColor = .black
            gaugeView.insideColor.withAlphaComponent(0.3)
            resetButtonOutlet.alpha = 0.6
            hudButtonOutlet.alpha = 0.6
        } else {
            view.flipY()
            UIScreen.main.brightness = CGFloat(0.5)
            isSet = !isSet
            view.backgroundColor = .darkGray
            gaugeView.insideColor = .darkGray
            resetButtonOutlet.alpha = 1
            hudButtonOutlet.alpha = 1
        }
    }
    @IBOutlet weak var hudButtonOutlet: PushButton!
    
    //MARK: Weather Manager Setup
    var networkWeatherManager = NetworkWeatherManager()
       lazy var locationManager: CLLocationManager = {
           let lm = CLLocationManager()
           lm.delegate = self
           lm.desiredAccuracy = kCLLocationAccuracyBest
           lm.requestWhenInUseAuthorization()
           return lm
       }()

    
    let gauge = GaugeView()
    var speed: Double = 0.0
    var speedInKmh: Double = 0.0
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    var traveledDistance: Double = 0
    var isSet = false
    var speeds = [CLLocationSpeed]()
    var avgSpeed: CLLocationSpeed {
        return speeds.reduce(0,+)/Double(speeds.count)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        gauge.backgroundColor = .clear
        locationManager.startUpdatingLocation()
        pathLabel.adjustsFontSizeToFitWidth = true
        gaugeView.backgroundColor = .clear
        
        
        //MARK: Weather Manager Request
        networkWeatherManager.onCompletion = { [weak self] currentWeather in
            guard let self = self else { return }
            self.updateInterfaceWith(weather: currentWeather)
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
    }

    
    func updateInterfaceWith(weather: CurrentWeather) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
        }
    }
    


}

// MARK: - CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //avg speed setting up
        speeds.append(contentsOf: locations.map{$0.speed})
        
        
        //traveled distance setting up
        if startLocation == nil {
            startLocation = locations.first
        } else if let location = locations.last {
            traveledDistance += lastLocation.distance(from: location)
            var distanceInKmh = traveledDistance/1000
            var distanceString: String {
                return String(format: "%.3f", distanceInKmh)
            }
            pathLabel.text = distanceString
        }
        lastLocation = locations.last
        
        if traveledDistance > 1000 {
            locationManager.distanceFilter = 50
        }
        
        //coords for weather setting up
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        networkWeatherManager.fetchCurrentWeather(forRequestType: .coordinate(latitude: latitude, longitude: longitude))
        speed = locationManager.location?.speed as! Double
        //speed label data setting up
        if speed > 0 {
            speedInKmh = self.speed*3.6
            var speedString: String {
                return String(format: "%.0f", speedInKmh)
            }
            
            gaugeView.valueLabel.text = speedString
            gaugeView.value = Int(speedInKmh)
            var avgSpeedInKmh = avgSpeed*3.6
            var avgSpeedString: String {
                return String(format: "%.0f", avgSpeedInKmh)
            }
            avgSpeedOutlet.text = avgSpeedString
        } else {
            gaugeView.valueLabel.text = "0"
            gaugeView.value = 0
            pathLabel.text = "0.000"
            avgSpeedOutlet.text = "0"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}


extension Array where Element: CLLocation {
  
    
    var totalDistance: CLLocationDistance {
        return reduce((0.0, nil), { ($0.0 + $1.distance(from: $0.1 ?? $1), $1) }).0
    }
  
}
