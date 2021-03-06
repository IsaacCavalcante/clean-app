import XCTest
import Presentation
import Domain

class SigninPresenterTests: XCTestCase {
    func test_signin_should_calls_validation_with_correct_values() {
        let test = makeSut()
        let sut = test.sut
        let validation = test.validationSpy
        let viewModel = makeSigninViewModel()
        sut.signIn(viewModel: viewModel)
        XCTAssertTrue(NSDictionary(dictionary: validation.data!).isEqual(to: viewModel.toJson()!))
    }
    
    func test_signin_should_show_error_message_if_validation_fails() {
        let test = makeSut()
        let sut = test.sut
        let alertViewSpy = test.alertViewSpy
        let validationSpy = test.validationSpy
        
        let exp = expectation(description: "completion to auth remote account should response until 1 second")
        alertViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, makeAlertViewModel(message: "Erro"))
            exp.fulfill()
        }
        validationSpy.simulateError()
        sut.signIn(viewModel: makeSigninViewModel())
        wait(for: [exp], timeout: 1)
    }
    
    func test_signup_should_calls_auth_with_correct_values() {
        let test = makeSut()
        let sut = test.sut
        let authenticationSpy = test.authenticationSpy
        
        sut.signIn(viewModel: makeSigninViewModel())
        
        XCTAssertEqual(authenticationSpy.authenticationModel, makeAuthenticationModel())
    }
    
    func test_sigin_should_show_generic_error_message_if_authentication_fails() {
        let test = makeSut()
        let sut = test.sut
        let alertViewSpy = test.alertViewSpy
        let authenticationSpy = test.authenticationSpy
        
        let exp = expectation(description: "completion to auth remote account should response until 1 second")
        alertViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, makeAlertViewModel(title: "Error", message: "Algo inesperado aconteceu. Tente novamente em alguns instantes"))
            exp.fulfill()
        }
        sut.signIn(viewModel: makeSigninViewModel())
        authenticationSpy.completeWithError(.unexpected)
        wait(for: [exp], timeout: 1)
    }
    
    func test_signin_should_show_expired_session_error_message_if_auth_returns_expired_session() {
        let test = makeSut()
        let sut = test.sut
        let alertViewSpy = test.alertViewSpy
        let authenticationSpy = test.authenticationSpy
        
        let exp = expectation(description: "completion to autg remote account should response until 1 second")
        alertViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, makeAlertViewModel(title: "Error", message: "Autentica????o de usu??rio falhou"))
            exp.fulfill()
        }
        sut.signIn(viewModel: makeSigninViewModel())
        authenticationSpy.completeWithError(.sessionExpired)
        wait(for: [exp], timeout: 1)
    }
    
    func test_signin_should_show_success_message_if_auth_completes_with_success() {
        let test = makeSut()
        let sut = test.sut
        let alertViewSpy = test.alertViewSpy
        let authenticationSpy = test.authenticationSpy
        
        let exp = expectation(description: "completion to auth remote account should response until 1 second")
        alertViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, makeAlertViewModel(title: "Sucesso", message: "Login feito com sucesso"))
            exp.fulfill()
        }
        sut.signIn(viewModel: makeSigninViewModel())
        authenticationSpy.completeWithAccountModel(makeAccountModel())
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_signin_should_show_loading_before_and_after_auth() {
        let test = makeSut()
        let sut = test.sut
        let loadingViewSpy = test.loadingViewSpy
        let authenticationSpy = test.authenticationSpy
        
        let exp = expectation(description: "completion to add remote account should response until 1 second")
        loadingViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, LoadingViewModel(isLoading: true ))
            exp.fulfill()
        }
        sut.signIn(viewModel: makeSigninViewModel())
        wait(for: [exp], timeout: 1)
        
        let exp2 = expectation(description: "completion to add remote account should response until 1 second")
        loadingViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, LoadingViewModel(isLoading: false ))
            exp2.fulfill()
        }
        
        authenticationSpy.completeWithError(.unexpected)
        wait(for: [exp2], timeout: 1)
    }
}


extension SigninPresenterTests {
    func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (sut: SigninPresenter, alertViewSpy: AlertViewSpy, loadingViewSpy: LoadingViewSpy, validationSpy: ValidationSpy, authenticationSpy: AuthenticationSpy) {
        let validationSpy = ValidationSpy()
        let alertViewSpy = AlertViewSpy()
        let loadingViewSpy = LoadingViewSpy()
        let authenticationSpy = AuthenticationSpy()
        let sut = SigninPresenter(alertView: alertViewSpy, validation: validationSpy, authentication: authenticationSpy, loadingView: loadingViewSpy)
        checkMemoryLeak(for: sut, file: file, line: line)
        
        return (sut, alertViewSpy, loadingViewSpy, validationSpy, authenticationSpy)
    }
}
