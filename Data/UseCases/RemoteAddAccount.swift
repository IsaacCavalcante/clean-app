import Foundation
import Domain

public final class RemoteAddAccount: AddAccount {
    
    private var url: URL
    private var httpClient: HttpPostClient
    
    public init(url: URL, httpClient: HttpPostClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    public func add(addAccountModel: AddAccountModel, completion: @escaping (AddAccount.Result) -> Void) {
        httpClient.post(to: url, with: addAccountModel.toData()){ [weak self] result in
            
            //garante que a instância de RemoteAddAccount ainda exista para continuar chamando o completion. Isso só pode ser garantido por causa da definição de [weak self] na closure acima
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
                case .forbidden:
                    completion(.failure(.emailInUse))
                default:
                    completion(.failure(.unexpected))
                }
            }
        }
    }
}
