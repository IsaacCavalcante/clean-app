import Foundation

public extension Data {
    
    // como é uma linha não preciso colocar o "return"
    func toModel<T: Decodable>() -> T? {
        try? JSONDecoder().decode(T.self, from: self)
    }
    
    // como é uma linha não preciso colocar o "return"
    func toJson() -> [String: Any]? {
        try? JSONSerialization.jsonObject(with: self, options: .allowFragments) as? [String:Any]
    }
}
