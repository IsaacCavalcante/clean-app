import XCTest
import Alamofire
import Data
import Infra

class AlamofireAdapterTest: XCTestCase {
    
    func test_post_should_make_request_with_valid_url_and_method() {
        let url = makeUrl()
        let data = makeValidData()
        
        testRequestFor(data: data) { request in
            XCTAssertEqual(url, request.url, "Url send to AlamofireAdapter is wrong")
            XCTAssertEqual("POST", request.httpMethod, "Http method calls by AlamofireAdapter is wrong")
            XCTAssertNotNil(request.httpBodyStream)
        }
    }
    
    func test_post_should_make_request_with_no_data() {
        testRequestFor(data: nil) { request in
            XCTAssertNil(request.httpBodyStream)
        }
    }
    
    func test_post_should_complete_with_error_when_request_complete_with_error() {
        expectResult(.failure(.noConnectivity), when: (data: nil, response: nil, error: makeError()))
    }
    
    func test_post_should_complete_with_error_on_all_invalid_cases() {
        expectResult(.failure(.noConnectivity), when: (data: makeValidData(), response: makeHttpResponse(), error: makeError()))
        expectResult(.failure(.noConnectivity), when: (data: makeValidData(), response: nil, error: makeError()))
        expectResult(.failure(.noConnectivity), when: (data: makeValidData(), response: nil, error: nil))
        expectResult(.failure(.noConnectivity), when: (data: nil, response: makeHttpResponse(), error: makeError()))
        expectResult(.failure(.noConnectivity), when: (data: nil, response: makeHttpResponse(), error: nil))
        expectResult(.failure(.noConnectivity), when: (data: nil, response: nil, error: nil))
    }
    
    func test_post_should_complete_with_data_when_request_complete_with_200() {
        expectResult(.success(makeValidData()), when: (data: makeValidData(), response: makeHttpResponse(), error: nil))
    }
    
    func test_post_should_complete_with_no_data_when_request_complete_with_204() {
        expectResult(.success(nil), when: (data: nil, response: makeHttpResponse(statusCode: 204), error: nil))
        expectResult(.success(nil), when: (data: makeEmptyData(), response: makeHttpResponse(statusCode: 204), error: nil))
        expectResult(.success(nil), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 204), error: nil))
    }
    
    func test_post_should_complete_with_wrror_when_request_complete_with_no_200() {
        
        for statusCode in 404...499 {
            expectResult(.failure(.badRequest), when: (data: makeValidData(), response: makeHttpResponse(statusCode: statusCode), error: nil))
        }
        
        for statusCode in 500...599 {
            expectResult(.failure(.serverError), when: (data: makeValidData(), response: makeHttpResponse(statusCode: statusCode), error: nil))
        }
        
        for statusCode in 100...199 {
            expectResult(.failure(.noConnectivity), when: (data: makeValidData(), response: makeHttpResponse(statusCode: statusCode), error: nil))
        }
        
        for statusCode in 300...399 {
            expectResult(.failure(.noConnectivity), when: (data: makeValidData(), response: makeHttpResponse(statusCode: statusCode), error: nil))
        }
        
        expectResult(.failure(.badRequest), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 400), error: nil))
        expectResult(.failure(.badRequest), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 402), error: nil))
        expectResult(.failure(.unauthorized), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 401), error: nil))
        expectResult(.failure(.forbidden), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 403), error: nil))
        
    }
}

extension AlamofireAdapterTest {
    func makeSut (file: StaticString = #filePath, line: UInt = #line) -> (sut: AlamofireAdapter, session: Session) {
        //Esse trecho de código está definindo que a session usada para fazer as requisições no AlamofireAdapter não será a .default e sim uma nova session com as configurações definidas para que toda requisição feita usando ela seja interceptada por URLProtocolStub
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = Session(configuration: configuration)
        let sut = AlamofireAdapter(session: session)
        checkMemoryLeak(for: sut, file: file, line: line)
        return (sut: sut, session: session)
    }
    
    func testRequestFor(url: URL = makeUrl(), data: Data?, action: @escaping (URLRequest) -> Void) {
        let sut = makeSut().sut
        let exp = expectation(description: "completion to add remote account should response until 1 second")
        sut.post(to: url, with: data){_  in exp.fulfill() }
        var request: URLRequest?
        
        //Estamos chamando exp.fulfill na closure de post e capturando a request e executando após o wait por que se fossem executados na request abaixo poderiam causar data racing
        URLProtocolStub.observeRequest { request = $0 }
        wait(for: [exp], timeout: 1)
        action(request!)
    }
    
    func expectResult(_ expectedResult: Result<Data?, HttpError>, when stub: (data: Data?, response: HTTPURLResponse?, error: Error?), file: StaticString = #filePath, line: UInt = #line) {
        let sut = makeSut().sut
        URLProtocolStub.simulate(data: stub.data, response: stub.response, error: stub.error)
        let exp = expectation(description: "completion to add remote account should response until 1 second")
        
        sut.post(to: makeUrl(), with: makeValidData()){ receivedResult in
            switch (expectedResult, receivedResult) {
            case (.failure(let expectedError), .failure(let receivedError)): XCTAssertEqual(expectedError, receivedError, file: file, line: line)
            case (.success(let expectedData), .success(let receivedData)): XCTAssertEqual(expectedData, receivedData, file: file, line: line)
            default: XCTFail("Expected \(expectedResult), but received \(receivedResult) insted")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
}
