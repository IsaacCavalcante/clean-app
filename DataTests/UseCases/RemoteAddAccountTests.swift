import XCTest
import Domain
import Data

class DataTests: XCTestCase {

    func test_add_should_call_httpClient_with_correct_url() throws {
        let (sut, url, httpClientSpy) = makeSut()
        sut.add(addAccountModel: makeAddAccountModel()){_ in }
        
        XCTAssertEqual(httpClientSpy.url, url, "Url send to httpClient is wrong")
        XCTAssertEqual(httpClientSpy.callsCounter, 1, "post method from HttpClient called more than once")
    }
    
    func test_add_should_call_httpClient_with_correct_data() throws {
        let sut = makeSut()
        let addAccountModel = makeAddAccountModel()
        sut.principal.add(addAccountModel: makeAddAccountModel()){_ in }
        
        XCTAssertEqual(sut.httpClientSpy.data, addAccountModel.toData(), "Data from to httpClient is wrong")
    }
    
    func test_add_should_complete_with_error_if_client_completes_with_error() throws {
        let sut = makeSut()
        let exp = expectation(description: "completion to add remote account should response until 1 second")
        expect(sut.principal, exp, completeWith: .failure(.unexpected), when: { sut.httpClientSpy.completionWithError(.noConnectivity) })
    }
    
    func test_add_should_complete_with_account_if_client_completes_with_valid_data() throws {
        let sut = makeSut()
        let expectedAccount = makeAccountModel()
        let exp = expectation(description: "completion to add remote account should response until 1 second")
        expect(sut.principal, exp, completeWith: .success(expectedAccount), when: { sut.httpClientSpy.completionWithData(expectedAccount.toData()!) })
    }
    
    func test_add_should_complete_with_error_if_client_completes_with_invalid_data() throws {
        let sut = makeSut()
        let exp = expectation(description: "completion to add remote account should response until 1 second")
        expect(sut.principal, exp, completeWith: .failure(.invalidData), when: { sut.httpClientSpy.completionWithData(Data("invalidData".utf8)) })
    }
    
}

extension DataTests {
    func makeSut() -> (principal: RemoteAddAccount, url: URL, httpClientSpy: HttpClientSpy){
        let url = URL(string: "https://any-url.com")!
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        
        return (principal: sut, url: url, httpClientSpy: httpClientSpy)
    }
    
    func expect(_ sut: RemoteAddAccount, _ exp: XCTestExpectation, completeWith expectedResult: Result<AccountModel, DomainError>, when action: ()->Void) {
        
        sut.add(addAccountModel: makeAddAccountModel()) { receivedResult in
            switch (receivedResult, expectedResult) {
            case (.failure(let expectedError), .failure(let receivedError)): XCTAssertEqual(expectedError, receivedError)
            case (.success(let expectedAccount), .success(let receivedAccount)): XCTAssertEqual(expectedAccount, receivedAccount)
            default: XCTFail("Expected \(expectedResult) received \(receivedResult) insted")
                
            }
            
            exp.fulfill()
        }
        //Aqui eu incitei a ocorrência de erro chamando o método action que é passado como parâmeto por que o ponto principal do teste é testar o caso, caso eu chamasse o completion dentro do método post de HttpClientSpy, futuramente deveria decidir o que responder já que haverá casos de sucesso também, então o método completionWithError foi criado dentro de HttpClientSpy para forçar a resposta de erro para a qual queremos no teste que é DomainError.unexpected. Lembrando que .unexpected está sendo definido dentro do método add de RemoteAddAccount
        action()
        wait(for: [exp], timeout: 1)
    }
    
    func makeAddAccountModel () -> AddAccountModel {
        return AddAccountModel(name: "anyName", email: "anyEmail", password: "anyPassword", passwordConfirmation: "anyPassword")
    }
    
    func makeAccountModel () -> AccountModel {
        return AccountModel(id: "someId", name: "anyName", email: "anyEmail", password: "anyPassword")
    }
    
    class HttpClientSpy: HttpPostClient {
        var url: URL?
        var data: Data?
        var callsCounter = 0
        var completion: ((Result<Data, HttpError>) -> Void)?
        
        func post(to url: URL, with data: Data?, completion: @escaping (Result<Data, HttpError>) -> Void) {
            self.url = url
            self.data = data
            self.callsCounter += 1
            self.completion = completion
        }
        
        func completionWithError(_ error: HttpError){
            completion?(.failure(error))
        }
        
        func completionWithData(_ data: Data){
            completion?(.success(data))
        }
    }
}
