import XCTest
import Domain
import Data

class RemoteAuthenticationTests: XCTestCase {

    func test_add_should_call_httpClient_with_correct_url() throws {
        let (sut, url, httpClientSpy) = makeSut()
        sut.auth()
        
        XCTAssertEqual(httpClientSpy.url, url, "Url send to httpClient is wrong")
        XCTAssertEqual(httpClientSpy.callsCounter, 1, "post method from HttpClient called more than once")
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
}
