import Foundation
import Domain

public final class SignupPresenter {
    private let alertView: AlertView
    private let loadingView: LoadingView
    private let emailValidator: EmailValidator
    private let addAccount: AddAccount
    
    public init(alertView: AlertView, emailValidator: EmailValidator, addAccount: AddAccount, loadingView: LoadingView) {
        self.alertView = alertView
        self.loadingView = loadingView
        self.emailValidator = emailValidator
        self.addAccount = addAccount
    }
    
    public func signUp(viewModel: SignupViewModel) {
        if let message = validate(viewModel: viewModel) {
            alertView.showMessage(viewModel: AlertViewModel(title: "Falha na validação", message: message))
        } else {
            loadingView.display(viewModel: LoadingViewModel(isLoading: true))
            
            addAccount.add(addAccountModel: SignupMapper.toAccountMode(viewModel: viewModel), completion: { [weak self] result in
                guard let self = self else { return }
                
                self.loadingView.display(viewModel: LoadingViewModel(isLoading: false))
                
                switch result {
                case .failure: self.alertView.showMessage(viewModel: AlertViewModel(title: "Error", message: "Algo inesperado aconteceu. Tente novamente em alguns instantes"))
                case .success: self.alertView.showMessage(viewModel: AlertViewModel(title: "Sucesso", message: "Conta criada com sucesso"))
                }
                
                
            })
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
        }else if (!emailValidator.isValid(email: viewModel.email!)) { //Só estou fazendo unwrap de viewModel.email! por que nos if-else acima eu garanto que se viewModel.email estiver vazio o fluxo do código não chega nessa linha
            return "Email não é válido"
        }

        return nil
    }
}
