enum FakeOptional<Wrapped> {
    case some(Wrapped)
    case none
}

extension FakeOptional {
    var realOptional: Wrapped? {
        switch self {
            case .some(let value):
                return value
            case .none:
                return nil
        }
    }
}

extension Optional {
    var fakeOptional: FakeOptional<Wrapped> {
        if let value = self {
            return .some(value)
        } else {
            return .none
        }
    }
}
