import XCTest
import Presentation
import Domain

class SignupPresenterTests: XCTestCase {
    func test_signup_should_show_error_message_if_name_is_not_provider() {
        let test = makeSut()
        let sut = test.sut
        let alertViewSpy = test.alertViewSpy
        
        let exp = expectation(description: "completion to add remote account should response until 1 second")
        alertViewSpy.observer { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeAlertViewModel(message: "Nome é obrigatório"))
            exp.fulfill()
        }
        sut.signUp(viewModel: makeSignupViewModel(name: nil))
        wait(for: [exp], timeout: 1)
    }
    
    func test_signup_should_show_error_message_if_email_is_not_provider() {
        let test = makeSut()
        let sut = test.sut
        let alertViewSpy = test.alertViewSpy
        let exp = expectation(description: "completion to add remote account should response until 1 second")
        alertViewSpy.observer { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeAlertViewModel(message: "Email é obrigatório"))
            exp.fulfill()
        }
        sut.signUp(viewModel: makeSignupViewModel(email: nil))
        wait(for: [exp], timeout: 1)
        
        
    }
    
    func test_signup_should_show_error_message_if_password_is_not_provider() {
        let test = makeSut()
        let sut = test.sut
        let alertViewSpy = test.alertViewSpy
        
        let exp = expectation(description: "completion to add remote account should response until 1 second")
        alertViewSpy.observer { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeAlertViewModel(message: "Senha é obrigatória"))
            exp.fulfill()
        }
        sut.signUp(viewModel: makeSignupViewModel(password: nil))
        wait(for: [exp], timeout: 1)
    }
    
    func test_signup_should_show_error_message_if_password_confirmation_is_not_provider() {
        let test = makeSut()
        let sut = test.sut
        let alertViewSpy = test.alertViewSpy

        let exp = expectation(description: "completion to add remote account should response until 1 second")
        alertViewSpy.observer { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeAlertViewModel(message: "Confirmação de senha é obrigatória"))
            exp.fulfill()
        }
        sut.signUp(viewModel:  makeSignupViewModel(passwordConfirmation: nil))
        wait(for: [exp], timeout: 1)
    }
    
    func test_signup_should_show_error_message_if_password_not_macthed_with_password_confirmation() {
        let test = makeSut()
        let sut = test.sut
        let alertViewSpy = test.alertViewSpy
        
        let exp = expectation(description: "completion to add remote account should response until 1 second")
        alertViewSpy.observer { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeAlertViewModel(message: "Falha ao confirmar senha"))
            exp.fulfill()
        }
        sut.signUp(viewModel:  makeSignupViewModel(passwordConfirmation: "wrong_password"))
        wait(for: [exp], timeout: 1)
    }
    
    func test_signup_should_show_error_message_if_invalid_email_is_provided() {
        let (sut, alertViewSpy, emailValidatorSpy, _) = makeSut()

        let exp = expectation(description: "completion to add remote account should response until 1 second")
        alertViewSpy.observer { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeAlertViewModel(message: "Email não é válido"))
            exp.fulfill()
        }
        emailValidatorSpy.simulateEmailValidation(to: false)
        sut.signUp(viewModel: makeSignupViewModel())
        wait(for: [exp], timeout: 1)
    }
    
    func test_signup_should_show_error_message_if_addAccount_fails() {
        let test = makeSut()
        let sut = test.sut
        let alertViewSpy = test.alertViewSpy
        let addAccountSpy = test.addAccountSpy
        
        let exp = expectation(description: "completion to add remote account should response until 1 second")
        alertViewSpy.observer { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeAlertViewModel(title: "Error", message: "Algo inesperado aconteceu. Tente novamente em alguns instantes"))
            exp.fulfill()
        }
        sut.signUp(viewModel: makeSignupViewModel())
        addAccountSpy.completeWithError(.unexpected)
        wait(for: [exp], timeout: 1)
    }
    
    func test_signup_should_show_succes_message_if_addAccount_complete_with_success() {
        let test = makeSut()
        let sut = test.sut
        let alertViewSpy = test.alertViewSpy
        let addAccountSpy = test.addAccountSpy
        
        let exp = expectation(description: "completion to add remote account should response until 1 second")
        alertViewSpy.observer { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeAlertViewModel(title: "Sucesso", message: "Conta criada com sucesso"))
            exp.fulfill()
        }
        sut.signUp(viewModel: makeSignupViewModel())
        addAccountSpy.completeWithAccountModel(makeAccountModel())
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_signup_should_call_email_validator_with_correct_email() {
        let test = makeSut()
        let sut = test.sut
        let emailValidator = test.emailValidatorSpy

        let signupViewModel = makeSignupViewModel()
        sut.signUp(viewModel: signupViewModel)

        XCTAssertEqual(emailValidator.email, signupViewModel.email)
    }
    
    func test_signup_should_calls_addaccount_with_correct_values() {
        let test = makeSut()
        let sut = test.sut
        let addAccountSpy = test.addAccountSpy
        
        sut.signUp(viewModel: makeSignupViewModel())
        
        XCTAssertEqual(addAccountSpy.addAccountModel, makeAddAccountModel())
    }
}

extension SignupPresenterTests {
    func makeSut() -> (sut: SignupPresenter, alertViewSpy: AlertViewSpy, emailValidatorSpy: EmailValidatorSpy, addAccountSpy: AddAccountSpy) {
        let alertViewSpy = AlertViewSpy()
        let emailValidatorSpy = EmailValidatorSpy()
        let addAccountSpy = AddAccountSpy()
        let sut = SignupPresenter(alertView: alertViewSpy, emailValidator: emailValidatorSpy, addAccount: addAccountSpy)
        
        return (sut, alertViewSpy, emailValidatorSpy, addAccountSpy)
    }
    
    func makeSignupViewModel(name: String? = "Isaac Cavalcante", email: String? = "any@mail.com", password: String? = "password", passwordConfirmation: String? = "password") -> SignupViewModel {
        return SignupViewModel(name: name, email: email, password: password, passwordConfirmation: passwordConfirmation)
    }
    
    func makeAlertViewModel(title: String? = "Falha na validação", message: String? = "Falha na validação") -> AlertViewModel {
        return AlertViewModel(title: title!, message: message!)
    }
    
    class AlertViewSpy: AlertView {
        var emit: ((AlertViewModel) -> Void)?
        
        func observer(completion: @escaping (AlertViewModel) -> Void) {
            self.emit = completion
        }
        
        func showMessage(viewModel: AlertViewModel) {
            self.emit?(viewModel)
        }
    }
    
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
    
    class AddAccountSpy: AddAccount {
        var addAccountModel: AddAccountModel?
        var completion: ((Result<AccountModel, DomainError>) -> Void)?
        
        func add(addAccountModel: AddAccountModel, completion: @escaping (Result<AccountModel, DomainError>) -> Void) {
            self.addAccountModel = addAccountModel
            self.completion = completion
        }
        
        func completeWithError (_ error: DomainError) {
            completion?(.failure(error))
        }
        
        func completeWithAccountModel (_ accountModel: AccountModel) {
            completion?(.success(accountModel))
        }
    }
}
