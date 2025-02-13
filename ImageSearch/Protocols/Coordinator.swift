protocol Coordinator {
    associatedtype NavigationDestination
    func start()
    func navigate(to: NavigationDestination)
    func handleError(with: String)
}
