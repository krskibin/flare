import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions
                     launchOptions: [UIApplicationLaunchOptionsKey: Any]? ) -> Bool {
        
        let isRegistered = UserDefaults.standard.bool(forKey: "FIRST_TIME")
        
        if isRegistered == false {
            let onboardingViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OnboardNavVC") as! OnboardingViewController
            self.window?.rootViewController = onboardingViewController
            self.window?.makeKeyAndVisible()
            
        } else {
            let firstViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstNavVC") as! UINavigationController
            self.window?.rootViewController = firstViewController
            self.window?.makeKeyAndVisible()
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

}
