import Foundation

public protocol Model: Codable, Equatable { }

public extension Model {
    
    // como é uma linha não preciso colocar o "return"
    func toData() -> Data?{
        try? JSONEncoder().encode(self)
    }
}
