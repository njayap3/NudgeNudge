import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house.fill") }

            ActivityView()
                .tabItem { Label("Activity", systemImage: "chart.bar.fill") }

            MeView()
                .tabItem { Label("Me", systemImage: "person.fill") }
        }
        .tint(Color.nudgePink)
    }
}

#Preview {
    ContentView()
        .modelContainer(AppDependencies.modelContainer)
}
