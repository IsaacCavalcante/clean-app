import Foundation
import Domain

func makeValidData() -> Data {
    return Data("{\"name\": \"any-name\"}".utf8)
}

func makeInvalidData() -> Data {
    return Data("invalidData".utf8)
}

func makeEmptyData() -> Data {
    return Data()
}

func makeUrl() -> URL {
    return URL(string: "https://any-url.com")!
}

func makeError() -> Error {
    return NSError(domain: "Any Error", code: 0)
}

func makeHttpResponse(statusCode: Int = 200) -> HTTPURLResponse {
    return HTTPURLResponse(url: makeUrl(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
}

func makeAddAccountModel() -> AddAccountModel {
    return AddAccountModel(name: "Isaac Cavalcante", email: "any@mail.com", password: "password", passwordConfirmation: "password")
}
