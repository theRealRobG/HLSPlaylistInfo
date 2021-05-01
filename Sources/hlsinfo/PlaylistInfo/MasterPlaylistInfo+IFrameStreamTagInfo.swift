import mamba

extension MasterPlaylistInfo {
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
}
