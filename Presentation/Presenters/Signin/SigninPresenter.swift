import Foundation
import Domain

public final class SigninPresenter {
    private let validation: Validation
    private let alertView: AlertView
    private let loadingView: LoadingView
    private let authentication: Authentication
    
    public init(alertView: AlertView, validation: Validation, authentication: Authentication, loadingView: LoadingView) {
        self.validation = validation
        self.alertView = alertView
        self.authentication = authentication
        self.loadingView = loadingView
    }
    
    public func signIn(viewModel: SigninRequest) {
        if let message = validation.validate(data: viewModel.toJson()) {
            alertView.showMessage(viewModel: AlertViewModel(title: "Falha na validação", message: message))
        } else {
            loadingView.display(viewModel: LoadingViewModel(isLoading: true))
            
            authentication.auth(authenticationModel: viewModel.toAuthenticationModel()) { [weak self] result in
                guard let self = self else { return }
                
                self.loadingView.display(viewModel: LoadingViewModel(isLoading: false))
                
                switch result {
                case .failure(let error):
                    var errorMessage = "Algo inesperado aconteceu. Tente novamente em alguns instantes"
                    switch error {
                    case .sessionExpired:
                        errorMessage = "Autenticação de usuário falhou"
                    default:
                        break
                    }
                    self.alertView.showMessage(viewModel: AlertViewModel(title: "Error", message: errorMessage))
                case .success: self.alertView.showMessage(viewModel: AlertViewModel(title: "Sucesso", message: "Login feito com sucesso"))
                }
            }
        }
    }
}
