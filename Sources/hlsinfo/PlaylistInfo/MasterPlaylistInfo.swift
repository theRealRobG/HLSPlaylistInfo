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

extension MasterPlaylistInfo {
    struct StreamTagInfo: CustomStringConvertible {
        let url: String
        let resolution: String?
        
        @DescriptionBuilder
        var description: String {
            "URL: \(url)"
            if let resolution = resolution {
                "  Resolution: \(resolution)"
            }
        }
        
        init(url: String, hlsTag: HLSTag) {
            self.url = url
            self.resolution = hlsTag.value(.resolution)
        }
    }
    
    struct IFrameStreamTagInfo: CustomStringConvertible {
        let url: String
        let resolution: String?
        
        @DescriptionBuilder
        var description: String {
            "URL: \(url)"
            if let resolution = resolution {
                "  Resolution: \(resolution)"
            }
        }
        
        init?(hlsTag: HLSTag) {
            guard let url = hlsTag.value(.uri) as String? else { return nil }
            self.url = url
            self.resolution = hlsTag.value(.resolution)
        }
    }
    
    struct MediaTagInfo: CustomStringConvertible {
        let mediaType: HLSMediaType.Media
        let groupID: String
        let type: String
        let name: String
        let language: String?
        let url: String?
        let instreamID: String?
        
        @DescriptionBuilder
        var description: String {
            "Type: \(type)"
            "  Name: \(name)"
            if let language = language {
                "  Language: \(language)"
            }
            if let url = url {
                "  URL: \(url)"
            }
            if let instreamID = instreamID {
                "  In Stream ID: \(instreamID)"
            }
        }
        
        init?(hlsTag: HLSTag) {
            guard
                hlsTag.tagDescriptor == PantosTag.EXT_X_MEDIA,
                let groupID = hlsTag.value(.groupId) as String?,
                let type = hlsTag.value(.type) as HLSMediaType?,
                let name = hlsTag.value(.name) as String?
            else {
                return nil
            }
            self.mediaType = type.type
            self.groupID = groupID
            self.type = type.type.rawValue
            self.name = name
            self.language = hlsTag.value(.language)
            self.url = hlsTag.value(.uri)
            self.instreamID = hlsTag.value(.instreamId)
        }
    }
}
