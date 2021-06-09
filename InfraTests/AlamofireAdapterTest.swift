import XCTest
import Alamofire
import Data

class AlamofireAdapterTest: XCTestCase {
    
    class AlamofireAdapter {
        private let session: Session
        
        init(session: Session = .default) {
            self.session = session
        }
        
        func post(to url: URL, with data: Data? ,completion: @escaping (Result<Data,HttpError>) -> Void) {
            session.request(url, method: .post, parameters: data?.toJson(), encoding: JSONEncoding.default).responseData { dataResponse in
                
                //se não houver um data e um response, mas não houver um error não deve ser considerado um caso válido
                guard (dataResponse.response?.statusCode) != nil else {
                    return completion(.failure(.noConnectivity))
                }
                
                switch dataResponse.result {
                case .failure: completion(.failure(.noConnectivity))
                case .success(let data): completion(.success(data))
                }
            }
        }
    }

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
    
    func expectResult(_ expectedResult: Result<Data, HttpError>, when stub: (data: Data?, response: HTTPURLResponse?, error: Error?), file: StaticString = #filePath, line: UInt = #line) {
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

//Essa classe URLProtocol intercepta as requests que são feitas. Aqui usamos para testar as nossas requests
class URLProtocolStub: URLProtocol {
    static var emit: ((URLRequest) -> Void)?
    static var data: Data?
    static var response: HTTPURLResponse?
    static var error: Error?
    
    static func observeRequest(completion: @escaping (URLRequest) -> Void) {
        URLProtocolStub.emit = completion
    }
    
    static func simulate(data: Data?, response: HTTPURLResponse?, error: Error?) {
        URLProtocolStub.data = data
        URLProtocolStub.response = response
        URLProtocolStub.error = error
    }
    
    open override class func canInit(with request: URLRequest) -> Bool {
        //return true define que todas as urls requisitadas serão interceptadas
        return true
    }
    
    open override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    open override func startLoading() {
        URLProtocolStub.emit?(request)
        
        if let data = URLProtocolStub.data {
            client?.urlProtocol(self, didLoad: data)
        }
        
        if let response = URLProtocolStub.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        
        if let error = URLProtocolStub.error {
            client?.urlProtocol(self, didFailWithError: error)
        }
        client?.urlProtocolDidFinishLoading(self)
    }
    
    open override func stopLoading() {
        
    }
}
