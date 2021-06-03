import XCTest
import Domain
import Data

class DataTests: XCTestCase {

    func test_add_should_call_httpClient_with_correct_url() throws {
        let (sut, url, httpClientSpy) = makeSut()
        let addAccountModel = makeAddAccountModel()
        sut.add(addAccountModel: addAccountModel)
        
        XCTAssertEqual(httpClientSpy.url, url, "Url send to httpClient is wrong")
        XCTAssertEqual(httpClientSpy.callsCounter, 1, "post method from HttpClient called more than one time")
    }
    
    func test_add_should_call_httpClient_with_correct_data() throws {
        let sut = makeSut()
        let addAccountModel = makeAddAccountModel()
        sut.sut.add(addAccountModel: addAccountModel)
        
        XCTAssertEqual(sut.httpClientSpy.data, addAccountModel.toData(), "Data from to httpClient is wrong")
    }
    
}

extension DataTests {
    func makeSut() -> (sut: RemoteAddAccount, url: URL, httpClientSpy: HttpClientSpy){
        let url = URL(string: "https://any-url.com")!
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        
        return (sut: sut, url: url, httpClientSpy: httpClientSpy)
    }
    
    func makeAddAccountModel () -> AddAccountModel {
        return AddAccountModel(name: "anyName", email: "anyEmail", password: "anyPassword", passwordConfirmation: "anyPassword")
    }
    
    class HttpClientSpy: HttpPostClient {
        var url: URL?
        var data: Data?
        var callsCounter = 0
        
        func post(to url: URL, with data: Data?) {
            self.url = url
            self.data = data
            self.callsCounter += 1
        }
    }
}
