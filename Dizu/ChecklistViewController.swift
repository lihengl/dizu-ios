import UIKit

class ChecklistViewController: UITableViewController,
    AddItemViewControllerDelegate {
    var errorMessage = "UNEXPECTED ROW"
    var items: [ChecklistItem]

    required init(coder aDecoder: NSCoder) {
        items = [ChecklistItem]()

        let row0item = ChecklistItem()
        row0item.checked = false
        row0item.text = "Walk the Dog"
        items.append(row0item)

        let row1item = ChecklistItem()
        row1item.checked = true
        row1item.text = "Bite the Bullet"
        items.append(row1item)

        let row2item = ChecklistItem()
        row2item.checked = true
        row2item.text = "Hit the Sack"
        items.append(row2item)

        let row3item = ChecklistItem()
        row3item.checked = false
        row3item.text = "Read the Manual"
        items.append(row3item)

        let row4item = ChecklistItem()
        row4item.checked = true
        row4item.text = "Right the Hell Now"
        items.append(row4item)

        let row5item = ChecklistItem()
        row5item.checked = false
        row5item.text = "Rock and Roll"
        items.append(row5item)

        super.init(coder: aDecoder)
    }

    func configureCheckmarkForCell(cell: UITableViewCell,
        withChecklistItem item: ChecklistItem) {
        cell.accessoryType = item.checked ? .Checkmark : .None
    }

    func configureTextForCell(cell: UITableViewCell,
        withChecklistItem item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }

    func addItemViewControllerDidCancel(controller: AddItemViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func addItemViewController(controller: AddItemViewController,
        didFinishAddingItem item: ChecklistItem) {
        items.append(item)
        let indexPath = NSIndexPath(forRow: (items.count - 1), inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath],
            withRowAnimation: .Automatic
        )
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddItem" {
            let navigationController = segue.destinationViewController
                as! UINavigationController
            let controller = navigationController.topViewController
                as! AddItemViewController
            controller.delegate = self
        }
    }

    override func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItem")
            as! UITableViewCell
        let item = items[indexPath.row]

        configureCheckmarkForCell(cell, withChecklistItem: item)
        configureTextForCell(cell, withChecklistItem: item)

        return cell
    }

    override func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath) {

        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            let item = items[indexPath.row]
            item.toggleChecked()
            configureCheckmarkForCell(cell, withChecklistItem: item)
        }

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    override func tableView(tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
        items.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath],
            withRowAnimation: .Automatic
        )
    }

}

