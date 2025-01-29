import Foundation

enum ISNetworkError: LocalizedError, Equatable {
    case networkProblem(String)
    case invalidData
    case badRequest
    case badResponse
    case wrongStatusCode(Int)

    var errorDescription: String {
        return switch self {
        case .networkProblem(let description): "Cannot send request.\n\(description)"
        case .badRequest: "Cannot fetch data. Bad request"
        case .invalidData: "Cannot form request. Invalid data input"
        case .badResponse: "Cannot convert data, try again"
        case .wrongStatusCode(let code): "Wrong status code recieved - \(code). Cannot convert data"
        }
    }
}
