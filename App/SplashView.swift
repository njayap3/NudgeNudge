import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var opacity: Double = 0
    @State private var scale: Double = 0.82

    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                Color.white.ignoresSafeArea()
                Image("NudgeLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 260)
                    .opacity(opacity)
                    .scaleEffect(scale)
            }
            .onAppear {
                withAnimation(.spring(response: 0.55, dampingFraction: 0.72)) {
                    opacity = 1
                    scale = 1
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                    withAnimation(.easeIn(duration: 0.25)) {
                        opacity = 0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        isActive = true
                    }
                }
            }
        }
    }
}
