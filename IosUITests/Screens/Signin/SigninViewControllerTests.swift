import XCTest
import UIKit
import Presentation
@testable import IosUI

class SigninViewControllerTests: XCTestCase {
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
    
    func test_sut_signin_button_calls_sigin_on_tap() {
        var signinViewModel: SigninViewModel?
        let sut = makeSut(signinModel: { signinViewModel = $0 })
        sut.loadViewIfNeeded()
        sut.signinButton?.simulateTap()
        let email = sut.emailTextField?.text
        let password = sut.passwordTextField?.text
        XCTAssertEqual(signinViewModel, SigninViewModel(email: email, password: password))
    }
}

extension SigninViewControllerTests {
    func makeSut(signinModel: ((SigninViewModel) -> Void)? = nil) -> SigninViewController {
        let sut = SigninViewController.instantiate()
        sut.signIn = signinModel
        sut.loadViewIfNeeded()
        checkMemoryLeak(for: sut)
        return sut
    }
}
