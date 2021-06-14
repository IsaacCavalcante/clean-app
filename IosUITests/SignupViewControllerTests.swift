import XCTest
import UIKit
import Presentation
@testable import IosUI

class SignupViewControllerTests: XCTestCase {
    func test_loading_is_hidden_on_start() {
        let sut = makeSut()
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.loadingIndicator?.isAnimating, false)
    }
    
    func test_sut_implements_loadingview_protocol() {
        let sut = makeSut()
        XCTAssertNotNil(sut as LoadingView)
    }
    
    func test_sut_implements_alertview_protocol() {
        let sut = makeSut()
        XCTAssertNotNil(sut as AlertView)
    }
    
    func test_sut_save_button_calls_signup_on_tap() {
        var callsCaount = 0
        let sut = makeSut(signupModel: { _ in
            callsCaount += 1
        })
        sut.loadViewIfNeeded()
        sut.signupButton?.simulateTap()
        XCTAssertEqual(callsCaount, 1)
    }
}

extension SignupViewControllerTests {
    func makeSut(signupModel: ((SignupViewModel) -> Void)? = nil) -> SignupViewController {
        let sb = UIStoryboard(name: "SignupStoryboard", bundle: Bundle(for: SignupViewController.self))
        let sut = sb.instantiateViewController(identifier: "SignupViewController") as! SignupViewController
        sut.signUp = signupModel
        
        return sut
    }
}

extension UIControl {
    func simulate(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach { action in
                (target as NSObject).perform(Selector(action))
            }
        }
    }
    
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}
