import XCTest
import Presentation
import Domain

class SigninPresenterTests: XCTestCase {
    func test_signin_should_calls_validation_with_correct_values() {
        let test = makeSut()
        let sut = test.sut
        let validation = test.validationSpy
        let viewModel = makeSigninViewModel()
        sut.signIn(viewModel: viewModel)
        XCTAssertTrue(NSDictionary(dictionary: validation.data!).isEqual(to: viewModel.toJson()!))
    }
    
    func test_signin_should_show_error_message_if_validation_fails() {
        let test = makeSut()
        let sut = test.sut
        let alertViewSpy = test.alertViewSpy
        let validationSpy = test.validationSpy
        
        let exp = expectation(description: "completion to add remote account should response until 1 second")
        alertViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, makeAlertViewModel(message: "Erro"))
            exp.fulfill()
        }
        validationSpy.simulateError()
        sut.signIn(viewModel: makeSigninViewModel())
        wait(for: [exp], timeout: 1)
    }
}


extension SigninPresenterTests {
    func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (sut: SigninPresenter, alertViewSpy: AlertViewSpy, validationSpy: ValidationSpy) {
        let validationSpy = ValidationSpy()
        let alertViewSpy = AlertViewSpy()
        let sut = SigninPresenter(validation: validationSpy, alertView: alertViewSpy)
        checkMemoryLeak(for: sut, file: file, line: line)
        
        return (sut, alertViewSpy, validationSpy)
    }
}
