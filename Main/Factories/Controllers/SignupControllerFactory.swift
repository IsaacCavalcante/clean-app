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
    return [RequiredFieldsValidation(fieldName: "name", fieldLabel: "Nome"),
            RequiredFieldsValidation(fieldName: "email", fieldLabel: "Email"),
            EmailValidation(fieldName: "email", fieldLabel: "Email", emailValidator: makeEmailValidatorAdapter()),
            RequiredFieldsValidation(fieldName: "password", fieldLabel: "Senha"),
            RequiredFieldsValidation(fieldName: "passwordConfirmation", fieldLabel: "Confirmar Senha"),
            CompareFieldsValidation(fieldName: "password", fieldNameToCompare: "passwordConfirmation", fieldLabel: "Confirmar Senha")]
}
