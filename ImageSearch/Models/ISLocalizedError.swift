import Foundation

struct ISLocalizedError: LocalizedError {
    var errorDescription: String { localizedDescription }
}
