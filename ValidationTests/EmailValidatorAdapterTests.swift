import XCTest
import Presentation

class EmailValidatorAdapterTests: XCTestCase {
    func test_invalid_emails() throws {
        let sut = makeSut()
        XCTAssertFalse(sut.isValid(email: "not_valid"))
        XCTAssertFalse(sut.isValid(email: "not_valid@"))
        XCTAssertFalse(sut.isValid(email: "not_valid@mail"))
        XCTAssertFalse(sut.isValid(email: "not_valid@mail."))
        XCTAssertFalse(sut.isValid(email: "@not_valid."))
        XCTAssertFalse(sut.isValid(email: "@mail.com"))
    }
    
    func test_valid_emails() throws {
        let sut = makeSut()
        XCTAssertTrue(sut.isValid(email: "isaac@gmail.com"))
        XCTAssertTrue(sut.isValid(email: "isaaccavalcante@monitoratec.com.br"))
        XCTAssertTrue(sut.isValid(email: "cavalcante.isaac1@gmail.com"))
        XCTAssertTrue(sut.isValid(email: "isaac.cavalcante@ymail.com"))
        XCTAssertTrue(sut.isValid(email: "thiago.wase@hotmail.com"))
    }
}

extension EmailValidatorAdapterTests {
    func makeSut() -> EmailValidator {
        let sut = EmailValidatorAdapter()
        return sut
    }
}
