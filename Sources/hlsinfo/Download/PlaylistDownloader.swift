import Foundation
import mamba

class PlaylistDownloader {
    private let urlSession: URLSession
    private let hlsParser: HLSParser
    private var dataTask: URLSessionDataTask?
    
    init(urlSession: URLSession = .shared, hlsParser: HLSParser = HLSParser()) {
        self.urlSession = urlSession
        self.hlsParser = hlsParser
    }
    
    func getPlaylist(url: URL, completion: @escaping (Result<HLSPlaylist, HLSInfoError>) -> Void) {
        dataTask = urlSession.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            if let error = error {
                completion(.failure(.playlistDownloadError(error)))
                return
            }
            if let response = response as? HTTPURLResponse, response.statusCode >= 400 {
                completion(.failure(.playlistDownloadBadStatusCode(response.statusCode)))
                return
            }
            guard let data = data, data.count > 0 else {
                completion(.failure(.playlistDownloadEmptyData))
                return
            }
            do {
                let playlist = try self.hlsParser.parse(playlistData: data, url: url)
                completion(.success(playlist))
                
            } catch {
                completion(.failure(.playlistDownloadParseError(error)))
            }
        }
        dataTask?.resume()
    }
}
