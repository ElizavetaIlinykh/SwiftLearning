final class AppDependencies {
    let networkManager: NetworkManaging

    init(networkManager: NetworkManaging = NetworkManager()) {
        self.networkManager = networkManager
    }
}
