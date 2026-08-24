struct LoadMoreViewModel {
    let state: LoadMoreView.State
    let retryTitle: String

    init(
        state: LoadMoreView.State,
        retryTitle: String = "Try Again"
    ) {
        self.state = state
        self.retryTitle = retryTitle
    }
}
