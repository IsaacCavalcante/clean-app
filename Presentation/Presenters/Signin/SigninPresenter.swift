import Foundation
import Domain

public final class SigninPresenter {
    private let validation: Validation
    private let alertView: AlertView
    private let authentication: Authentication
    
    public init(validation: Validation, alertView: AlertView, authentication: Authentication) {
        self.validation = validation
        self.alertView = alertView
        self.authentication = authentication
    }
    
    public func signIn(viewModel: SigninViewModel) {
        if let message = validation.validate(data: viewModel.toJson()) {
            alertView.showMessage(viewModel: AlertViewModel(title: "Falha na validação", message: message))
        } else {
            authentication.auth(authenticationModel: viewModel.toAuthenticationModel()) { [weak self] result in
                guard let self = self else { return }
                
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
                case .success: break
                }
            }
        }
    }
}
