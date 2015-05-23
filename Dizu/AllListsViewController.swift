import UIKit

class AllListsViewController: UITableViewController,
    ListDetailViewControllerDelegate {
    var dataModel: DataModel!

    func listDetailViewControllerDidCancel(controller: ListDetailViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func listDetailViewController(controller: ListDetailViewController,
        didFinishAddingList list: Checklist) {
        dataModel.lists.append(list)
        let lastRowIndex = dataModel.lists.count - 1
        let indexPath = NSIndexPath(forRow: lastRowIndex, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath],
            withRowAnimation: .Automatic
        )
        dismissViewControllerAnimated(true, completion: nil)
    }

    func listDetailViewController(controller: ListDetailViewController,
        didFinishEditingList list: Checklist) {
        if let index = find(dataModel.lists, list) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                cell.textLabel!.text = list.name
            }
        }
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func tableView(tableView: UITableView,
        accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let navigationController = storyboard!
            .instantiateViewControllerWithIdentifier("ListNavigationController")
            as! UINavigationController
        let controller = navigationController.topViewController
            as! ListDetailViewController
        controller.delegate = self
        controller.listToEdit = dataModel.lists[indexPath.row]
        presentViewController(navigationController,
            animated: true, completion: nil
        )
    }

    override func tableView(tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
        dataModel.lists.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath],
            withRowAnimation: .Automatic
        )
    }

    override func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }

    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        var cell: UITableViewCell! = tableView
        .dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell

        if cell == nil {
            cell = UITableViewCell(style: .Default,
                reuseIdentifier: cellIdentifier
            )
        }

        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .DetailDisclosureButton

        return cell
    }

    override func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ShowChecklist",
            sender: dataModel.lists[indexPath.row]
        )
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destinationViewController
                as! ChecklistViewController
            controller.checklist = sender as! Checklist
        } else if segue.identifier == "AddChecklist" {
            let navigationController = segue.destinationViewController
                as! UINavigationController
            let controller = navigationController.topViewController
                as! ListDetailViewController
            controller.delegate = self
            controller.listToEdit = nil
        }
    }

}
