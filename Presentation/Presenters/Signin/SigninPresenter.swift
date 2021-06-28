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
            authentication.auth(authenticationModel: viewModel.toAuthenticationModel()) { _ in }
        }
    }
}
