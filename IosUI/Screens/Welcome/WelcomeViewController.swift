import UIKit

public final class WelcomeViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    
    public var signIn: (() -> Void)?
    public var signUp: (() -> Void)?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        title = "IDevs"
        signinButton.layer.cornerRadius = 5
        signinButton?.addTarget(self, action: #selector(signinButtonTapped), for: .touchUpInside)
        
        signupButton.layer.cornerRadius = 5
        signupButton?.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)

    }
    
    @objc private func signinButtonTapped() {
        signIn?()
    }
    
    @objc private func signupButtonTapped() {
        signUp?()
    }
}
