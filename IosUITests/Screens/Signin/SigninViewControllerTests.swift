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
    
    func test_sut_should_animate_display_when_display_method_is_called() {
        let loadViewModel = LoadingViewModel(isLoading: true)
        let sut = makeSut()
        sut.loadViewIfNeeded()
        sut.display(viewModel: loadViewModel)
        XCTAssertEqual(loadViewModel.isLoading, sut.loadingIndicator.isAnimating)
    }
    
    func test_sut_should_stop_animating_display_when_display_method_is_called() {
        let loadViewModel = LoadingViewModel(isLoading: false)
        let sut = makeSut()
        sut.loadViewIfNeeded()
        sut.display(viewModel: loadViewModel)
        XCTAssertEqual(loadViewModel.isLoading, sut.loadingIndicator.isAnimating)
    }
    
    func test_sut_should_show_alert_when_show_alert_method_is_called() {
        let alertViewModel = AlertViewModel(title: "title", message: "message")
        let sut = makeSut()
        let nav = UINavigationController.init(rootViewController: sut)
        sut.loadViewIfNeeded()
        sut.showMessage(viewModel: alertViewModel)
        
        let exp = expectation(description: "Test after 1 second wait")
        let result = XCTWaiter.wait(for: [exp], timeout: 1)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertNotNil(nav.visibleViewController is UIAlertController)
        } else {
            XCTFail("Delay interrupted")
        }
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
