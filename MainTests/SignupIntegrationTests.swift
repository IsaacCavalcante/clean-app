import XCTest
import Main
import Data

class SignupIntegrationTests: XCTestCase {
    func test_ui_presentantion_integration() {
        debugPrint("===============================")
        debugPrint(Enviroment.variable(.apiBaseUrl))
        debugPrint("===============================")
        let sut = SignupComposer.composeControllerWith(addAccount: AddAccountSpy())
        checkMemoryLeak(for: sut)
    }
}
