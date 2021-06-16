import XCTest
import Main
import Data
import IosUI

class SignupComposerTests: XCTestCase {
    func test_backgorund_request_should_complete_on_main_thread() {
//        debugPrint("===============================")
//        debugPrint(Environment.variable(.apiBaseUrl))
//        debugPrint("===============================")
        let (sut, _) = makeSut()
        sut.loadViewIfNeeded()
        
    }
}

extension SignupComposerTests {
    func makeSut(file: StaticString = #file, line: UInt = #line) -> (sut: SignupViewController, addAccountSpy: AddAccountSpy) {
        let addAccountSpy = AddAccountSpy()
        let sut = SignupComposer.composeControllerWith(addAccount: addAccountSpy)
        checkMemoryLeak(for: sut, file: file, line: line)
        checkMemoryLeak(for: addAccountSpy, file: file, line: line)
        return (sut, addAccountSpy)
    }
}
