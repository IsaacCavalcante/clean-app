import XCTest
import Main
import Data
import Presentation
import Domain
import IosUI
import Validation

class SignupControllerFactoryTests: XCTestCase {
    func test_background_request_should_complete_on_main_thread() {
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
    
    func test_signup_compose_with_correct_validators() {
        let validations = makeSignupValidations()
        XCTAssertEqual(validations[0] as! RequiredFieldsValidation, RequiredFieldsValidation(fieldName: "name", fieldLabel: "Nome"))
        XCTAssertEqual(validations[1] as! RequiredFieldsValidation, RequiredFieldsValidation(fieldName: "email", fieldLabel: "Email"))
        
        XCTAssertEqual(validations[2] as! EmailValidation, EmailValidation(fieldName: "email", fieldLabel: "Email", emailValidator: EmailValidatorSpy()))
        
        XCTAssertEqual(validations[3] as! RequiredFieldsValidation, RequiredFieldsValidation(fieldName: "password", fieldLabel: "Senha"))
        XCTAssertEqual(validations[4] as! RequiredFieldsValidation, RequiredFieldsValidation(fieldName: "passwordConfirmation", fieldLabel: "Confirmar Senha"))
        
        XCTAssertEqual(validations[5] as! CompareFieldsValidation, CompareFieldsValidation(fieldName: "password", fieldNameToCompare: "passwordConfirmation", fieldLabel: "Confirmar Senha"))
        
        
    }
}

extension SignupControllerFactoryTests {
    func makeSut(file: StaticString = #file, line: UInt = #line) -> (sut: SignupViewController, addAccountSpy: AddAccountSpy) {
        let addAccountSpy = AddAccountSpy()
        let sut = makeSignupController(addAccount: MainQueueDispatchDecorator(addAccountSpy))
        checkMemoryLeak(for: sut, file: file, line: line)
        checkMemoryLeak(for: addAccountSpy, file: file, line: line)
        return (sut, addAccountSpy)
    }
}
