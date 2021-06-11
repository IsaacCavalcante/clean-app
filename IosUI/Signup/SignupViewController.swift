import UIKit
import Presentation

class SignupViewController: UIViewController {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
