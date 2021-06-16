import Foundation
import Domain
import Infra
import Data

final class UseCaseFactory {
    
    private static let httpClient = AlamofireAdapter()
    private static let apiBaseUrl = Environment.variable(.apiBaseUrl)
    
    private static func makeUrl(path: String) -> URL {
        return URL(string: "\(apiBaseUrl)/\(path)")!
    }
    
    static func makeRemoteAddAccount() -> AddAccount {
        let url = makeUrl(path: "signup")
        let remoteAddAccount = RemoteAddAccount(url: url, httpClient: httpClient)
        
        return MainQueueDispatchDecorator(remoteAddAccount)
    }
}

public final class MainQueueDispatchDecorator<T> {
    let instance: T
    
    public init(_ instance:T) {
        self.instance = instance
    }
    
    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else { return DispatchQueue.main.async(execute: completion) }
        completion()
    }
}

extension MainQueueDispatchDecorator: AddAccount where T: AddAccount {
    public func add(addAccountModel: AddAccountModel, completion: @escaping (Result<AccountModel, DomainError>) -> Void) {
        instance.add(addAccountModel: addAccountModel, completion: { [weak self] result in
            self?.dispatch {
                completion(result)
            }
        })
    }
}
