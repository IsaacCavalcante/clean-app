import XCTest
import Presentation

public final class EmailValidatorAdapter: EmailValidator {
    private let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    public func isValid(email: String) -> Bool {
        let range = NSRange(location: 0, length: email.utf16.count)
        let regex = try! NSRegularExpression(pattern: pattern)
        return regex.firstMatch(in: email, options: [], range: range) != nil
    }
    
    
}

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
