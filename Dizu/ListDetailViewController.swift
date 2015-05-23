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
    UITextFieldDelegate {
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!

    weak var delegate: ListDetailViewControllerDelegate?
    var listToEdit: Checklist?

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

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 44
        if let list = listToEdit {
            title = "Edit List"
            textField.text = list.name
            doneBarButton.enabled = true
        }
    }

    override func tableView(tableView: UITableView,
        willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }

    @IBAction func cancel() {
        delegate?.listDetailViewControllerDidCancel(self)
    }

    @IBAction func done() {
        if let list = listToEdit {
            list.name = textField.text
            delegate?.listDetailViewController(self, didFinishEditingList: list)
        } else {
            let list = Checklist(name: textField.text)
            delegate?.listDetailViewController(self, didFinishAddingList: list)
        }
    }

}
