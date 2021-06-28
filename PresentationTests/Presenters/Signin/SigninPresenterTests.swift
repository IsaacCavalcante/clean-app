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
}


extension SigninPresenterTests {
    func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (sut: SigninPresenter, validationSpy: ValidationSpy) {
        let validationSpy = ValidationSpy()
        let sut = SigninPresenter(validation: validationSpy)
        checkMemoryLeak(for: sut, file: file, line: line)
        
        return (sut, validationSpy)
    }
}
