import Foundation

enum LoadingState<Value: Equatable>: Equatable {
    case idle
    case loading
    case loaded(Value)
    case failed(String)
}
