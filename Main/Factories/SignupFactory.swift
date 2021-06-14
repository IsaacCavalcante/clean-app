import Foundation
import IosUI
import Presentation
import Validation
import Domain

class ControllerFactory {
    static func makeSignup(addAccount: AddAccount) -> SignupViewController {
        let controller = SignupViewController.instantiate()
        let emailValidatorAdapter = EmailValidatorAdapter()
        let presenter = SignupPresenter(alertView: controller, emailValidator: emailValidatorAdapter, addAccount: addAccount, loadingView: controller)
        controller.signUp = presenter.signUp
        
        return controller
    }
}
