import XCTest
import Presentation

class SignupPresenterTests: XCTestCase {
    func test_signup_should_show_error_message_if_name_is_not_provider() {
        let test = makeSut()
        let sut = test.sut
        let alertViewSpy = test.alertViewSpy
        let signupViewModel = SignupViewModel(email: "any@mail.com", password: "password", passwordConfirmation: "password")
        sut.signUp(viewModel: signupViewModel)
        
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validação", message: "Nome é obrigatório"))
    }
    
    func test_signup_should_show_error_message_if_email_is_not_provider() {
        let test = makeSut()
        let sut = test.sut
        let alertViewSpy = test.alertViewSpy
        
        let signupViewModel = SignupViewModel(name: "Isaac Cavalcante", password: "password", passwordConfirmation: "password")
        sut.signUp(viewModel: signupViewModel)
        
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validação", message: "Email é obrigatório"))
    }
    
    func test_signup_should_show_error_message_if_password_is_not_provider() {
        let test = makeSut()
        let sut = test.sut
        let alertViewSpy = test.alertViewSpy
        
        let signupViewModel = SignupViewModel(name: "Isaac Cavalcante", email: "any@mail.com", passwordConfirmation: "password")
        sut.signUp(viewModel: signupViewModel)
        
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validação", message: "Senha é obrigatória"))
    }
    
    func test_signup_should_show_error_message_if_password_confirmation_is_not_provider() {
        let test = makeSut()
        let sut = test.sut
        let alertViewSpy = test.alertViewSpy
        
        let signupViewModel = SignupViewModel(name: "Isaac Cavalcante", email: "any@mail.com", password: "password")
        sut.signUp(viewModel: signupViewModel)
        
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validação", message: "Confirmação de senha é obrigatória"))
    }
    
    func test_signup_should_show_error_message_if_password_not_macthed_with_password_confirmation() {
        let test = makeSut()
        let sut = test.sut
        let alertViewSpy = test.alertViewSpy
        
        let signupViewModel = SignupViewModel(name: "Isaac Cavalcante", email: "any@mail.com", password: "password", passwordConfirmation: "wrong_password")
        sut.signUp(viewModel: signupViewModel)
        
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validação", message: "Falha ao confirmar senha"))
    }
    
    func test_signup_should_call_email_validator_with_correct_email() {
        let test = makeSut()
        let sut = test.sut
        let emailValidator = test.emailValidatorSpy
        
        let signupViewModel = SignupViewModel(name: "Isaac Cavalcante", email: "any@mail.com", password: "password", passwordConfirmation: "password")
        sut.signUp(viewModel: signupViewModel)
        
        XCTAssertEqual(emailValidator.email, signupViewModel.email)
    }
}

extension SignupPresenterTests {
    func makeSut() -> (sut: SignupPresenter, alertViewSpy: AlertViewSpy, emailValidatorSpy: EmailValidatorSpy) {
        let alertViewSpy = AlertViewSpy()
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = SignupPresenter(alertView: alertViewSpy, emailValidator: emailValidatorSpy)
        
        return (sut, alertViewSpy, emailValidatorSpy)
    }
    
    class AlertViewSpy: AlertView {
        var viewModel: AlertViewModel?
        
        func showMessage(viewModel: AlertViewModel) {
            self.viewModel = viewModel
        }
    }
    
    class EmailValidatorSpy: EmailValidator {
        var email: String?
        let isValid = true
        func isValid(email: String) -> Bool {
            self.email = email
            return isValid
        }
    }
}
