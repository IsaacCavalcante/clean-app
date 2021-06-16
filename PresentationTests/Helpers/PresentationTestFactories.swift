import Foundation
import Presentation

func makeSignupViewModel(name: String? = "Isaac Cavalcante", email: String? = "any@mail.com", password: String? = "password", passwordConfirmation: String? = "password") -> SignupViewModel {
    return SignupViewModel(name: name, email: email, password: password, passwordConfirmation: passwordConfirmation)
}

func makeAlertViewModel(title: String? = "Falha na validação", message: String? = "Falha na validação") -> AlertViewModel {
    return AlertViewModel(title: title!, message: message!)
}
