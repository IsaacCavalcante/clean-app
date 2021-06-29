import XCTest
import UIKit
import Presentation
@testable import IosUI

class WelcomeViewControllerTests: XCTestCase {
    
    func test_sut_signin_button_calls_sigin_on_tap() {
        let (sut, buttonSpy) = makeSut()
        sut.loadViewIfNeeded()
        sut.signinButton?.simulateTap()
        
        XCTAssertEqual(buttonSpy.clicks, 1)
    }
}

extension WelcomeViewControllerTests {
    func makeSut() -> (sut: WelcomeViewController, buttonSpy: ButtonSpy) {
        let buttonSpy = ButtonSpy()
        let sut = WelcomeViewController.instantiate()
        sut.signIn = buttonSpy.onClicks
        
        return (sut, buttonSpy)
    }
    
    class ButtonSpy {
        var clicks = 0
        func onClicks() {
            clicks += 1
        }
    }
}
