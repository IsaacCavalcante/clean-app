import XCTest
import Validation

class EmailValidationTests: XCTestCase {

    func test_validate_should_return_error_if_invalid_email_is_provided() {
        let test = makeSut(fieldName: "email", fieldLabel: "Email")
        let emailValidatorSpy = test.emailValidatorSpy
        let sut = test.sut
        
        emailValidatorSpy.simulateEmailValidation(to: false)
        let errorMessage = sut.validate(data: ["email": "invalidemail@mail.com"])
        XCTAssertEqual(errorMessage, "O campo Email é inválido")
    }
    
    func test_validate_should_return_error_with_correct_field_label() {
        let test = makeSut(fieldName: "email", fieldLabel: "Email")
        let emailValidatorSpy = test.emailValidatorSpy
        let sut = test.sut
        
        emailValidatorSpy.simulateEmailValidation(to: false)
        let errorMessage = sut.validate(data: ["email": "invalidemail@mail.com"])
        XCTAssertEqual(errorMessage, "O campo Email é inválido")
    }
    
    func test_validate_should_return_nil_if_valid_email_is_provided() {
        let test = makeSut(fieldName: "email", fieldLabel: "Email")
        let emailValidatorSpy = test.emailValidatorSpy
        let sut = test.sut
        
        emailValidatorSpy.simulateEmailValidation(to: true)
        let errorMessage = sut.validate(data: ["email": "validemail@mail.com"])
        XCTAssertNil(errorMessage)
    }
    
    func test_validate_should_return_nil_if_no_data_is_provided() {
        let test = makeSut(fieldName: "email", fieldLabel: "Email")
        let sut = test.sut
        
        let errorMessage = sut.validate(data: nil)
        XCTAssertEqual(errorMessage, "O campo Email é inválido")
    }
}

extension EmailValidationTests {
    func makeSut(fieldName: String, fieldLabel: String, emailValidator: EmailValidatorSpy = EmailValidatorSpy(), file: StaticString = #filePath, line: UInt = #line) -> (sut: EmailValidation, emailValidatorSpy: EmailValidatorSpy) {
        let sut =  EmailValidation(fieldName: fieldName, fieldLabel: fieldLabel, emailValidator: emailValidator)
        checkMemoryLeak(for: sut, file: file, line: line)
        return (sut: sut, emailValidatorSpy: emailValidator)
    }
}
