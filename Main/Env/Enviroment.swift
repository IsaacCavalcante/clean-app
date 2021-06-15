import Foundation

public final class Enviroment {
    
    public enum EnviromentVariable: String {
        case apiBaseUrl = "API_BASE_URL"
    }
    
    public static func variable(_ key: EnviromentVariable) -> String {
        return Bundle.main.infoDictionary![key.rawValue] as! String
    }
}
