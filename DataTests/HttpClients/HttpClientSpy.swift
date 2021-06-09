import Foundation
import Data

class HttpClientSpy: HttpPostClient {
    var url: URL?
    var data: Data?
    var callsCounter = 0
    var completion: ((Result<Data?, HttpError>) -> Void)?
    
    func post(to url: URL, with data: Data?, completion: @escaping (Result<Data?, HttpError>) -> Void) {
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
