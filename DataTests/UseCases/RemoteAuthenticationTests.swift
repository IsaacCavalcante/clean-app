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
        let exp = expectation(description: "completion to auth remote account should response until 1 second")
        expect(sut.principal, exp, completeWith: .failure(.unexpected), when: { sut.httpClientSpy.completionWithError(.noConnectivity) })
    }
    
    func test_auth_should_complete_with_email_in_use_if_client_completes_with_unauthorized() throws {
        let sut = makeSut()
        let exp = expectation(description: "completion to auth remote account should response until 1 second")
        expect(sut.principal, exp, completeWith: .failure(.sessionExpired), when: { sut.httpClientSpy.completionWithError(.unauthorized) })
    }
    
    func test_auth_should_complete_with_account_if_client_completes_with_valid_data() throws {
        let sut = makeSut()
        let expectedAccount = makeAccountModel()
        let exp = expectation(description: "completion to auth remote account should response until 1 second")
        expect(sut.principal, exp, completeWith: .success(expectedAccount), when: { sut.httpClientSpy.completionWithData(expectedAccount.toData()!) })
    }
    
    func test_auth_should_complete_with_error_if_client_completes_with_invalid_data() throws {
        let sut = makeSut()
        let exp = expectation(description: "completion to auth remote account should response until 1 second")
        expect(sut.principal, exp, completeWith: .failure(.invalidData), when: { sut.httpClientSpy.completionWithData(makeInvalidData()) })
    }
    
    func test_auth_should_not_complete_with_error_if_sut_has_been_deallocated() throws {
        let httpClientSpy = HttpClientSpy()
        var sut: RemoteAuthentication? = RemoteAuthentication(url: makeUrl(), httpClient: httpClientSpy)
        var result: Authentication.Result?

        sut?.auth(authenticationModel: makeAuthenticationModel()) { result = $0 }

        sut = nil

        httpClientSpy.completionWithError(.noConnectivity)
        XCTAssertNil(result)
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
        
        action()
        wait(for: [exp], timeout: 1)
    }
}
