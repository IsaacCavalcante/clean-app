import XCTest
import UIKit
import Presentation
@testable import IosUI

class WelcomeViewControllerTests: XCTestCase {
    
    func test_sut_signin_button_calls_sigin_on_tap() {
        let sut = makeSut()
        let buttonSignInSpy = ButtonSpy()
        sut.signIn = buttonSignInSpy.onClicks
        
        sut.signinButton?.simulateTap()
        
        XCTAssertEqual(buttonSignInSpy.clicks, 1)
    }
    
    func test_sut_signuo_button_calls_sigup_on_tap() {
        let sut = makeSut()
        
        let buttonSignUpSpy = ButtonSpy()
        sut.signUp = buttonSignUpSpy.onClicks
        
        sut.signupButton?.simulateTap()
        
        XCTAssertEqual(buttonSignUpSpy.clicks, 1)
    }
}

extension WelcomeViewControllerTests {
    func makeSut() -> WelcomeViewController {
        let sut = WelcomeViewController.instantiate()
        sut.loadViewIfNeeded()
        return sut
    }
    
    class ButtonSpy {
        var clicks = 0
        func onClicks() {
            clicks += 1
        }
    }
}
