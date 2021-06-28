import UIKit
import Presentation

public final class SigninViewController: UIViewController, Storyboarded {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var signinButton: UIButton!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        title = "IDevs"
        signinButton.layer.cornerRadius = 5
        hideKeyboardOnTap()
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
