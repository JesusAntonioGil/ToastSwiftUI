//
//  AnimatedToastView.swift
//  ToastSwiftUI
//
//  Created by Jesus Antonio Gil on 6/2/25.
//

import SwiftUI


struct AnimatedToastView: View {
    @State private var isShowingToast: Bool = false
    @State private var selectedToastType: ToastType = .success
    
    
    var body: some View {
        GeometryReader {
            let safeArea = $0.safeAreaInsets
            
            VStack {
                Text("Toast Type")
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Picker(selection: $selectedToastType) {
                    ForEach(ToastType.allCases, id: \.self) { type in
                        Text(type.rawValue)
                    }
                } label: {
                    Text("Toast Type")
                }
                .pickerStyle(.segmented)
                
                Button(action: onTapToggleShowToast) {
                    Text(isShowingToast ? "Hide" : "Show")
                }
                .bold()
                .buttonStyle(.borderedProminent)
                .transaction { transaction in
                    transaction.animation = nil
                }
                .padding()
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(Color.init(uiColor: .secondarySystemGroupedBackground))
            .overlay(alignment: .bottom) {
                if isShowingToast {
                    ToastView(type: selectedToastType, onTapClose: onTapToggleShowToast)
                    .padding(.bottom, safeArea.bottom)
                    .transition(
                        .move(edge: .bottom)
                        .combined(with: .blurReplace)
                    )
                }
            }
        }
    }
    
    private func onTapToggleShowToast() {
        withAnimation(.smooth(duration: 0.4, extraBounce: 0.2)) {
            isShowingToast.toggle()
        }
    }
}


#Preview {
    AnimatedToastView()
}
