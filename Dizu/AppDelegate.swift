import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let dataModel = DataModel()
    var window: UIWindow?

    func application(application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?
    ) -> Bool {
        let navigationController = window!.rootViewController
        as! UINavigationController
        let mainController = navigationController.viewControllers[0]
        as! AllListsViewController

        mainController.dataModel = dataModel

        return true
    }

    func applicationDidEnterBackground(application: UIApplication) {
        dataModel.saveChecklists()
    }

    func applicationWillTerminate(application: UIApplication) {
        dataModel.saveChecklists()
    }

}

