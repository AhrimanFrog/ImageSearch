extension String {
    var formattedForQuery: String {
        let withoutWhitespaces = self.replacingOccurrences(of: " ", with: "+")
        return withoutWhitespaces.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
}
