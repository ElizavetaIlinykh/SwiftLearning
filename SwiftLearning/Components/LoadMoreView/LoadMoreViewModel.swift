struct LoadMoreViewModel {
    let state: LoadMoreView.State
    let retryTitle: String

    init(
        state: LoadMoreView.State,
        retryTitle: String = L10n.string("common.tryAgain")
    ) {
        self.state = state
        self.retryTitle = retryTitle
    }
}
