import XCTest
import Data
import Domain
import Infra

class AddAccountIntegrationTests: XCTestCase {
    func test_add_account() {
        let alamofireAdapter = AlamofireAdapter()
        let url = URL(string: "http://localhost:5050/api/signup")!
        let sut = RemoteAddAccount(url: url, httpClient: alamofireAdapter)
        //obs: Sempre rodar o servidor (https://github.com/rmanguinho/clean-ts-api) e trocar o email abaixo para resultar em sucesso
        let addAccountModel = AddAccountModel(name: "Isaac Cavalcante", email: "\(UUID().uuidString)@monitoratec.com.br", password: "password", passwordConfirmation: "password")
        let exp = expectation(description: "Should response until 5 seconds")
        sut.add(addAccountModel: addAccountModel) { result in
            switch result {
            case .failure: XCTFail("Expect success, but received \(result) insted")
            case .success(let account):
                XCTAssertNotNil(account.accessToken)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
        
        let exp2 = expectation(description: "Should response until 5 seconds")
        sut.add(addAccountModel: addAccountModel) { result in
            switch result {
            case .failure(let error) where error == .emailInUse:
                XCTAssertNotNil(error)
            default:
                XCTFail("Expect email in use failure, but received \(result) insted")
            }
            exp2.fulfill()
        }
        wait(for: [exp2], timeout: 5)
    }

}
