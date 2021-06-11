import Foundation
import Domain

public final class SignupMapper {
    static func toAccountMode(viewModel: SignupViewModel) -> AddAccountModel {
        return AddAccountModel(name: viewModel.name!, email: viewModel.email!, password: viewModel.password!, passwordConfirmation: viewModel.passwordConfirmation!)
    }
}
