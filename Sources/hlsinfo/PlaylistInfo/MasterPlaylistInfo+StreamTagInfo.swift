import mamba

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
}
