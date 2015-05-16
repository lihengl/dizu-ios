import QuartzCore
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var slider: UISlider!

    var currentValue = 0
    var targetValue = 0
    var score = 0
    var round = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        slider.setThumbImage(
            UIImage(named: "SliderThumb-Normal"),
            forState: .Normal
        )

        slider.setThumbImage(
            UIImage(named: "SliderThumb-Highlighted"),
            forState: .Highlighted
        )

        let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        if let trackLeftImage = UIImage(named: "SliderTrackLeft") {
            slider.setMinimumTrackImage(
                trackLeftImage.resizableImageWithCapInsets(insets),
                forState: .Normal
            )
        }
        if let trackRightImage = UIImage(named: "SliderTrackRight") {
            slider.setMaximumTrackImage(
                trackRightImage.resizableImageWithCapInsets(insets),
                forState: .Normal
            )
        }

        startNewRound()
        updateLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func updateLabels() {
        targetLabel.text = String(targetValue)
        scoreLabel.text = String(score)
        roundLabel.text = String(round)
    }

    func startNewRound() {
        targetValue = 1 + Int(arc4random_uniform(100))
        currentValue = 50
        slider.value = Float(currentValue)
        round += 1
    }

    @IBAction func sliderMoved(slider: UISlider) {
        currentValue = lroundf(slider.value)
    }

    @IBAction func startOver() {
        score = 0
        round = 0
        startNewRound()
        updateLabels()

        let transition = CATransition()
        transition.type = kCATransitionFade
        transition.duration = 1
        transition.timingFunction = CAMediaTimingFunction(
            name: kCAMediaTimingFunctionEaseOut
        )
        view.layer.addAnimation(transition, forKey: nil)
    }

    @IBAction func showAlert() {
        let difference = abs(targetValue - currentValue)
        var points = 100 - difference

        let action = UIAlertAction(
            title: "OK",
            style: .Default,
            handler: {action in
                self.startNewRound()
                self.updateLabels()
            }
        )

        var title: String

        if difference == 0 {
            title = "Perfect!"
            points += 100
        } else if difference == 1 {
            title = "You Almost Had It!"
            points += 1
        } else if difference < 5 {
            title = "Not Bad!"
        } else if difference < 10 {
            title = "Pretty Good!"
        } else {
            title = "Not Even Close..."
        }

        score += points

        let alert = UIAlertController(
            title: title,
            message: "You scored \(points) points",
            preferredStyle: .Alert
        )

        alert.addAction(action)

        presentViewController(alert,
            animated: true,
            completion: nil
        )
    }

}

