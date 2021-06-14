import UIKit
import Presentation

class SignupViewController: UIViewController {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    
    var signUp: ((SignupViewModel) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        signupButton?.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
    }
    
    @objc private func signupButtonTapped() {
        signUp?(SignupViewModel(name: nameTextField.text, email: emailTextField.text, password: passwordTextField.text, passwordConfirmation: passwordConfirmationTextField.text))
    }

}

extension SignupViewController: LoadingView {
    func display(viewModel: LoadingViewModel) {
        if(viewModel.isLoading) {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
    }    
}

extension SignupViewController: AlertView {
    func showMessage(viewModel: AlertViewModel) {
        
    }
    
}
