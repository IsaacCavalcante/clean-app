import Foundation
import Domain
import Infra
import Data

final class UseCaseFactory {
    
    private static let httpClient = AlamofireAdapter()
    private static let apiBaseUrl = "http://clean-node-api.herokuapp.com/api"
    
    private static func makeUrl(path: String) -> URL {
        return URL(string: "\(apiBaseUrl)/\(path)")!
    }
    
    static func makeRemoteAddAccount() -> AddAccount {
        let url = makeUrl(path: "signup")
        return RemoteAddAccount(url: url, httpClient: httpClient)
    }
}
