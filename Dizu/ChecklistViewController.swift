import UIKit

class ChecklistViewController: UITableViewController,
    ItemDetailViewControllerDelegate {
    var checklist: Checklist!

    func configureCheckmarkForCell(cell: UITableViewCell,
        withChecklistItem item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        label.text = item.checked ? "√" : ""
    }

    func configureTextForCell(cell: UITableViewCell,
        withChecklistItem item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }

    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func itemDetailViewController(controller: ItemDetailViewController,
        didFinishAddingItem item: ChecklistItem) {
        checklist.items.append(item)
        let lastRowIndex = checklist.items.count - 1
        let indexPath = NSIndexPath(forRow: lastRowIndex, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath],
            withRowAnimation: .Automatic
        )
        dismissViewControllerAnimated(true, completion: nil)
    }

    func itemDetailViewController(controller: ItemDetailViewController,
        didFinishEditingItem item: ChecklistItem) {
        if let index = find(checklist.items, item) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                configureTextForCell(cell, withChecklistItem: item)
            }
        }
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 44
        title = checklist.name
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddItem" {
            let navigationController = segue.destinationViewController
                as! UINavigationController
            let controller = navigationController.topViewController
                as! ItemDetailViewController
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let navigationController = segue.destinationViewController
                as! UINavigationController
            let controller = navigationController.topViewController
                as! ItemDetailViewController
            controller.delegate = self
            if let indexPath = tableView.indexPathForCell(
                sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }

    override func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }

    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItem")
            as! UITableViewCell
        let item = checklist.items[indexPath.row]

        configureCheckmarkForCell(cell, withChecklistItem: item)
        configureTextForCell(cell, withChecklistItem: item)

        return cell
    }

    override func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath) {

        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            let item = checklist.items[indexPath.row]
            item.toggleChecked()
            configureCheckmarkForCell(cell, withChecklistItem: item)
        }

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    override func tableView(tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
        checklist.items.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath],
            withRowAnimation: .Automatic
        )
    }

}

