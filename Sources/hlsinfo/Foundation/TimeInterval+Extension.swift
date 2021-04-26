import Foundation

extension TimeInterval {
    func formattedPlaybackTime() -> String {
        let secondsPerMinute = 60
        let minutesPerHour = 60
        let secondsPerHour = secondsPerMinute * minutesPerHour
        let absoluteSelf = abs(self)
        let hours = Int(absoluteSelf) / secondsPerHour
        let minutes = Int(absoluteSelf) / secondsPerMinute % minutesPerHour
        let seconds = Int(absoluteSelf) % secondsPerMinute
        return String(format: "\(self < 0 ? "-" : "")%02i:%02i:%02i", hours, minutes, seconds)
    }
}
