import XCTest
import Presentation
import Domain

class SignupPresenterTests: XCTestCase {
    func test_signup_should_show_error_message_if_name_is_not_provider() {
        let test = makeSut()
        let sut = test.sut
        let alertViewSpy = test.alertViewSpy
        
        let exp = expectation(description: "completion to add remote account should response until 1 second")
        alertViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, makeAlertViewModel(message: "Nome é obrigatório"))
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
        alertViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, makeAlertViewModel(message: "Email é obrigatório"))
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
        alertViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, makeAlertViewModel(message: "Senha é obrigatória"))
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
        alertViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, makeAlertViewModel(message: "Confirmação de senha é obrigatória"))
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
        alertViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, makeAlertViewModel(message: "Falha ao confirmar senha"))
            exp.fulfill()
        }
        sut.signUp(viewModel:  makeSignupViewModel(passwordConfirmation: "wrong_password"))
        wait(for: [exp], timeout: 1)
    }
    
    func test_signup_should_show_error_message_if_invalid_email_is_provided() {
        let test = makeSut()
        
        let sut = test.sut
        let alertViewSpy = test.alertViewSpy
        let emailValidatorSpy = test.emailValidatorSpy

        let exp = expectation(description: "completion to add remote account should response until 1 second")
        alertViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, makeAlertViewModel(message: "Email não é válido"))
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
        alertViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, makeAlertViewModel(title: "Error", message: "Algo inesperado aconteceu. Tente novamente em alguns instantes"))
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
        alertViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, makeAlertViewModel(title: "Sucesso", message: "Conta criada com sucesso"))
            exp.fulfill()
        }
        sut.signUp(viewModel: makeSignupViewModel())
        addAccountSpy.completeWithAccountModel(makeAccountModel())
        
        wait(for: [exp], timeout: 1)
    }
    
    
    func test_signup_should_show_loading_before_and_after_addAccount() {
        let test = makeSut()
        let sut = test.sut
        let loadingViewSpy = test.loadingViewSpy
        let addAccountSpy = test.addAccountSpy
        
        //BEFORE addAccount
        let exp = expectation(description: "completion to add remote account should response until 1 second")
        loadingViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, LoadingViewModel(isLoading: true ))
            exp.fulfill()
        }
        sut.signUp(viewModel: makeSignupViewModel())
        wait(for: [exp], timeout: 1)
        
        //AFTER addAccount
        let exp2 = expectation(description: "completion to add remote account should response until 1 second")
        loadingViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, LoadingViewModel(isLoading: false ))
            exp2.fulfill()
        }
        
        //Nesse teste poderia ser chama o completeWithAccountModel também é indiferente já que o que queremos testar é o LoadingViewModel do loadingViewSpy
        addAccountSpy.completeWithError(.unexpected)
        wait(for: [exp2], timeout: 1)
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
    func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (sut: SignupPresenter, alertViewSpy: AlertViewSpy, loadingViewSpy: LoadingViewSpy, emailValidatorSpy: EmailValidatorSpy, addAccountSpy: AddAccountSpy) {
        let alertViewSpy = AlertViewSpy()
        let loadingViewSpy = LoadingViewSpy()
        let emailValidatorSpy = EmailValidatorSpy()
        let addAccountSpy = AddAccountSpy()
        let sut = SignupPresenter(alertView: alertViewSpy, emailValidator: emailValidatorSpy, addAccount: addAccountSpy, loadingView: loadingViewSpy)
        checkMemoryLeak(for: sut, file: file, line: line)
        
        return (sut, alertViewSpy, loadingViewSpy, emailValidatorSpy, addAccountSpy)
    }
}
