import Foundation
import mamba

struct MasterPlaylistInfo: CustomStringConvertible {
    let streamTags: [String: StreamTagInfo]
    let mediaTags: [HLSMediaType.Media: [MediaTagInfo]]
    let iFrameTags: [IFrameStreamTagInfo]
    
    @DescriptionBuilder
    var description: String {
        "### Main Streams"
        for stream in streamTags.sorted(by: { $0.key < $1.key }) {
            "\(stream.value)"
        }
        " "
        "### Media Tracks"
        for (_, media) in mediaTags.sorted(by: { $0.key.rawValue < $1.key.rawValue }) {
            for track in media.sorted(by: { $0.groupID < $1.groupID }) {
                "Group ID: \(track.groupID)"
                "\(track)"
            }
        }
        " "
        for iFrameStream in iFrameTags {
            "\(iFrameStream)"
        }
    }
    
    init(playlist: HLSPlaylist) {
        var streamTags = [String: StreamTagInfo]()
        var mediaTags = [HLSMediaType.Media: [MediaTagInfo]]()
        var iFrameTags = [IFrameStreamTagInfo]()
        for (index, tag) in playlist.tags.enumerated() {
            if tag.tagDescriptor == PantosTag.EXT_X_STREAM_INF {
                guard playlist.tags.indices.contains(index + 1), playlist.tags[index + 1].tagDescriptor == PantosTag.Location else {
                    continue
                }
                let url = playlist.tags[index + 1].tagData.stringValue()
                streamTags[url] = StreamTagInfo(url: url, hlsTag: tag)
            } else if tag.tagDescriptor == PantosTag.EXT_X_I_FRAME_STREAM_INF {
                IFrameStreamTagInfo(hlsTag: tag).map { iFrameTags.append($0) }
            } else if tag.tagDescriptor == PantosTag.EXT_X_MEDIA {
                MediaTagInfo(hlsTag: tag).map { mediaTags[$0.mediaType] == nil ? mediaTags[$0.mediaType] = [$0] : mediaTags[$0.mediaType]?.append($0) }
            }
        }
        self.streamTags = streamTags
        self.mediaTags = mediaTags
        self.iFrameTags = iFrameTags
    }
}
