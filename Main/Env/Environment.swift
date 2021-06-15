import Foundation

public final class Environment {
    
    public enum EnvironmentVariable: String {
        case apiBaseUrl = "API_BASE_URL"
    }
    
    public static func variable(_ key: EnvironmentVariable) -> String {
        return Bundle.main.infoDictionary![key.rawValue] as! String
    }
}
