import CoreLocation
import UIKit

class CurrentLocationViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var getButton: UIButton!

    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()

    var performingReverseGeocoding = false
    var updatingLocation = false

    var lastGeocodingError: NSError?
    var lastLocationError: NSError?

    var placemark: CLPlacemark?
    var location: CLLocation?

    var timer: NSTimer?

    func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(title: "Location Services Disabled",
            message: "Please enable location services for this app in Settings.",
            preferredStyle: .Alert
        )
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(okAction)
        presentViewController(alert, animated: true, completion: nil)
    }

    func didTimeOut() {
        println("*** Time Out")
        if location == nil {
            stopLocationManager()
            lastLocationError = NSError(domain: "MyLocationErrorDomain",
                code: 1, userInfo: nil
            )
            updateLabels()
            configureGetButton()
        }
    }

    func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            updatingLocation = true
            timer = NSTimer.scheduledTimerWithTimeInterval(30,
                target: self,
                selector: Selector("didTimeOut"),
                userInfo: nil,
                repeats: false
            )
        }
    }

    func stopLocationManager() {
        if updatingLocation {
            if let timer = timer { timer.invalidate() }
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
        }
    }

    func configureGetButton() {
        let title = updatingLocation ? "Stop" : "Get My Location"
        getButton.setTitle(title, forState: .Normal)
    }

    func getStatusMessageFromError(error: NSError) -> String {
        if error.domain == kCLErrorDomain && error.code == CLError.Denied.rawValue {
            return "Location Services Disabled"
        }
        return "Error Getting Location"
    }

    func stringFromPlacemark(placemark: CLPlacemark) -> String {
        return
            "\(placemark.subThoroughfare) \(placemark.thoroughfare)\n" +
            "\(placemark.locality) \(placemark.administrativeArea)" +
            "\(placemark.postalCode)"
    }

    func updateLabels() {
        if let location = location {
            longitudeLabel.text = String(format: "%.8f", location.coordinate.longitude)
            latitudeLabel.text = String(format: "%.8f", location.coordinate.latitude)
            messageLabel.text = ""
            tagButton.hidden = false

            if let placemark = placemark {
                addressLabel.text = stringFromPlacemark(placemark)
            } else if performingReverseGeocoding {
                addressLabel.text = "Searching for Address..."
            } else if lastGeocodingError != nil {
                addressLabel.text = "Error Finding Address"
            } else {
                addressLabel.text = "No Address Found!"
            }

        } else {
            longitudeLabel.text = ""
            latitudeLabel.text = ""
            tagButton.hidden = true

            var statusMessage: String

            if let error = lastLocationError {
                statusMessage = getStatusMessageFromError(error)
            } else if !CLLocationManager.locationServicesEnabled() {
                statusMessage = "Location Services Disabled"
            } else if updatingLocation {
                statusMessage = "Searching..."
            } else {
                statusMessage = "Tap 'Get My Location' to Start"
            }

            messageLabel.text = statusMessage
        }
    }

    func locationManager(manager: CLLocationManager!,
        didFailWithError error: NSError!) {
        println("Did Fail with Error: \(error)")
        if error.code == CLError.LocationUnknown.rawValue { return }

        lastLocationError = error
        stopLocationManager()
        updateLabels()
        configureGetButton()
    }

    func locationManager(manager: CLLocationManager!,
        didUpdateLocations locations: [AnyObject]!) {
        let newLocation = locations.last as! CLLocation

        if newLocation.timestamp.timeIntervalSinceNow < -5 { return }
        if newLocation.horizontalAccuracy < 0 { return }

        var distance = CLLocationDistance(DBL_MAX)
        if let location = location {
            distance = newLocation.distanceFromLocation(location)
        }

        if location == nil || location!.horizontalAccuracy > newLocation.horizontalAccuracy {
            lastLocationError = nil
            location = newLocation
            updateLabels()

            if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy {
                println("We're Done!")
                stopLocationManager()
                configureGetButton()

                if distance > 0 {
                    performingReverseGeocoding = false
                }
            }

            if !performingReverseGeocoding {
                println("*** Going to Geocode")
                performingReverseGeocoding = true
                geocoder.reverseGeocodeLocation(location, completionHandler: {
                    placemarks, error in
                    println("*** Found Placemarks: \(placemarks), error: \(error)")
                    self.lastGeocodingError = error
                    if error == nil && !placemarks.isEmpty {
                        self.placemark = placemarks.last as? CLPlacemark
                    } else {
                        self.placemark = nil
                    }
                    self.performingReverseGeocoding = false
                    self.updateLabels()
                })
            }
        } else if distance < 1.0 {
            let timeInterval = newLocation.timestamp.timeIntervalSinceDate(location!.timestamp)
            if timeInterval > 10 {
                println("*** Force Done!")
                stopLocationManager()
                updateLabels()
                configureGetButton()
            }
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabels()
        configureGetButton()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier != "TagLocation" { return }
        let navigation = segue.destinationViewController as! UINavigationController
        let controller = navigation.topViewController as! LocationDetailsViewController
        controller.coordinate = location!.coordinate
        controller.placemark = placemark
    }

    @IBAction func getLocation() {
        let authStatus = CLLocationManager.authorizationStatus()

        if authStatus == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
            return;
        }
        if authStatus == .Denied || authStatus == .Restricted {
            showLocationServicesDeniedAlert()
            return;
        }

        if updatingLocation {
            stopLocationManager()
        } else {
            location = nil
            lastLocationError = nil
            placemark = nil
            lastGeocodingError = nil
            startLocationManager()
        }

        updateLabels()
        configureGetButton()
    }

}
