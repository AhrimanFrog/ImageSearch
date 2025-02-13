import Foundation
import Combine
import UIKit

class NetworkManager {
    private let endpoint = "https://pixabay.com/api/"
    private let decoder = JSONDecoder()
    private let cache = NSCache<NSString, UIImage>()
    private let apiKey: String

    init() {
        guard let key = (Bundle.main.infoDictionary?["API_KEY"] as? String), key != "<your_key>" else {
            fatalError("API key is not provided")
        }
        apiKey = key
    }

    func getImages(
        query: String,
        page: Int,
        userPreferences: Preferences
    ) -> AnyPublisher<APIImagesResponse, ISNetworkError> {
        guard let url = formURL(from: query, at: page, with: userPreferences) else {
            return Fail(error: ISNetworkError.badRequest).eraseToAnyPublisher()
        }
        return createPublisher(url: url)
            .decode(type: APIImagesResponse.self, decoder: decoder)
            .map { response in
                var copy = response
                copy.query = query
                return copy
            }
            .mapError { ($0 as? ISNetworkError) ?? .invalidData }
            .eraseToAnyPublisher()
    }

    func downloadImage(from resource: String) -> AnyPublisher<UIImage, Never> {
        let cacheKey = NSString(string: resource)
        if let cacheImage = cache.object(forKey: cacheKey) { return Just(cacheImage).eraseToAnyPublisher() }
        guard let url = URL(string: resource) else { return Just(UIImage.notFound).eraseToAnyPublisher() }
        return createPublisher(url: url)
            .map { [weak self] data in
                guard let uiImage = UIImage(data: data) else { return .notFound }
                self?.cache.setObject(uiImage, forKey: cacheKey)
                return uiImage
            }
            .replaceError(with: .notFound)
            .eraseToAnyPublisher()
    }

    private func createPublisher(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else { throw ISNetworkError.badResponse }
                guard httpResponse.statusCode == 200 else {
                    throw ISNetworkError.wrongStatusCode(httpResponse.statusCode)
                }
                return data
            }
            .eraseToAnyPublisher()
    }

    private func formURL(from query: String, at page: Int, with preferences: Preferences) -> URL? {
        var urlComponents = URLComponents(string: endpoint)
        let baseQueryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "q", value: query.formattedForQuery),
            URLQueryItem(name: "page", value: String(page))
        ]
        let formattedPreferences = preferences.asDict.compactMap {
            $0.value == nil ? nil : URLQueryItem(name: $0.key, value: $0.value)
        }
        urlComponents?.queryItems = baseQueryItems + formattedPreferences
        return urlComponents?.url
    }
}
