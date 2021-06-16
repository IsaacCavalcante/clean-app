import XCTest
import Main
import Data

class SignupComposerTests: XCTestCase {
    func test_ui_presentantion_integration() {
//        debugPrint("===============================")
//        debugPrint(Environment.variable(.apiBaseUrl))
//        debugPrint("===============================")
        let sut = SignupComposer.composeControllerWith(addAccount: AddAccountSpy())
        checkMemoryLeak(for: sut)
    }
}
