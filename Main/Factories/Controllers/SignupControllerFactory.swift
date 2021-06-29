import Foundation
import Domain
import Validation
import Presentation
import IosUI

public func makeSignupController() -> SignupViewController {
    return makeSignupControllerWith(addAccount: makeRemoteAddAccount())
}

public func makeSignupControllerWith(addAccount: AddAccount) -> SignupViewController {
    let controller = SignupViewController.instantiate()
    let validateComposite = ValidationComposite(validations: makeSignupValidations())
    
    let presenter = SignupPresenter(alertView: WeakVarProxy(controller), validation: validateComposite, addAccount: addAccount, loadingView: WeakVarProxy(controller))
    controller.signUp = presenter.signUp
    return controller
}

public func makeSignupValidations() -> [Validation] {
    return ValidationBuilder.field("name").label("Nome").required().build() +
        ValidationBuilder.field("email").label("Email").required().email().build() +
        ValidationBuilder.field("password").label("Senha").required().build() +
        ValidationBuilder.field("passwordConfirmation").label("Confirmar Senha").required().build() +
        ValidationBuilder.field("password").label("Confirmar Senha").sameAs("passwordConfirmation").build()
}
