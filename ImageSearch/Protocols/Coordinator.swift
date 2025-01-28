protocol Coordinator {
    var children: [any Coordinator] { get }

    func start()
}
