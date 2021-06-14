import Foundation
import IosUI
import Presentation
import Validation
import Data
import Infra

class SignupFactory {
    static func makeController() -> SignupViewController {
        let controller = SignupViewController.instantiate()
        let emailValidatorAdapter = EmailValidatorAdapter()
        let url = URL(string: "http://clean-node-api.herokuapp.com/api/signup")!
        let alamofireAdapter = AlamofireAdapter()
        let remoteAddAccount = RemoteAddAccount(url: url, httpClient: alamofireAdapter)
        let presenter = SignupPresenter(alertView: controller, emailValidator: emailValidatorAdapter, addAccount: remoteAddAccount, loadingView: controller)
        controller.signUp = presenter.signUp
        
        return controller
    }
}
