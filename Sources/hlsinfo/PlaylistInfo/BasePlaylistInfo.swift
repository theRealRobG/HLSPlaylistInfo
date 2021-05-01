import mamba

struct BasePlaylistInfo {
    let url: String
    let playlistType: String?
    let fileType: String
    let duration: TimeInterval?
    let masterInfo: MasterPlaylistInfo?
    
    init(playlist: HLSPlaylist) {
        url = playlist.url.absoluteString
        switch playlist.playlistType {
        case .event: playlistType = "Event"
        case .live: playlistType = "Live"
        case .unknown: playlistType = nil
        case .vod: playlistType = "VOD"
        }
        switch playlist.type {
        case .master:
            fileType = "Master"
            masterInfo = MasterPlaylistInfo(playlist: playlist)
        case .media:
            fileType = "Media"
            masterInfo = nil
        case .unknown:
            fileType = "Unknown"
            masterInfo = nil
        }
        let duration = playlist.duration.seconds
        if duration.isInfinite || duration.isNaN {
            self.duration = nil
        } else {
            self.duration = duration
        }
    }
}

extension BasePlaylistInfo: CustomStringConvertible {
    @DescriptionBuilder
    var description: String {
        "## \(url)"
        "## \(fileType) Playlist"
        body.indenting(by: 2)
    }
    
    @DescriptionBuilder
    private var body: String {
        if let playlistType = playlistType {
            "Type: \(playlistType)"
        }
        if let masterInfo = masterInfo {
            "\(masterInfo)".indenting(by: 2)
        }
        if let duration = duration {
            "Duration: \(duration)s (\(duration.formattedPlaybackTime()))"
        }
    }
}
