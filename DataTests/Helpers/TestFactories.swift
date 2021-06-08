import Foundation

func makeValidData() -> Data {
    return Data("{\"name\": \"any-name\"}".utf8)
}

func makeInvalidData() -> Data {
    return Data("invalidData".utf8)
}

func makeUrl() -> URL {
    return URL(string: "https://any-url.com")!
}

func makeError() -> Error {
    return NSError(domain: "Any Error", code: 0)
}
