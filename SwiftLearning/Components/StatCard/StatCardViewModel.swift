struct StatCardViewModel: Identifiable {
    let id: String
    let title: String
    let value: String
    let systemImage: String

    init(title: String, value: String, systemImage: String) {
        id = title
        self.title = title
        self.value = value
        self.systemImage = systemImage
    }
}
