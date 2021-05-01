extension String {
    func indenting(by n: Int) -> String {
        let space = (0..<n).map { _ in " " }.joined()
        return space + self.replacingOccurrences(of: "\n", with: "\n\(space)")
    }
}
