//
//  DonutChart.swift
//  MoodChart
//
//  Created by Manushri Rane on 5/6/25.
//

import SwiftUI

// only do it based off of that particular week

struct DonutChart: View {
    let data: [Emotion: Int]
    let weekStart: Date
    
    var total: Int {
        data.values.reduce(0, +)
    }
    
    // Calculate angle for each emotion
    var angles: [(Emotion, Double, Double)] {
        var start: Double = 0
        return data.map { (emotion, value) in
            let angle = Double(value) / Double(max(total, 1)) * 360
            let result = (emotion, start, start + angle)
            start += angle
            return result
        }
    }
    
    // All emotions for empty state
    private var allEmotions: [Emotion] {
        [.great, .okay, .meh, .nsg]
    }
    
    // Construct pie chart
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                // If no data, show empty circle
                if data.isEmpty {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 40)
                        .frame(width: 200, height: 200)
                    Text("No mood data")
                        .font(.caption)
                        .foregroundColor(.gray)
                } else {
                    ForEach(angles, id: \.0) { (emotion, startAngle, endAngle) in
                        DonutSlice(startAngle: .degrees(startAngle), endAngle: .degrees(endAngle))
                            .fill(emotion.color)
                    }
                    Circle()
                        .fill(Color.white)
                        .frame(width: 100, height: 100)
                }
            }
            .frame(width: 200, height: 200)

            // Legend and week label, always centered and wrapped if needed
            VStack(spacing: 6) {
                // Legend
                FixedLegend()
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                // Week label
                Text(formattedWeekStart().uppercased())
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.top, 2)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(.horizontal, 8)
        }
    }
    
    // Set up date for our Week Of text using the passed-in weekStart
    func formattedWeekStart() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return "WEEK OF \(formatter.string(from: weekStart))"
    }
}

// Create slices of pie chart based on data
struct DonutSlice: Shape {
    let startAngle: Angle
    let endAngle: Angle

    func path(in rect: CGRect) -> Path {
        var p = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2

        // Create a donut shape rather than a pie slice
        p.addArc(center: center,
                 radius: radius,
                    startAngle: startAngle - .degrees(90),
                    endAngle: endAngle - .degrees(90),
                    clockwise: false)
        
        // Inner circle
        let innerRadius = radius * 0.5
        p.addArc(center: center,
                 radius: innerRadius,
                 startAngle: endAngle - .degrees(90),
                 endAngle: startAngle - .degrees(90),
                 clockwise: true)
        
        p.closeSubpath()
        return p
    }
}

// Helper view for a flexible, wrapping legend
struct FixedLegend: View {
    private let emotions: [Emotion] = [.great, .meh, .nsg, .okay]
    var body: some View {
        HStack(spacing: 16) {
            ForEach(emotions, id: \.self) { emotion in
                HStack(spacing: 5) {
                    Circle()
                        .fill(emotion.color)
                        .frame(width: 10, height: 10)
                    Text(emotion.rawValue)
                        .font(.custom("Alexandria-Regular", size: 13))
                        .foregroundColor(.black)
                        .fixedSize(horizontal: true, vertical: false)
                }
            }
        }
        .frame(maxWidth: 340)
        .padding(.top, 4)
        .padding(.bottom, 2)
        .multilineTextAlignment(.center)
    }
}
