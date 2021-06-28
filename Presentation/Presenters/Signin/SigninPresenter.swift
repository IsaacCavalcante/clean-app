import Foundation
import Domain

public final class SigninPresenter {
    private let validation: Validation
    
    public init(validation: Validation) {
        self.validation = validation
    }
    
    public func signIn(viewModel: SigninViewModel) {
        _ = validation.validate(data: viewModel.toJson())
    }
}
