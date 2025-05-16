import SwiftUI

// Assign colors to moods
enum Emotion: String, Hashable {
    case great = "Great 😄"
    case okay = "Okay 🙂"
    case meh = "Meh 😐"
    case nsg = "Not so good 😞"
    
    var color: Color {
        switch self {
        case .great: return Color(red: 252/255, green: 217/255, blue: 167/255)
        case .okay: return Color(red: 100/255, green: 142/255, blue: 203/255)
        case .meh: return Color(red: 255/255, green: 182/255, blue: 193/255)
        case .nsg: return Color(red: 207/255, green: 227/255, blue: 194/255)
        }
    }
}

// Define moods
enum Mood: String, CaseIterable {
    case great = "Great 😄"
    case okay = "Okay 🙂"
    case meh = "Meh 😐"
    case nsg = "Not so good 😞"
    
    var emotion: Emotion {
        switch self {
        case .great: return .great
        case .okay: return .okay
        case .meh: return .meh
        case .nsg: return .nsg
        }
    }
}

// Keep track of mood and date to input into pie chart
struct MoodEntry {
    let date: Date
    let mood: Mood
}

// Function to only retrieve last week's data starting from Sunday
func entriesFromCurrentWeek(_ entries: [MoodEntry]) -> [MoodEntry] {
    let currCalendar = Calendar.current
    let now = Date()
    
    // Find most recent Sunday
    guard let lastSunday = currCalendar.date(from: currCalendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)) else {
        return []
    }

    return entries.filter { entry in
        entry.date >= lastSunday && entry.date <= now
    }
}

// Count # of each emotion to make pie chart
func emotionDistribution(from entries: [MoodEntry]) -> [Emotion: Int] {
    var counts: [Emotion: Int] = [:]
    for entry in entries {
        let emotion = entry.mood.emotion
        counts[emotion, default: 0] += 1
    }
    return counts
} 