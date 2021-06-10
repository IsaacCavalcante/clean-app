import XCTest

class SignupPresenter {
    private let alertView: AlertView?
    
    init(alertView: AlertView) {
        self.alertView = alertView
    }
    
    func signUp(viewModel: SignupViewModel) {
        if (viewModel.name == nil || viewModel.name!.isEmpty) {
            alertView?.showMessage(viewModel: AlertViewModel(title: "Falha na validação", message: "Nome é obrigatório"))
        } else if (viewModel.email == nil || viewModel.email!.isEmpty) {
            alertView?.showMessage(viewModel: AlertViewModel(title: "Falha na validação", message: "Email é obrigatório"))
        } else if (viewModel.password == nil || viewModel.password!.isEmpty) {
            alertView?.showMessage(viewModel: AlertViewModel(title: "Falha na validação", message: "Senha é obrigatória"))
        } else if (viewModel.passwordConfirmation == nil || viewModel.passwordConfirmation!.isEmpty) {
            alertView?.showMessage(viewModel: AlertViewModel(title: "Falha na validação", message: "Confirmação de senha é obrigatória"))
        }
    }
}

protocol AlertView {
    func showMessage(viewModel: AlertViewModel)
}

struct AlertViewModel: Equatable {
    var title: String
    var message: String
}

struct SignupViewModel {
    var name: String?
    var email: String?
    var password: String?
    var passwordConfirmation: String?
}


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
