import XCTest
import Main
import Data
import Presentation
import Domain
import IosUI

class SignupComposerTests: XCTestCase {
    func test_backgorund_request_should_complete_on_main_thread() {
//        debugPrint("===============================")
//        debugPrint(Environment.variable(.apiBaseUrl))
//        debugPrint("===============================")
        let (sut, addAccountSpy) = makeSut()
        sut.loadViewIfNeeded()
        sut.signUp?(makeSignupViewModel())
        
        let exp = expectation(description: "Should response until 1 seconds")
        DispatchQueue.global().async {
            addAccountSpy.completeWithError(.unexpected)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
}

extension SignupComposerTests {
    func makeSut(file: StaticString = #file, line: UInt = #line) -> (sut: SignupViewController, addAccountSpy: AddAccountSpy) {
        let addAccountSpy = AddAccountSpy()
        let sut = SignupComposer.composeControllerWith(addAccount: MainQueueDispatchDecorator(addAccountSpy))
        checkMemoryLeak(for: sut, file: file, line: line)
        checkMemoryLeak(for: addAccountSpy, file: file, line: line)
        return (sut, addAccountSpy)
    }
}
