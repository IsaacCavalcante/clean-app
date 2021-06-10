import XCTest
import Presentation

class SignupPresenterTests: XCTestCase {
    func test_signup_should_show_error_message_if_name_is_not_provider() {
        let (sut, alertViewSpy) = makeSut()
        let signupViewModel = SignupViewModel(email: "any@mail.com", password: "password", passwordConfirmation: "password")
        sut.signUp(viewModel: signupViewModel)
        
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validação", message: "Nome é obrigatório"))
    }
    
    func test_signup_should_show_error_message_if_email_is_not_provider() {
        let (sut, alertViewSpy) = makeSut()
        let signupViewModel = SignupViewModel(name: "Isaac Cavalcante", password: "password", passwordConfirmation: "password")
        sut.signUp(viewModel: signupViewModel)
        
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validação", message: "Email é obrigatório"))
    }
    
    func test_signup_should_show_error_message_if_password_is_not_provider() {
        let (sut, alertViewSpy) = makeSut()
        let signupViewModel = SignupViewModel(name: "Isaac Cavalcante", email: "any@mail.com", passwordConfirmation: "password")
        sut.signUp(viewModel: signupViewModel)
        
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validação", message: "Senha é obrigatória"))
    }
    
    func test_signup_should_show_error_message_if_password_confirmation_is_not_provider() {
        let (sut, alertViewSpy) = makeSut()
        let signupViewModel = SignupViewModel(name: "Isaac Cavalcante", email: "any@mail.com", password: "password")
        sut.signUp(viewModel: signupViewModel)
        
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validação", message: "Confirmação de senha é obrigatória"))
    }
    
    func test_signup_should_show_error_message_if_password_not_macthed_with_password_confirmation() {
        let (sut, alertViewSpy) = makeSut()
        let signupViewModel = SignupViewModel(name: "Isaac Cavalcante", email: "any@mail.com", password: "password", passwordConfirmation: "wrong_password")
        sut.signUp(viewModel: signupViewModel)
        
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validação", message: "Falha ao confirmar senha"))
    }
}

extension SignupPresenterTests {
    func makeSut() -> (sut: SignupPresenter, alertViewSpy: AlertViewSpy) {
        let alertViewSpy = AlertViewSpy()
        let sut = SignupPresenter(alertView: alertViewSpy)
        
        return  (sut, alertViewSpy)
    }
    
    class AlertViewSpy: AlertView {
        var viewModel: AlertViewModel?
        
        func showMessage(viewModel: AlertViewModel) {
            self.viewModel = viewModel
        }
    }
}
