struct ISImage: Codable {
    let id: Int
    let tags: String
    let previewURL: String
    let largeImageURL: String

    var formattedTags: [String] { tags.split(separator: ",").map { String($0) } }
}
