import Foundation
import Domain

public final class SigninPresenter {
    private let validation: Validation
    private let alertView: AlertView
    
    public init(validation: Validation, alertView: AlertView) {
        self.validation = validation
        self.alertView = alertView
    }
    
    public func signIn(viewModel: SigninViewModel) {
        if let message = validation.validate(data: viewModel.toJson()) {
            alertView.showMessage(viewModel: AlertViewModel(title: "Falha na validação", message: message))
        }
    }
}
