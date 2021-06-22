import XCTest
import Presentation
import Domain

class SignupPresenterTests: XCTestCase {
    
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
    
    func test_signup_should_calls_addaccount_with_correct_values() {
        let test = makeSut()
        let sut = test.sut
        let addAccountSpy = test.addAccountSpy
        
        sut.signUp(viewModel: makeSignupViewModel())
        
        XCTAssertEqual(addAccountSpy.addAccountModel, makeAddAccountModel())
    }
    
    func test_signup_should_calls_validation_with_correct_values() {
        let test = makeSut()
        let sut = test.sut
        let validation = test.validationSpy
        let viewModel = makeSignupViewModel()
        sut.signUp(viewModel: viewModel)
        XCTAssertTrue(NSDictionary(dictionary: validation.data!).isEqual(to: viewModel.toJson()!))
    }
    
    func test_signup_should_show_error_message_if_validation_fails() {
        let test = makeSut()
        let sut = test.sut
        let alertViewSpy = test.alertViewSpy
        let validationSpy = test.validationSpy
        
        let exp = expectation(description: "completion to add remote account should response until 1 second")
        alertViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, makeAlertViewModel(message: "Erro"))
            exp.fulfill()
        }
        validationSpy.simulateError()
        sut.signUp(viewModel: makeSignupViewModel())
        wait(for: [exp], timeout: 1)
    }
}

extension SignupPresenterTests {
    func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (sut: SignupPresenter, alertViewSpy: AlertViewSpy, loadingViewSpy: LoadingViewSpy, validationSpy: ValidationSpy, addAccountSpy: AddAccountSpy) {
        let alertViewSpy = AlertViewSpy()
        let loadingViewSpy = LoadingViewSpy()
        let validationSpy = ValidationSpy()
        let addAccountSpy = AddAccountSpy()
        let sut = SignupPresenter(alertView: alertViewSpy, validation: validationSpy, addAccount: addAccountSpy, loadingView: loadingViewSpy)
        checkMemoryLeak(for: sut, file: file, line: line)
        
        return (sut, alertViewSpy, loadingViewSpy, validationSpy, addAccountSpy)
    }
}
