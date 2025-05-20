//
//  Legend.swift
//  MoodChart
//
//  Created by Manushri Rane on 5/6/25.
//
import SwiftUI

struct LegendChart: View {
    let emotions: [Emotion]
    
    var body: some View {
        HStack(spacing: 16) {
            ForEach(emotions, id: \.self) { emotion in
                    HStack(spacing: 6) {
                        Circle()
                            .fill(emotion.color)
                            .frame(width: 12, height: 12)
                        Text(emotion.rawValue)
                            .font(.caption)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
            }
        }
        .padding(.horizontal)
    }
}
