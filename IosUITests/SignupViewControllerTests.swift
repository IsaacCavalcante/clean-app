import XCTest
import UIKit
@testable import IosUI

class SignupViewControllerTests: XCTestCase {
    func test_() {
        let sb = UIStoryboard(name: "SignupStoryboard", bundle: Bundle(for: SignupViewController.self))
        let sut = sb.instantiateViewController(identifier: "SignupViewController") as! SignupViewController
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.loadingIndicator?.isAnimating, false)
    }
}
