import Foundation

public protocol Model: Codable, Equatable { }

public extension Model {
    
    // como é uma linha não preciso colocar o "return"
    func toData() -> Data?{
        try? JSONEncoder().encode(self)
    }
    
    func toJson() -> [String: Any]?{
        guard let data = self.toData() else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
    }
}
