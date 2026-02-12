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
    
    // Define the display order
    private var allEmotions: [Emotion] {
        [.great, .okay, .meh, .nsg]  // <-- correct order
    }
    
    // Calculate angles based on ordered emotions
    var angles: [(Emotion, Double, Double)] {
        var start: Double = 0
        return allEmotions.map { emotion in
            let value = data[emotion] ?? 0
            let angle = Double(value) / Double(max(total, 1)) * 360
            let result = (emotion, start, start + angle)
            start += angle
            return result
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
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
    
    func formattedWeekStart() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return "WEEK OF \(formatter.string(from: weekStart))"
    }
}

// FixedLegend updated to match order
struct FixedLegend: View {
    private let emotions: [Emotion] = [.great, .okay, .meh, .nsg]

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
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
    }
}


struct DonutSlice: Shape {
    let startAngle: Angle
    let endAngle: Angle

    func path(in rect: CGRect) -> Path {
        var p = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        p.addArc(center: center,
                 radius: radius,
                 startAngle: startAngle - .degrees(90),
                 endAngle: endAngle - .degrees(90),
                 clockwise: false)

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
