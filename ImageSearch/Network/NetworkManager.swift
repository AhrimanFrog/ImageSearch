import Foundation
import Combine

class NetworkManager {
    private let endpoint = "https://pixabay.com/api/"
    private let decoder = JSONDecoder()
    private let apiKey: String

    init() {
        guard let key = (Bundle.main.infoDictionary?["API_KEY"] as? String), key != "<your_key>" else {
            fatalError("API key is not provided")
        }
        apiKey = key
    }

    func getImages(query: String, userPreferences: Preferences) -> AnyPublisher<ISImage, ISNetworkError> {
        let url = formURL(from: query, with: userPreferences)
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else { throw ISNetworkError.badResponse }
                guard httpResponse.statusCode == 200 else {
                    throw ISNetworkError.wrongStatusCode(httpResponse.statusCode)
                }
                return data
            }
            .decode(type: ISImage.self, decoder: decoder)
            .mapError { ($0 as? ISNetworkError) ?? .invalidData }
            .eraseToAnyPublisher()
    }

    private func formURL(from query: String, with preferences: Preferences) -> URL {
        var urlComponents = URLComponents(string: endpoint)
        let baseQueryItems = [
            URLQueryItem(name: "key", value: apiKey), URLQueryItem(name: "q", value: query.formattedForQuery)
        ]
        let formattedPreferences = preferences.asDict.map { URLQueryItem(name: $0.key, value: $0.value) }
        urlComponents?.queryItems = baseQueryItems + formattedPreferences
        return urlComponents!.url!
    }
}
