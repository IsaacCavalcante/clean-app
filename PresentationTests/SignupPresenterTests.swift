import XCTest

class SignupPresenter {
    private let alertView: AlertView?
    
    init(alertView: AlertView) {
        self.alertView = alertView
    }
    
    func signUp(viewModel: SignupViewModel) {
        if (viewModel.name == nil || viewModel.name!.isEmpty) {
            alertView?.showMessage(viewModel: AlertViewModel(title: "Falha na validação", message: "Nome é obrigatório"))
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
