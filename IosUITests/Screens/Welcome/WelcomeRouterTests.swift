import XCTest
import UIKit
import IosUI
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

class WelcomeRouterTests: XCTestCase {
    
    func test_gotoSignin_calls_nav_with_correctvc() {
        let (sut, nav) = makeSut()
        
        sut.gotoSignin()
        
        XCTAssertEqual(nav.viewControllers.count, 1)
        XCTAssertTrue(nav.viewControllers.first is SigninViewController)
    }
    
    func test_gotoSignup_calls_nav_with_correctvc() {
        let (sut, nav) = makeSut()
        
        sut.gotoSignup()
        
        XCTAssertEqual(nav.viewControllers.count, 1)
        XCTAssertTrue(nav.viewControllers.first is SignupViewController)
    }
}

extension WelcomeRouterTests {
    func makeSut() -> (sut: WelcomeRouter, nav: NavigationController) {
        let signinFactorySpy = SigninFactorySpy()
        let signupFactorySpy = SignupFactorySpy()
        let nav = NavigationController()
        let sut = WelcomeRouter(nav: nav, signinFactory: signinFactorySpy.makeSignin, signupFactory: signupFactorySpy.makeSignup)
        
        return (sut: sut, nav: nav)
    }
}

extension WelcomeRouterTests {
    class SigninFactorySpy {
        func makeSignin() -> SigninViewController {
            return SigninViewController.instantiate()
        }
    }
    
    class SignupFactorySpy {
        func makeSignup() -> SignupViewController {
            return SignupViewController.instantiate()
        }
    }
}
