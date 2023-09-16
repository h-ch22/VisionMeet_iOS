//
//  VisionMeetApp.swift
//  VisionMeet
//
//  Created by Ha Changjin on 9/17/23.
//

import SwiftUI

@main
struct VisionMeetApp: App {
    var body: some Scene {
        WindowGroup {
            TabManager()
        }
    }
}

extension Color{
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(stops: [
            .init(color: Color.backgroundGradientStart, location: 0),
            .init(color: Color.backgroundGradientMid, location: 0.4),
            .init(color: Color.backgroundGradientEnd, location: 0.8)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

extension View {
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}
