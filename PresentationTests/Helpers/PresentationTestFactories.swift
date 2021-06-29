import Foundation
import Presentation

func makeSignupViewModel(name: String? = "Isaac Cavalcante", email: String? = "any@mail.com", password: String? = "password", passwordConfirmation: String? = "password") -> SignupRequest {
    return SignupRequest(name: name, email: email, password: password, passwordConfirmation: passwordConfirmation)
}

func makeSigninViewModel(email: String? = "any@mail.com", password: String? = "password") -> SigninRequest {
    return SigninRequest(email: email, password: password)
}

func makeAlertViewModel(title: String? = "Falha na validação", message: String? = "Falha na validação") -> AlertViewModel {
    return AlertViewModel(title: title!, message: message!)
}
