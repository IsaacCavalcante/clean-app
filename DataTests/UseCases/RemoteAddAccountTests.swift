import XCTest
import Domain
import Data

class DataTests: XCTestCase {

    func test_add_should_call_httpClient_with_correct_url() throws {
        let (sut, url, httpClientSpy) = makeSut()
        let addAccountModel = makeAddAccountModel()
        sut.add(addAccountModel: addAccountModel){_ in }
        
        XCTAssertEqual(httpClientSpy.url, url, "Url send to httpClient is wrong")
        XCTAssertEqual(httpClientSpy.callsCounter, 1, "post method from HttpClient called more than once")
    }
    
    func test_add_should_call_httpClient_with_correct_data() throws {
        let sut = makeSut()
        let addAccountModel = makeAddAccountModel()
        sut.principal.add(addAccountModel: addAccountModel){_ in }
        
        XCTAssertEqual(sut.httpClientSpy.data, addAccountModel.toData(), "Data from to httpClient is wrong")
    }
    
    func test_add_should_complete_with_error_if_client_fails() throws {
        let sut = makeSut()
        let addAccountModel = makeAddAccountModel()
        let exp = expectation(description: "completion to add remote account should response until 1 second")
        sut.principal.add(addAccountModel: addAccountModel) { error in
            XCTAssertEqual(error, .unexpected, "Error send is wrong")
            exp.fulfill()
        }
        //Aqui eu incitei a ocorrência de erro por que o ponto principal do teste é testar o erro, caso eu chamsse o completion dentro do método post de HttpClientSpy futuramente deveria decidir o que responder já que haverá casos de sucesso também, então o método completionWithError foi criado dentro de HttpClientSpy para forçar a resposta de erro para a qual queremos no teste que é DomainError.unexpected. Lembrando que .unexpected está sendo definido dentro do método add de RemoteAddAccount
        sut.httpClientSpy.completionWithError(.noConnectivity)
        wait(for: [exp], timeout: 1)
    }
    
}

extension DataTests {
    func makeSut() -> (principal: RemoteAddAccount, url: URL, httpClientSpy: HttpClientSpy){
        let url = URL(string: "https://any-url.com")!
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        
        return (principal: sut, url: url, httpClientSpy: httpClientSpy)
    }
    
    func makeAddAccountModel () -> AddAccountModel {
        return AddAccountModel(name: "anyName", email: "anyEmail", password: "anyPassword", passwordConfirmation: "anyPassword")
    }
    
    class HttpClientSpy: HttpPostClient {
        var url: URL?
        var data: Data?
        var callsCounter = 0
        var completion: ((HttpError) -> Void)?
        
        func post(to url: URL, with data: Data?, completion: @escaping (HttpError) -> Void) {
            self.url = url
            self.data = data
            self.callsCounter += 1
            self.completion = completion
        }
        
        func completionWithError(_ error: HttpError){
            completion?(.noConnectivity)
        }
    }
}
