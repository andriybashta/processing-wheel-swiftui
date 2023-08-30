//
//  View.swift
//  processingwheel
//
//  Created by Bashta on 30.08.2023.
//

import SwiftUI

public extension View {
    // Allows gesture recognizing even when background is transparent
    @ViewBuilder
    func transparentTappable<Content: View>(content: (Self) -> Content) -> some View {
        content(self)
            .background(Color.black.opacity(0.00001))
    }
}


