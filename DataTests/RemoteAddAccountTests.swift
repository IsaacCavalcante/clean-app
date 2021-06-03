import XCTest
import Domain

class RemoteAddAccount {
    
    private var url: URL
    private var httpClient: HttpPostClient
    
    init(url: URL, httpClient: HttpPostClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    func add(addAccountModel: AddAccountModel) {
        let data = try? JSONEncoder().encode(addAccountModel)
        httpClient.post(to: url, with: data)
    }
}

protocol HttpPostClient {
    func post(to url: URL, with data: Data?)
}

class DataTests: XCTestCase {

    func test_add_should_call_httpClient_with_correct_url() throws {
        let url = URL(string: "https://any-url.com")!
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        let addAccountModel = AddAccountModel(name: "anyName", email: "anyEmail", password: "anyPassword", passwordConfirmation: "anyPassword")
        sut.add(addAccountModel: addAccountModel)
        XCTAssertEqual(httpClientSpy.url, url, "Url send to httpClient is wrong")
    }
    
    func test_add_should_call_httpClient_with_correct_data() throws {
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: URL(string: "https://any-url.com")!, httpClient: httpClientSpy)
        let addAccountModel = AddAccountModel(name: "anyName", email: "anyEmail", password: "anyPassword", passwordConfirmation: "anyPassword")
        sut.add(addAccountModel: addAccountModel)
        
        let data = try? JSONEncoder().encode(addAccountModel)
        XCTAssertEqual(httpClientSpy.data, data, "Data from to httpClient is wrong")
    }
    
}

extension DataTests {
    class HttpClientSpy: HttpPostClient {
        var url: URL?
        var data: Data?
        
        func post(to url: URL, with data: Data?) {
            self.url = url
            self.data = data
        }
    }
}
