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
}

extension SigninViewControllerTests {
    func makeSut() -> SigninViewController {
        let sut = SigninViewController.instantiate()
        sut.loadViewIfNeeded()
        
        return sut
    }
}
