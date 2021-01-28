//
//  BottomSheetView.swift
//  Recex
//
//  Created by "Mecid"
//  Source Code: https://gist.github.com/mecid/78eab34d05498d6c60ae0f162bfd81ee
//
import Foundation
import SwiftUI

fileprivate enum Constants {
    static let radius: CGFloat = 16
    static let indicatorHeight: CGFloat = 6
    static let indicatorWidth: CGFloat = 60
    static let snapRatio: CGFloat = 0.25
    static let minHeightRatio: CGFloat = 0.3
}

struct BottomSheetView<Content: View>: View {
    @Binding var isOpen: Bool

    let maxHeight: CGFloat
    let minHeight: CGFloat
    let content: Content

    @GestureState private var translation: CGFloat = 0

    private var offset: CGFloat {
        isOpen ? 0 : maxHeight - minHeight
    }

    private var indicator: some View {
        RoundedRectangle(cornerRadius: Constants.radius)
            .fill(Color.secondary)
            .frame(
                width: Constants.indicatorWidth,
                height: Constants.indicatorHeight
        ).onTapGesture {
            self.isOpen.toggle()
        }
    }

    init(isOpen: Binding<Bool>, maxHeight: CGFloat, minHeightRatio: CGFloat?, @ViewBuilder content: () -> Content) {
        self.minHeight = (minHeightRatio != nil) ? maxHeight * minHeightRatio! : maxHeight * Constants.minHeightRatio
        self.maxHeight = maxHeight
        self.content = content()
        self._isOpen = isOpen
    }

    var body: some View {
        ZStack {
            Color.gray.opacity(self.isOpen ? 0.3 : 0).ignoresSafeArea(.all).edgesIgnoringSafeArea(.all)
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    Divider()
                    self.indicator.padding()
                        .background(Color(.secondarySystemBackground))
                        .frame(width: geometry.size.width)
                    self.content
                        .background(Color.white)
                }
                .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
                .background(Color.white)
                .cornerRadius(Constants.radius)
                .frame(height: geometry.size.height, alignment: .bottom)
                .offset(y: max(self.offset + self.translation, 0))
                .animation(.interactiveSpring())
                .gesture(
                    DragGesture().updating(self.$translation) { value, state, _ in
                        state = value.translation.height
                    }.onEnded { value in
                        let snapDistance = self.maxHeight * Constants.snapRatio
                        guard abs(value.translation.height) > snapDistance else {
                            return
                        }
                        self.isOpen = value.translation.height < 0
                    }
                )
            }
        }
    }
}
