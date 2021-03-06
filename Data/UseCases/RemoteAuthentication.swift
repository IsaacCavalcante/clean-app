import Foundation
import Domain

public final class RemoteAuthentication: Authentication {
    
    private var url: URL
    private var httpClient: HttpPostClient
    
    public init(url: URL, httpClient: HttpPostClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    public func auth(authenticationModel: AuthenticationModel, completion: @escaping (Authentication.Result) -> Void) {
        httpClient.post(to: url, with: authenticationModel.toData()){ [weak self] result in
            
            guard self != nil else { return }
            
            switch result{
            case .success(let data):
                if let model: AccountModel = data?.toModel() {
                    completion(.success(model))
                    break
                }
                completion(.failure(.invalidData))
                
            case .failure(let error):
                switch error {
                case .unauthorized:
                    completion(.failure(.sessionExpired))
                default:
                    completion(.failure(.unexpected))
                }
            }
        }
    }
}
