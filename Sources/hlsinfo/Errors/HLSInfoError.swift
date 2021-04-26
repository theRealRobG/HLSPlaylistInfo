import Foundation

enum HLSInfoError: CustomNSError, LocalizedError {
    case invalidURL(String)
    case playlistDownloadError(Error)
    case playlistDownloadBadStatusCode(Int)
    case playlistDownloadEmptyData
    case playlistDownloadParseError(Error)
    
    static var errorDomain: String { "HLSInfoError" }
    
    var errorDescription: String? {
        switch self {
        case .invalidURL(let url):
            return "The input URL (\(url)) was invalid."
        case .playlistDownloadError(let error as NSError):
            return error.extendedErrorDescription
        case .playlistDownloadBadStatusCode(let statusCode):
            return "Request failed with status code \(statusCode)."
        case .playlistDownloadEmptyData:
            return "Request returned no data."
        case .playlistDownloadParseError(let error as NSError):
            return error.extendedErrorDescription
        }
    }
    
    var errorCode: Int {
        switch self {
        case .invalidURL: return 100
        case .playlistDownloadError: return 200
        case .playlistDownloadBadStatusCode: return 201
        case .playlistDownloadEmptyData: return 202
        case .playlistDownloadParseError: return 203
        }
    }
}
