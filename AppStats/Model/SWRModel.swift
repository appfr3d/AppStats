enum SWRState<T> {
    case notInitialized
    case fetching
    case revalidating(data: T)
    case success(data: T)
    case error(error: Error)
}
