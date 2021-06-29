import UIKit
import Presentation

public final class SigninViewController: UIViewController, Storyboarded {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emailTextField: RoundedTextField!
    @IBOutlet weak var passwordTextField: RoundedTextField!
    @IBOutlet weak var signinButton: UIButton!
    
    public var signIn: ((SigninRequest) -> Void)?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        title = "IDevs"
        signinButton.layer.cornerRadius = 5
        signinButton?.addTarget(self, action: #selector(signinButtonTapped), for: .touchUpInside)
        hideKeyboardOnTap()
    }
    
    @objc private func signinButtonTapped() {
        signIn?(SigninRequest(email: emailTextField.text, password: passwordTextField.text))
    }
}

extension SigninViewController: LoadingView {
    public func display(viewModel: LoadingViewModel) {
        if(viewModel.isLoading) {
            view.isUserInteractionEnabled = false
            loadingIndicator.startAnimating()
        } else {
            view.isUserInteractionEnabled = true
            loadingIndicator.stopAnimating()
        }
    } 
}

extension SigninViewController: AlertView {
    public func showMessage(viewModel: AlertViewModel) {
        let alert = UIAlertController(title: viewModel.title, message: viewModel.message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true, completion: nil)
    }
}
