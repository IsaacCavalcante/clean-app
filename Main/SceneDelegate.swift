import UIKit
import IosUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let httpClient = makeAlamofireAdapter()
        let addAccount = makeRemoteAddAccount(httpClient: httpClient)
        let signupViewController = makeSignupController(addAccount: addAccount)
        
        let nav = NavigationController(rootViewController: signupViewController)
        
        window?.rootViewController = nav
        
        window?.makeKeyAndVisible()
    }
}

