import Foundation
import Domain
import IosUI

public final class SignupComposer {
    public static func composeControllerWith(addAccount: AddAccount) -> SignupViewController {
        return ControllerFactory.makeSignup(addAccount: addAccount)
    }
}
