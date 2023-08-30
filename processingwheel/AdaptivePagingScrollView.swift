//
//  AdaptivePagingScrollView.swift
//  bggenerator
//
//  Created by Andrii Bashta on 03.09.2022.
//

import SwiftUI

//TODO: - Two last items not selectable
struct AdaptivePagingScrollView: View {
  @Binding var currentPageIndex: Int
  
  @State private var currentScrollOffset: CGFloat = .zero
  @State private var gestureDragOffset: CGFloat = .zero
  
  private let items: [AnyView]
  private let itemPadding: CGFloat
  private let itemSpacing: CGFloat
  private let itemWidth: CGFloat
  private let itemsAmount: Int
  private let contentWidth: CGFloat
  private let leadingOffset: CGFloat
  private let scrollDampingFactor: CGFloat
  
  var body: some View {
    HStack(alignment: .center, spacing: itemSpacing) {
      ForEach(items.indices, id: \.self) { itemIndex in
        items[itemIndex].frame(width: itemWidth)
      }
    }
    .transparentTappable { $0 }
    .frame(width: contentWidth)
    .offset(x: currentScrollOffset, y: .zero)
    .simultaneousGesture(
      DragGesture(minimumDistance: 1, coordinateSpace: .local)
        .onChanged { value in
          gestureDragOffset = value.translation.width
          currentScrollOffset = countCurrentScrollOffset()
        }
        .onEnded { value in
          let cleanOffset = (value.predictedEndTranslation.width - gestureDragOffset)
          let velocityDiff = cleanOffset * scrollDampingFactor
          
          var newPageIndex = countPageIndex(for: currentScrollOffset + velocityDiff)
          
          let currentItemOffset = CGFloat(currentPageIndex) * (itemWidth + itemPadding)
          
          if currentScrollOffset < -(currentItemOffset),
             newPageIndex == currentPageIndex {
            newPageIndex += 1
          }
          
          gestureDragOffset = 0
          
          let mass: Double = 0.1
          let stiffness: Double = 20
          let damping: Double = 1.5
          let initialVelocity: Double = .zero
          
          withAnimation(.interpolatingSpring(mass: mass,
                                             stiffness: stiffness,
                                             damping: damping,
                                             initialVelocity: initialVelocity)) {
            self.currentPageIndex = newPageIndex
            
            //TODO: - Remove this custom logic
            if newPageIndex == 0 {
              self.currentPageIndex = 1
            }
            
            if newPageIndex == itemsAmount || newPageIndex == (itemsAmount + 1) {
              self.currentPageIndex = (itemsAmount - 1)
            }
            
            playHapticSuccess()
            
            self.currentScrollOffset = self.countCurrentScrollOffset()
          }
        }
    )
    .onAppear {
      currentScrollOffset = countOffset(for: currentPageIndex)
    }
  }
    
  init<A: View>(currentPageIndex: Binding<Int>,
                itemsAmount: Int,
                itemWidth: CGFloat,
                itemPadding: CGFloat,
                pageWidth: CGFloat,
                scrollDampingFactor: CGFloat = 0.01,
                @ViewBuilder content: () -> A) {
    
    let views = content()
    self.items = [AnyView(views)]
    
    self._currentPageIndex = currentPageIndex
    
    self.itemsAmount = itemsAmount
    self.itemSpacing = itemPadding
    self.itemWidth = itemWidth
    self.itemPadding = itemPadding
    self.contentWidth = (itemWidth+itemPadding)*CGFloat(itemsAmount)
    
    self.scrollDampingFactor = scrollDampingFactor
    
    let itemRemain = (pageWidth - itemWidth - (2 * itemPadding)) / 2
    self.leadingOffset = itemRemain + itemPadding
  }
  
  private func playHapticSuccess() {
    let generator = UIImpactFeedbackGenerator(style: .soft)
    generator.impactOccurred()
  }
  
  private func countOffset(for pageIndex: Int) -> CGFloat {
    let activePageOffset = CGFloat(pageIndex) * (itemWidth + itemPadding)
    return leadingOffset - activePageOffset
  }
  
  private func countPageIndex(for offset: CGFloat) -> Int {
    guard itemsAmount > 0 else { return .zero }
    
    let offset = countLogicalOffset(offset)
    let floatIndex = (offset)/(itemWidth + itemPadding)
    
    var index = Int(round(floatIndex))
    
    if max(index, 0) > itemsAmount {
      index = itemsAmount
    }
    
    return min(max(index, 0), itemsAmount - 1)
  }
  
  private func countCurrentScrollOffset() -> CGFloat {
    countOffset(for: currentPageIndex) + gestureDragOffset
  }
  
  private func countLogicalOffset(_ trueOffset: CGFloat) -> CGFloat {
    (trueOffset-leadingOffset) * -1
  }
}
