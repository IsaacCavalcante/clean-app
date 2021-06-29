import XCTest
import Main
import Data
import Presentation
import Domain
import IosUI
import Validation

class SigninControllerFactoryTests: XCTestCase {
    func test_background_request_should_complete_on_main_thread() {
//        debugPrint("===============================")
//        debugPrint(Environment.variable(.apiBaseUrl))
//        debugPrint("===============================")
        let (sut, authenticationSpy) = makeSut()
        sut.loadViewIfNeeded()
        sut.signIn?(makeSigninViewModel())
        
        let exp = expectation(description: "Should response until 1 seconds")
        DispatchQueue.global().async {
            authenticationSpy.completeWithError(.unexpected)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_signup_compose_with_correct_validators() {
        let validations = makeSigninValidations()
        
        XCTAssertEqual(validations[0] as! RequiredFieldsValidation, RequiredFieldsValidation(fieldName: "email", fieldLabel: "Email"))
        
        XCTAssertEqual(validations[1] as! EmailValidation, EmailValidation(fieldName: "email", fieldLabel: "Email", emailValidator: EmailValidatorSpy()))
        
        XCTAssertEqual(validations[2] as! RequiredFieldsValidation, RequiredFieldsValidation(fieldName: "password", fieldLabel: "Senha"))
        
    }
}

extension SigninControllerFactoryTests {
    func makeSut(file: StaticString = #file, line: UInt = #line) -> (sut: SigninViewController, authenticationSpy: AuthenticationSpy) {
        let authenticationSpy = AuthenticationSpy()
        let sut = makeSigninControllerWith(authentication: MainQueueDispatchDecorator(authenticationSpy))
        checkMemoryLeak(for: sut, file: file, line: line)
        checkMemoryLeak(for: authenticationSpy, file: file, line: line)
        return (sut, authenticationSpy)
    }
}
