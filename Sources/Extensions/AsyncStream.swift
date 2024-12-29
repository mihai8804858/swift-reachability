extension AsyncSequence {
    public func eraseToStream() -> AsyncStream<Element> {
        AsyncStream(self)
    }
}

extension AsyncStream {
    public init<S: AsyncSequence>(_ sequence: S) where S.Element == Element {
        nonisolated(unsafe) let sequence = sequence
        nonisolated(unsafe) var iterator: S.AsyncIterator?
        self.init {
            if iterator == nil { iterator = sequence.makeAsyncIterator() }
            return try? await iterator?.next()
        }
    }
}
