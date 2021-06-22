import Foundation
import Domain
import Validation
import Presentation
import IosUI
import Infra

public final class SignupComposer {
    public static func composeControllerWith(addAccount: AddAccount) -> SignupViewController {
        let controller = SignupViewController.instantiate()
        let validateComposite = ValidationComposite(validations: makeValidations())
        
        let presenter = SignupPresenter(alertView: WeakVarProxy(controller), validation: validateComposite, addAccount: addAccount, loadingView: WeakVarProxy(controller))
        controller.signUp = presenter.signUp
        return controller
    }
    
    public static func makeValidations() -> [Validation] {
        return [RequiredFieldsValidation(fieldName: "name", fieldLabel: "Nome"),
                RequiredFieldsValidation(fieldName: "email", fieldLabel: "Email"),
                EmailValidation(fieldName: "email", fieldLabel: "Email", emailValidator: EmailValidatorAdapter()),
                RequiredFieldsValidation(fieldName: "password", fieldLabel: "Senha"),
                RequiredFieldsValidation(fieldName: "passwordConfirmation", fieldLabel: "Confirmar Senha"),
                CompareFieldsValidation(fieldName: "password", fieldNameToCompare: "passwordConfirmation", fieldLabel: "Confirmar Senha")]
    }
}
