import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func showAlert() {
        let action = UIAlertAction(
            title: "Awesome",
            style: .Default,
            handler: nil
        )

        let alert = UIAlertController(
            title: "Hello, world!",            
            message: "This is my first app!",
            preferredStyle: .Alert
        )

        alert.addAction(action)

        presentViewController(alert,
            animated: true,
            completion: nil
        )
    }

}

