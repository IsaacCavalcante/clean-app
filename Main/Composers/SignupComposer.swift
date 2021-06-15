import Foundation
import Domain
import Validation
import Presentation
import IosUI

public final class SignupComposer {
    public static func composeControllerWith(addAccount: AddAccount) -> SignupViewController {
        let controller = SignupViewController.instantiate()
        let emailValidatorAdapter = EmailValidatorAdapter()
        let presenter = SignupPresenter(alertView: WeakVarProxy(controller), emailValidator: emailValidatorAdapter, addAccount: addAccount, loadingView: WeakVarProxy(controller))
        controller.signUp = presenter.signUp
        return controller
    }
}
