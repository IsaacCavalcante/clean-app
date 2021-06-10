import Foundation

public struct SignupViewModel {
    public var name: String?
    public var email: String?
    public var password: String?
    public var passwordConfirmation: String?
    
    public init(name: String? = nil, email: String? = nil, password: String? = nil, passwordConfirmation: String? = nil) {
        self.name = name
        self.email = email
        self.password = password
        self.passwordConfirmation = passwordConfirmation
    }
}

public final class SignupPresenter {
    private let alertView: AlertView?
    private let emailValidator: EmailValidator?
    
    public init(alertView: AlertView, emailValidator: EmailValidator) {
        self.alertView = alertView
        self.emailValidator = emailValidator
    }
    
    public func signUp(viewModel: SignupViewModel) {
        if let message = validate(viewModel: viewModel) {
            alertView?.showMessage(viewModel: AlertViewModel(title: "Falha na validação", message: message))
        }
    }
    
    private func validate(viewModel: SignupViewModel) -> String? {
        if (viewModel.name == nil || viewModel.name!.isEmpty) {
            return "Nome é obrigatório"
        } else if (viewModel.email == nil || viewModel.email!.isEmpty) {
            return "Email é obrigatório"
        } else if (viewModel.password == nil || viewModel.password!.isEmpty) {
            return "Senha é obrigatória"
        } else if (viewModel.passwordConfirmation == nil || viewModel.passwordConfirmation!.isEmpty) {
            return "Confirmação de senha é obrigatória"
        }else if (viewModel.password != viewModel.passwordConfirmation) {
            return "Falha ao confirmar senha"
        }
        _ = emailValidator?.isValid(email: viewModel.email!)
        return nil
    }
}
