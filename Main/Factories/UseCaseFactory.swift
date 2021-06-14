import Foundation
import Domain
import Infra
import Data

final class UseCaseFactory {
    static func makeRemoteAddAccount() -> AddAccount {
        let url = URL(string: "http://clean-node-api.herokuapp.com/api/signup")!
        let alamofireAdapter = AlamofireAdapter()
        
        return RemoteAddAccount(url: url, httpClient: alamofireAdapter)
    }
}
