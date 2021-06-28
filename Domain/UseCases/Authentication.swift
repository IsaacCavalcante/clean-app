import Foundation

public protocol Authentication {
    typealias Result = Swift.Result<AccountModel, DomainError>
    func add(authenticationModel: AuthenticationModel, completion: @escaping (Result) -> Void)
}

public struct AuthenticationModel: Model {
    public var email: String
    public var password: String
    
    public init(name: String, email: String, password: String, passwordConfirmation: String) {
        self.email = email
        self.password = password
    }
}
