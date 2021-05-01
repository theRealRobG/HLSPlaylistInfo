struct Version: CustomStringConvertible {
    let major: Int
    let minor: Int
    let revision: Int
    
    var description: String {
        "v\(major).\(minor).\(revision)"
    }
    
    static let current = Version(major: 0, minor: 1, revision: 0)
}
