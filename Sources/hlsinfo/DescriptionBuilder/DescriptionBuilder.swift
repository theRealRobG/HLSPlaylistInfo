@resultBuilder
struct DescriptionBuilder {
    static func buildBlock(_ components: String...) -> String {
        return components
            .filter { !$0.isEmpty }
            .joined(separator: "\n")
    }
    
    static func buildEither(first component: String) -> String {
        return component
    }
    
    static func buildEither(second component: String) -> String {
        return component
    }
    
    static func buildOptional(_ component: String?) -> String {
        return component ?? ""
    }
    
    static func buildArray(_ components: [String]) -> String {
        return components.joined(separator: "\n")
    }
}
