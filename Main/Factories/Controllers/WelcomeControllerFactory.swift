import IosUI

public func makeWelcomeController(nav: NavigationController) -> WelcomeViewController {
    let welcomeRouter = WelcomeRouter(nav: nav, signinFactory: makeSigninController, signupFactory: makeSignupController)
    let welcomeViewController = WelcomeViewController.instantiate()
    welcomeViewController.signUp = welcomeRouter.gotoSignup
    welcomeViewController.signIn = welcomeRouter.gotoSignin
    
    return welcomeViewController
}
