import mamba

struct PlaylistInfo {
    let baseInfo: BasePlaylistInfo
    
    init(playlist: HLSPlaylist) {
        baseInfo = BasePlaylistInfo(playlist: playlist)
    }
}

extension PlaylistInfo: CustomStringConvertible {
    @DescriptionBuilder
    var description: String {
        "# HLSPlaylistInfo \(Version.current)"
        " "
        "\(baseInfo)"
        " "
    }
}
