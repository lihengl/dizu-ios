import UIKit

class ChecklistViewController: UITableViewController {
    var errorMessage = "UNEXPECTED ROW"
    var items: [ChecklistItem]

    required init(coder aDecoder: NSCoder) {
        items = [ChecklistItem]()

        let row0item = ChecklistItem()
        row0item.checked = false
        row0item.text = "Walk the Dog"
        items.append(row0item)

        let row1item = ChecklistItem()
        row1item.checked = false
        row1item.text = "Bite the Bullet"
        items.append(row1item)

        let row2item = ChecklistItem()
        row2item.checked = false
        row2item.text = "Hit the Sack"
        items.append(row2item)

        let row3item = ChecklistItem()
        row3item.checked = false
        row3item.text = "Read the Manual"
        items.append(row3item)

        let row4item = ChecklistItem()
        row4item.checked = false
        row4item.text = "Right the Hell Now"
        items.append(row4item)

        let row5item = ChecklistItem()
        row5item.checked = false
        row5item.text = "Rock and Roll"
        items.append(row5item)

        super.init(coder: aDecoder)
    }

    override func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func configureCheckmarkForCell(cell: UITableViewCell,
        withChecklistItem item: ChecklistItem) {
        if item.checked {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
    }

    func configureTextForCell(cell: UITableViewCell,
        withChecklistItem item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
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
}

