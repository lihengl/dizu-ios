import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let dataModel = DataModel()

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

    func application(application: UIApplication,
        didReceiveLocalNotification notification: UILocalNotification) {
        println("Did received: \(notification)")
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
        dataModel.saveChecklists()
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
        dataModel.saveChecklists()
    }

}

