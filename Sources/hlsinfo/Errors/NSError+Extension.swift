import Foundation

extension NSError {
    var extendedErrorCode: String {
        var codes = ["\(code)"]
        var underlyingError = userInfo[NSUnderlyingErrorKey] as? NSError
        while let error = underlyingError {
            codes.append("\(error.code)")
            underlyingError = error.userInfo[NSUnderlyingErrorKey] as? NSError
        }
        return codes.joined(separator: ":")
    }
    
    var extendedErrorDescription: String {
        "(\(extendedErrorCode)) \(localizedDescription)."
    }
}
