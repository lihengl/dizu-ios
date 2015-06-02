import CoreLocation
import UIKit

private let dateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.dateStyle = .MediumStyle
    formatter.timeStyle = .ShortStyle
    return formatter
}()

class LocationDetailsViewController: UITableViewController {
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var placemark: CLPlacemark?

    func stringFromPlacemark(placemark: CLPlacemark) -> String {
        return
            "\(placemark.subThoroughfare) \(placemark.thoroughfare)" +
            "\(placemark.locality) \(placemark.administrativeArea)" +
            "\(placemark.postalCode) \(placemark.country)"
    }

    func getAddressLabelSize() -> CGSize {
        return CGSize(width: view.bounds.size.width - 115, height: 10000)
    }

    func getAddressLabelOriginX() -> CGFloat {
        return (view.bounds.size.width - addressLabel.frame.size.width - 15)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionTextView.text = ""
        categoryLabel.text = ""

        longitudeLabel.text = String(format: "%.8f", coordinate.longitude)
        latitudeLabel.text = String(format: "%.8f", coordinate.latitude)

        if let placemark = placemark {
            addressLabel.text = stringFromPlacemark(placemark)
        } else {
            addressLabel.text = "No Address Found"
        }

        dateLabel.text = dateFormatter.stringFromDate(NSDate())
    }

    override func tableView(tableView: UITableView,
        heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return 88
        } else if indexPath.section == 2 && indexPath.row == 2 {
            addressLabel.frame.size = getAddressLabelSize()
            addressLabel.sizeToFit()
            addressLabel.frame.origin.x = getAddressLabelOriginX()
            return (addressLabel.frame.size.height + 20)
        } else {
            return 44
        }
    }

    @IBAction func cancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func done() {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
