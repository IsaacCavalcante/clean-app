import XCTest
import Validation

class RequiredFieldsValidationTests: XCTestCase {

    func test_validate_should_return_error_if_field_is_not_provided() {
        let sut = makeSut(fieldName: "email", fieldLabel: "Email")
        
        let errorMessage = sut.validate(data: ["name": "Isaac"])
        XCTAssertEqual(errorMessage, "O campo Email é obrigatório")
    }
    
    func test_validate_should_return_error_with_correct_field_Label() {
        let sut = makeSut(fieldName: "password", fieldLabel: "Senha")
        
        let errorMessage = sut.validate(data: ["name": "Isaac"])
        XCTAssertEqual(errorMessage, "O campo Senha é obrigatório")
    }
    
    func test_validate_should_return_nil_if_field_is_provided() {
        let sut = makeSut(fieldName: "email", fieldLabel: "Email")
        
        let errorMessage = sut.validate(data: ["email": "isaac@mail.com"])
        XCTAssertNil(errorMessage)
    }
    
    func test_validate_should_return_error_if_no_data_is_provided() {
        let sut = makeSut(fieldName: "email", fieldLabel: "Email")
        
        let errorMessage = sut.validate(data: nil)
        XCTAssertEqual(errorMessage, "O campo Email é obrigatório")
    }
    
    func test_validate_should_return_error_if_value_of_field_is_empty() {
        let sut = makeSut(fieldName: "name", fieldLabel: "Nome")
        
        let errorMessage = sut.validate(data: ["name": ""])
        XCTAssertEqual(errorMessage, "O campo Nome é obrigatório")
    }
}

extension RequiredFieldsValidationTests {
    func makeSut(fieldName: String, fieldLabel: String, file: StaticString = #filePath, line: UInt = #line) -> RequiredFieldsValidation {
        let sut =  RequiredFieldsValidation(fieldName: fieldName, fieldLabel: fieldLabel)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
}
