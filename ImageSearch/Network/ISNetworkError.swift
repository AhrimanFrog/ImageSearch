import Foundation

enum ISNetworkError: LocalizedError, Equatable {
    case networkProblem
    case invalidData
    case badRequest
    case badResponse
    case wrongStatusCode(Int)

    var errorDescription: String {
        return switch self {
        case .networkProblem: String(localized: "network_problem")
        case .badRequest: String(localized: "bad_request")
        case .invalidData: String(localized: "invalid_data")
        case .badResponse: String(localized: "bad_response")
        case .wrongStatusCode(let code): String(localized: "wrong_code_\(code)")
        }
    }

    var localizedDescription: String { errorDescription }
}
