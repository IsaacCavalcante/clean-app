import Foundation

func makeInvalidData() -> Data {
    return Data("invalidData".utf8)
}

func makeUrl() -> URL {
    return URL(string: "https://any-url.com")!
}
