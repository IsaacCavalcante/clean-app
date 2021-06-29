public final class WelcomeRouter {
    private let nav: NavigationController
    private let signinFactory: () -> SigninViewController
    private let signupFactory: () -> SignupViewController
    
    public init(nav: NavigationController, signinFactory: @escaping () -> SigninViewController, signupFactory: @escaping () -> SignupViewController) {
        self.nav = nav
        self.signinFactory = signinFactory
        self.signupFactory = signupFactory
    }
    
    public func gotoSignin() {
        nav.pushViewController(signinFactory())
    }
    
    public func gotoSignup() {
        nav.pushViewController(signupFactory())
    }
}
