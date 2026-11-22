import Foundation

enum APIConfigError: Error, LocalizedError {
    case fileNotFound
    case dataLoadingFailed(underlyingError: Error)
    case decodingFailed(underlyingError: Error)
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "API configuration files not found"
        case .dataLoadingFailed(underlyingError: let error):
            return "Fail to load the data from the API config file: \(error.localizedDescription)"
        case .decodingFailed(underlyingError: let error):
            return "Failed to decode the API Config file: \(error.localizedDescription)"
        }
    }
}

enum NetworkError: Error, LocalizedError {
    case badURLResponse(underlyingError: Error)
    case missingConfiguration
    case URLBuildFailed
    
    var errorDescription: String? {
        switch self {
        case .badURLResponse(underlyingError: let error):
            return "Bad URL Response: \(error.localizedDescription)"
        case .missingConfiguration:
            return "Missing API configuration"
        case .URLBuildFailed:
            return "Failed to build the URL"
        }
    }
}
