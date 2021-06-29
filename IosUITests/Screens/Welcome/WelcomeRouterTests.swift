import XCTest
import UIKit
import IosUI
public final class WelcomeRouter {
    private let nav: NavigationController
    private let signinFactory: () -> SigninViewController
    
    public init(nav: NavigationController, signinFactory: @escaping () -> SigninViewController) {
        self.nav = nav
        self.signinFactory = signinFactory
    }
    
    public func gotoSignin() {
        nav.pushViewController(signinFactory())
    }
}

class WelcomeRouterTests: XCTestCase {
    
    func test_gotoSignin_calls_nav_with_correctvc() {
        let signinFactorySpy = SigninFactorySpy()
        let nav = NavigationController()
        let sut = WelcomeRouter(nav: nav, signinFactory: signinFactorySpy.makeLogin)
        
        sut.gotoSignin()
        
        XCTAssertEqual(nav.viewControllers.count, 1)
        XCTAssertTrue(nav.viewControllers.first is SigninViewController)
    }
    
    class SigninFactorySpy {
        func makeLogin() -> SigninViewController {
            return SigninViewController.instantiate()
        }
    }
}
