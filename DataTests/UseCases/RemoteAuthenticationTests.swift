import XCTest
import Domain
import Data

class RemoteAuthenticationTests: XCTestCase {

    func test_auth_should_call_httpClient_with_correct_url() throws {
        let (sut, url, httpClientSpy) = makeSut()
        sut.auth(authenticationModel: makeAuthenticationModel()){ _ in }
        
        XCTAssertEqual(httpClientSpy.url, url, "Url send to httpClient is wrong")
        XCTAssertEqual(httpClientSpy.callsCounter, 1, "post method from HttpClient called more than once")
    }
    
    func test_auth_should_call_httpClient_with_correct_data() throws {
        let sut = makeSut()
        let authenticationModel = makeAuthenticationModel()
        sut.principal.auth(authenticationModel: authenticationModel){ _ in }
        
        XCTAssertEqual(sut.httpClientSpy.data, authenticationModel.toData(), "Data from to httpClient is wrong")
    }
    
    func test_auth_should_complete_with_error_if_client_completes_with_error() throws {
        let sut = makeSut()
        let exp = expectation(description: "completion to add remote account should response until 1 second")
        expect(sut.principal, exp, completeWith: .failure(.unexpected), when: { sut.httpClientSpy.completionWithError(.noConnectivity) })
    }
    
    func test_add_should_complete_with_email_in_use_if_client_completes_with_unauthorized() throws {
        let sut = makeSut()
        let exp = expectation(description: "completion to add remote account should response until 1 second")
        expect(sut.principal, exp, completeWith: .failure(.sessionExpired), when: { sut.httpClientSpy.completionWithError(.unauthorized) })
    }
}

extension RemoteAuthenticationTests {
    func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (principal: RemoteAuthentication, url: URL, httpClientSpy: HttpClientSpy){
        let url = makeUrl()
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAuthentication(url: url, httpClient: httpClientSpy)
        
        checkMemoryLeak(for: sut)
        checkMemoryLeak(for: httpClientSpy)
        
        return (principal: sut, url: url, httpClientSpy: httpClientSpy)
    }
    
    func expect(_ sut: RemoteAuthentication, _ exp: XCTestExpectation, completeWith expectedResult: Authentication.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        
        sut.auth(authenticationModel: makeAuthenticationModel()) { receivedResult  in
            switch (receivedResult, expectedResult) {
            case (.failure(let expectedError), .failure(let receivedError)): XCTAssertEqual(expectedError, receivedError, file: file, line: line)
            case (.success(let expectedAccount), .success(let receivedAccount)): XCTAssertEqual(expectedAccount, receivedAccount, file: file, line: line)
            default: XCTFail("Expected \(expectedResult) received \(receivedResult) insted", file: file, line: line)
                
            }
            
            exp.fulfill()
        }
        
        //Aqui eu incitei a ocorrência de erro chamando o método action que é passado como parâmeto por que o ponto principal do teste é testar o caso, se eu chamasse o completion dentro do método post de HttpClientSpy deveria decidir o que responder já que haverá casos de sucessos e erros diferenciados, então os métodos completionWithError e completionWithData foram criados dentro de HttpClientSpy para forçar a resposta de erro ou acerto para a qual queremos no teste. Lembrando que o erro ou o model retornado está sendo definido dentro do método add de RemoteAddAccount
        action()
        wait(for: [exp], timeout: 1)
    }
}
