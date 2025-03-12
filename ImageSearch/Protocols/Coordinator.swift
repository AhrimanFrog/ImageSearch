protocol Coordinator {
    associatedtype NavigationDestination
    func start()
    func navigate(to: NavigationDestination) // swiftlint:disable:this identifier_name
    func handleError(with: String)
}
