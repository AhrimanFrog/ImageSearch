protocol HeaderViewDelegate: AnyObject {
    var navigationHandler: NavigationHandler { get }
    func displayResults(of query: String)
}
