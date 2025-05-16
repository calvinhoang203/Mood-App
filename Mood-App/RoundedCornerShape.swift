import SwiftUI
import UIKit

// Utility extension for applying rounded corners to specific corners of a view
public extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCornerShape(radius: radius, corners: corners))
    }
}

// Custom shape that allows for rounded corners on specific sides
public struct RoundedCornerShape: Shape {
    public var radius: CGFloat = .infinity
    public var corners: UIRectCorner = .allCorners
    
    public init(radius: CGFloat = .infinity, corners: UIRectCorner = .allCorners) {
        self.radius = radius
        self.corners = corners
    }

    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
} 