import mamba

extension MasterPlaylistInfo {
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
            mediaDescription.indenting(by: 2)
        }
        
        @DescriptionBuilder
        private var mediaDescription: String {
            "Name: \(name)"
            if let language = language {
                "Language: \(language)"
            }
            if let url = url {
                "URL: \(url)"
            }
            if let instreamID = instreamID {
                "In Stream ID: \(instreamID)"
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
