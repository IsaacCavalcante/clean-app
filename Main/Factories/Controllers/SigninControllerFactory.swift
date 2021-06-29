import Foundation
import Domain
import Validation
import Presentation
import IosUI

public func makeSigninController() -> SigninViewController {
    return makeSigninControllerWith(authentication: makeRemoteAuthentication())
}

public func makeSigninControllerWith(authentication: Authentication) -> SigninViewController {
    let controller = SigninViewController.instantiate()
    let validateComposite = ValidationComposite(validations: makeSigninValidations())
    let presenter = SigninPresenter(alertView: WeakVarProxy(controller), validation: validateComposite, authentication: authentication, loadingView: WeakVarProxy(controller))
    controller.signIn = presenter.signIn
    return controller
}

public func makeSigninValidations() -> [Validation] {
    return [RequiredFieldsValidation(fieldName: "email", fieldLabel: "Email"),
            EmailValidation(fieldName: "email", fieldLabel: "Email", emailValidator: makeEmailValidatorAdapter()),
            RequiredFieldsValidation(fieldName: "password", fieldLabel: "Senha")]
}
