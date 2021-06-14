import XCTest
import UIKit
import Presentation
@testable import IosUI

class SignupViewControllerTests: XCTestCase {
    func test_loading_is_hidden_on_start() {
        let sb = UIStoryboard(name: "SignupStoryboard", bundle: Bundle(for: SignupViewController.self))
        let sut = sb.instantiateViewController(identifier: "SignupViewController") as! SignupViewController
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.loadingIndicator?.isAnimating, false)
    }
    
    func test_sut_implements_loadingview_protocol() {
        let sb = UIStoryboard(name: "SignupStoryboard", bundle: Bundle(for: SignupViewController.self))
        let sut = sb.instantiateViewController(identifier: "SignupViewController") as! SignupViewController
        XCTAssertNotNil(sut as LoadingView)
    }
    
    func test_sut_implements_alertview_protocol() {
        let sb = UIStoryboard(name: "SignupStoryboard", bundle: Bundle(for: SignupViewController.self))
        let sut = sb.instantiateViewController(identifier: "SignupViewController") as! SignupViewController
        XCTAssertNotNil(sut as AlertView)
    }
}
