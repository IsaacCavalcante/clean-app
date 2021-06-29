import UIKit
import IosUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    private let signupFactory: () -> SignupViewController = {
        let httpClient = makeAlamofireAdapter()
        let remoteAddAccount = makeRemoteAddAccount(httpClient: httpClient)
        return makeSignupController(addAccount: remoteAddAccount)
    }
    
    private let signinFactory: () -> SigninViewController = {
        let httpClient = makeAlamofireAdapter()
        let remoteAuthentication = makeRemoteAuthentication(httpClient: httpClient)
        return makeSigninController(authentication: remoteAuthentication)
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let nav = NavigationController()
        let welcomeRouter = WelcomeRouter(nav: nav, signinFactory: signinFactory, signupFactory: signupFactory)
        let welcomeViewController = WelcomeViewController.instantiate()
        welcomeViewController.signUp = welcomeRouter.gotoSignup
        welcomeViewController.signIn = welcomeRouter.gotoSignin
        
        
        nav.setRootViewController(welcomeViewController)
        
        window?.rootViewController = nav
        
        window?.makeKeyAndVisible()
    }
}

