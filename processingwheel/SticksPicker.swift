//
//  SticksPicker.swift
//  processingwheel
//
//  Created by Bashta on 30.08.2023.
//

import SwiftUI

struct SticksPicker: View {
    @Binding var activePageIndex: Int
    
    let pages: Int
    let item: CGSize = CGSize(width: 2, height: 20)
    let itemPadding: CGFloat = 16
    let instrumentHeight: CGFloat = 20
    let longLineSize: CGSize = .init(width: 2, height: 52)
    let longLineOffset: CGSize = .init(width: -3, height: 0)
    let viewHeight: CGFloat = 52
    
    var body: some View {
        ZStackLayout {
            VStackLayout(spacing: .zero) {
                Spacer()
                Instrument
                    .frame(height: instrumentHeight)
            }
            Rectangle()
            //.fill(activePageIndex > 1 ? Color.accentColor : Color.primary) // Use it if zero value should be shown and need display it to user
                .fill(Color.accentColor)
                .frame(width: longLineSize.width, height: longLineSize.height)
                .offset(x: longLineOffset.width, y: longLineOffset.height)
        }
        .frame(height: viewHeight
        )
    }
    
    var Instrument: some View {
        GeometryReader { geometry in
            AdaptivePagingScrollView(currentPageIndex: self.$activePageIndex, itemsAmount: self.pages - 1, itemWidth: self.item.width, itemPadding: self.itemPadding, pageWidth: geometry.size.width) {
                ForEach(0...pages, id: \.self) { card in
                    Rectangle()
                        .fill(card % 10 == .zero ? Color.primary: Color.gray)
                        .frame(width: self.item.width, height: self.item.height)
                    //.opacity(card == .zero || card == (pages - 1) || card == pages ? .zero : 1)
                }
            }
            .padding(.leading, 4)
        }
    }
    
    private func scroll(to position: ScrollViewProxy, index: Int) {
        position.scrollTo(index, anchor: .center)
    }
}

struct SticksPicker_Previews: PreviewProvider {
    static var previews: some View {
        SticksPicker(activePageIndex: .constant(0), pages: 38)
    }
}
