import UIKit

protocol ListDetailViewControllerDelegate: class {
    func listDetailViewControllerDidCancel(controller: ListDetailViewController)
    func listDetailViewController(controller: ListDetailViewController,
        didFinishAddingList list: Checklist
    )
    func listDetailViewController(controller: ListDetailViewController,
        didFinishEditingList list: Checklist
    )
}

class ListDetailViewController: UITableViewController,
    UITextFieldDelegate, IconPickerViewControllerDelegate {
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var iconImage: UIImageView!

    weak var delegate: ListDetailViewControllerDelegate?
    var listToEdit: Checklist?
    var iconName = "Folder"

    func textField(textField: UITextField,
        shouldChangeCharactersInRange range: NSRange,
        replacementString string: String) -> Bool {
        let oldText: NSString = textField.text
        let newText: NSString = oldText.stringByReplacingCharactersInRange(range,
            withString: string
        )
        doneBarButton.enabled = (newText.length > 0)
        return true
    }

    func iconPicker(picker: IconPickerViewController,
        didPickIcon iconName: String) {
        self.iconName = iconName
        iconImage.image = UIImage(named: iconName)
        navigationController?.popViewControllerAnimated(true)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 44
        if let list = listToEdit {
            title = "Edit Checklist"
            textField.text = list.name
            doneBarButton.enabled = true
            iconName = list.icon
        }
        iconImage.image = UIImage(named: iconName)
    }

    override func tableView(tableView: UITableView,
        willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section == 1 {
            return indexPath
        } else {
            return nil
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PickIcon" {
            let controller = segue.destinationViewController
                as! IconPickerViewController
            controller.delegate = self
        }
    }

    @IBAction func cancel() {
        delegate?.listDetailViewControllerDidCancel(self)
    }

    @IBAction func done() {
        if let list = listToEdit {
            list.name = textField.text
            list.icon = iconName
            delegate?.listDetailViewController(self, didFinishEditingList: list)
        } else {
            let list = Checklist(name: textField.text, icon: iconName)
            delegate?.listDetailViewController(self, didFinishAddingList: list)
        }
    }

}
