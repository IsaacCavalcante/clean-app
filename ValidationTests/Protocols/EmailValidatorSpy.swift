import Foundation
import Validation

class EmailValidatorSpy: EmailValidator {
    var email: String?
    var isValid = true
    func isValid(email: String) -> Bool {
        self.email = email
        return isValid
    }
    
    func simulateEmailValidation(to isValid: Bool) {
        self.isValid = isValid
    }
}
