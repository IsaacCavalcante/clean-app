import XCTest
import Data
import Domain
import Infra

class AddAccountIntegrationTests: XCTestCase {
    func test_add_account() {
        let alamofireAdapter = AlamofireAdapter()
        let url = URL(string: "http://localhost:5050/api/signup")!
        let sut = RemoteAddAccount(url: url, httpClient: alamofireAdapter)
        let addAccountModel = AddAccountModel(name: "Isaac Cavalcante", email: "isaac.cavalcante@monitoratec.com.br", password: "password", passwordConfirmation: "password")
        let exp = expectation(description: "Should response until 5 seconds")
        sut.add(addAccountModel: addAccountModel) { result in
            switch result {
            case .failure: XCTFail("Expect success, but received \(result) insted")
            case .success(let account):
                XCTAssertNil(account.id)
                XCTAssertEqual(account.name, addAccountModel.name)
                XCTAssertEqual(account.email, addAccountModel.email)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
    }

}
