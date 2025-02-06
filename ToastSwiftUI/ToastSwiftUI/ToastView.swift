//
//  ToastView.swift
//  ToastSwiftUI
//
//  Created by Jesus Antonio Gil on 6/2/25.
//

import SwiftUI

    
struct ToastView: View {
    let type: ToastType
    let onTapClose: () -> Void
    
    @State private var offsetY: CGFloat = .zero
    @State private var contectHeight: CGFloat = .zero
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                let translationY = value.translation.height
                offsetY = value.translation.height < 0 ? translationY * 0.1 : translationY
            }
            .onEnded { value in
                if value.translation.height < contectHeight / 2 {
                    withAnimation(.smooth(duration: 0.4, extraBounce: 0.25)) {
                        offsetY = .zero
                    }
                } else {
                    onTapClose()
                }
            }
    }
    
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Image(systemName: type.icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .foregroundStyle(type.titleColor)
                .font(.title2)
                .background {
                    Circle()
                        .fill(type.backgroundColor)
                        .frame(width: 35, height: 35)
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(type.title)
                    .font(.headline)
                    .lineLimit(1)
                    .foregroundStyle(type.titleColor)
                
                Text(type.description)
                    .font(.subheadline)
                    .lineLimit(1)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            Button(action: onTapClose) {
                Image(systemName: "xmark")
                    .foregroundStyle(.gray)
            }
        }
        .padding()
        .background {
            if colorScheme == .dark {
                return Color.init(uiColor: .tertiarySystemGroupedBackground)
            } else {
                return .white
            }
        }
        .cornerRadius(12)
        .padding(.horizontal)
        .shadow(color: colorScheme == .dark ? .clear : .black.opacity(0.15), radius: 15)
        .padding(.horizontal)
        .onGeometryChange(for: CGFloat.self) { proxy in
            proxy.size.height
        } action: { _, height in
            contectHeight = height
        }
        .offset(y: offsetY)
        .gesture(dragGesture)
    }
    
    
}


#Preview {
    @Previewable @State var isShowing: Bool = true
    
    VStack {
        if isShowing {
            ToastView(type: .success, onTapClose: {
                withAnimation(.smooth(duration: 0.4, extraBounce: 0.25)) {
                    isShowing.toggle()
                }
            })
            .transition(
                .move(edge: .bottom)
                .combined(with: .blurReplace)
            )
        }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.init(uiColor: .secondarySystemGroupedBackground))
}
