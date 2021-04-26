import Foundation
import ArgumentParser

struct HLSInfo: ParsableCommand {
    @Argument(help: "The URL for a HLS playlist (master or media)")
    var url: String
    
    mutating func run() throws {
        guard let url = URL(string: self.url) else { throw HLSInfoError.invalidURL(self.url) }
        var hlsInfoError: HLSInfoError?
        let semaphore = DispatchSemaphore(value: 0)
        let playlistDownloader = PlaylistDownloader()
        playlistDownloader.getPlaylist(url: url) { result in
            switch result {
            case .failure(let downloadError):
                hlsInfoError = downloadError
            case .success(let playlist):
                print(PlaylistInfo(playlist: playlist))
            }
            semaphore.signal()
        }
        semaphore.wait()
        if let error = hlsInfoError {
            throw error
        }
    }
}

HLSInfo.main()
