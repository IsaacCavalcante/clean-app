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
}

extension SigninViewControllerTests {
    func makeSut() -> SigninViewController {
        let sut = SigninViewController.instantiate()
        sut.loadViewIfNeeded()
        
        return sut
    }
}
