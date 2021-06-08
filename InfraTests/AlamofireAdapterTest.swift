import XCTest
import Alamofire

class AlamofireAdapterTest: XCTestCase {
    
    class AlamofireAdapter {
        private let session: Session
        
        init(session: Session = .default) {
            self.session = session
        }
        
        func post(to url: URL, completion: (Result<AnyObject,Error>) -> Void) {
            session.request(url, method: .post).resume()
        }
    }


    func test_() {
        let url = makeUrl()
        
        //Esse trecho de código está definindo que a session usada para fazer as requisições no AlamofireAdapter não será a .default e sim uma nova session com as configurações definidas para que toda requisição feita usando ela seja interceptada por URLProtocolStub
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = Session(configuration: configuration)
        let sut = AlamofireAdapter(session: session)
        
        sut.post(to: url){_  in }
        
        let exp = expectation(description: "completion to add remote account should response until 1 second")
        URLProtocolStub.observeRequest { request in
            XCTAssertEqual(url, request.url, "Url send to AlamofireAdapter is wrong")
            XCTAssertEqual("POST", request.httpMethod, "Http method calls by AlamofireAdapter is wrong")
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
    
    //Essa classe URLProtocol intercepta as requests que são feitas. Aqui usamos para testar as nossas requests
    class URLProtocolStub: URLProtocol {
        static var emit: ((URLRequest) -> Void)?
        
        static func observeRequest(completion: @escaping (URLRequest) -> Void) {
            URLProtocolStub.emit = completion
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
        }
        
        open override func stopLoading() {
            
        }

    }

}
