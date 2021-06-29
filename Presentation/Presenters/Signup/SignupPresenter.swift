import Foundation
import Domain

public final class SignupPresenter {
    private let alertView: AlertView
    private let loadingView: LoadingView
    private let addAccount: AddAccount
    private let validation: Validation
    
    public init(alertView: AlertView, validation: Validation, addAccount: AddAccount, loadingView: LoadingView) {
        self.alertView = alertView
        self.loadingView = loadingView
        self.addAccount = addAccount
        self.validation = validation
    }
    
    public func signUp(viewModel: SignupRequest) {
        if let message = validation.validate(data: viewModel.toJson()) {
            alertView.showMessage(viewModel: AlertViewModel(title: "Falha na validação", message: message))
        } else {
            loadingView.display(viewModel: LoadingViewModel(isLoading: true))
            
            addAccount.add(addAccountModel: viewModel.toAddAccountModel(), completion: { [weak self] result in
                guard let self = self else { return }
                
                self.loadingView.display(viewModel: LoadingViewModel(isLoading: false))
                
                switch result {
                case .failure(let error):
                    var errorMessage = "Algo inesperado aconteceu. Tente novamente em alguns instantes"
                    switch error {
                    case .emailInUse:
                        errorMessage = "Esse email já está em uso"
                    default:
                        break
                    }
                    self.alertView.showMessage(viewModel: AlertViewModel(title: "Error", message: errorMessage))
                case .success: self.alertView.showMessage(viewModel: AlertViewModel(title: "Sucesso", message: "Conta criada com sucesso"))
                }
            })
        }
    }
}
