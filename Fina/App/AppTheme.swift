import SwiftUI

enum AppColors {
    // Brand
    static let primary     = Color(hex: "EA580C")  // Orange 600

    // Semantic
    static let income      = Color(hex: "16A34A")  // Green 600
    static let expense     = Color(hex: "DC2626")  // Red 600
    static let warning     = Color(hex: "D97706")  // Amber 600

    // Dark mode variants are handled automatically via
    // Color(nsColor: .windowBackgroundColor) or custom asset catalog entries
}

// Hex color initializer — Swift 5.9 compatible
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: Double
        r = Double((int >> 16) & 0xFF) / 255
        g = Double((int >>  8) & 0xFF) / 255
        b = Double( int        & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
