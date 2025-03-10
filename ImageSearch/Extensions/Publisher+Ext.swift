import Combine

extension Publisher where Failure == ISNetworkError {
    func sink(resultHandler: @escaping (Result<Output, Failure>) -> Void) -> AnyCancellable {
        return sink(
            receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error): resultHandler(.failure(error))
                }
            },
            receiveValue: { value in resultHandler(.success(value)) }
        )
    }
}

extension Publisher where Failure == Never {
    func void() -> AnyPublisher<Void, Never> {
        return self.map { _ in return }.eraseToAnyPublisher()
    }
}
