import UIKit

class AllListsViewController: UITableViewController,
    ListDetailViewControllerDelegate, UINavigationControllerDelegate {
    var dataModel: DataModel!

    func listDetailViewControllerDidCancel(controller: ListDetailViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func listDetailViewController(controller: ListDetailViewController,
        didFinishAddingList list: Checklist) {
        dataModel.lists.append(list)
        dataModel.sortChecklists()
        tableView.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
    }

    func listDetailViewController(controller: ListDetailViewController,
        didFinishEditingList list: Checklist) {
        dataModel.sortChecklists()
        tableView.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
    }

    func navigationController(controller: UINavigationController,
        willShowViewController viewController: UIViewController, animated: Bool) {
        if viewController === self {
            dataModel.indexOfSelectedChecklist = -1
        }
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
            cell = UITableViewCell(style: .Subtitle,
                reuseIdentifier: cellIdentifier
            )
        }

        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .DetailDisclosureButton
        cell.imageView!.image = UIImage(named: checklist.icon)

        let remainingCount = checklist.countUncheckedItems()
        if checklist.items.count == 0 {
            cell.detailTextLabel!.text = "No Items"
        } else if remainingCount == 0 {
            cell.detailTextLabel!.text = "All Done!"
        } else {
            cell.detailTextLabel!.text = "\(remainingCount) Remaining"
        }

        return cell
    }

    override func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath) {
        dataModel.indexOfSelectedChecklist = indexPath.row
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

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
        let targetIndex = dataModel.indexOfSelectedChecklist
        if targetIndex >= 0 && targetIndex < dataModel.lists.count {
            let checklist = dataModel.lists[targetIndex]
            performSegueWithIdentifier("ShowChecklist",
                sender: checklist
            )
        }
    }

}
