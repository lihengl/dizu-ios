import Foundation

class ChecklistItem {
    var checked = false
    var text = ""

    func toggleChecked() {
        checked = !checked
    }
}
