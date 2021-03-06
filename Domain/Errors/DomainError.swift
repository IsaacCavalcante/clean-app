import Foundation

public enum DomainError: Error {
    case unexpected
    case invalidData
    case emailInUse
    case sessionExpired
}
