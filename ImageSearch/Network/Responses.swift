struct APIImagesResponse: Codable {
    let total: Int
    let hits: [ISImage]

    var query: String = ""

    enum CodingKeys: String, CodingKey {
        case total, hits
    }
}
