import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab {
                NavigationStack {
                    Text("Home")

                    Menu {
                        Button {

                        } label: {
                            Label("Option 1", systemImage: "document.on.document")
                        }

                        Button {

                        } label: {
                            Label("Option 2", systemImage: "pencil")
                        }
                    } label: {
                        Text("Menu")
                    }
                    .modifier { view in
                        if #available(iOS 26, *) {
                            view.buttonStyle(.glassProminent)
                        } else {
                            view.buttonStyle(.borderedProminent)
                        }
                    }
                    .controlSize(.large)
                    .navigationTitle("Home")
                }
            } label: {
                Label("Home", systemImage: "house")
            }

            Tab {
                NavigationStack {
                    List {
                        ForEach(Array(1...100), id: \.self) { i in
                            Text("Item #\(i)")
                        }
                    }
                    .navigationTitle("Explore")
                }
            } label: {
                Label("Explore", systemImage: "binoculars")
            }

            Tab {
                NavigationStack {
                    SettingsView()
                }
            } label: {
                Label("Settings", systemImage: "gear")
            }
        }
        .modifier { view in
            if #available(iOS 26, *) {
                view.tabBarMinimizeBehavior(.onScrollDown)
            } else {
                view
            }
        }
    }
}

struct SettingsView: View {
    @AppStorage(kIgnoreDesignCompatibilityFlagUserDefaultsKey)
    private var enableLiquidGlass = false

    @State private var initialPreferenceState = false
    @State private var preferenceChanged = false

    var body: some View {
        Form {
            Section {
                Toggle("Enable Liquid Glass", isOn: $enableLiquidGlass)
            } footer: {
                Text("""
                This app was compiled with UIDesignRequiresCompatibility in its Info.plist.
                
                This toggle sets the "com.apple.SwiftUI.IgnoreSolariumOptOut" key to true in standard user defaults, which makes the system ignore the Info.plist value at runtime.    
                """)
            }

            if preferenceChanged {
                VStack {
                    Text("Restart the app for changes to take effect")
                        .foregroundStyle(.secondary)

                    Button("Kill App") {
                        exit(0)
                    }
                    .buttonBorderShape(.capsule)
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                }
            }
        }
        .navigationTitle("Settings")
        .task { initialPreferenceState = enableLiquidGlass }
        .onChange(of: enableLiquidGlass) { _, newValue in
            preferenceChanged = newValue != initialPreferenceState
        }
    }
}

extension View {
    func modifier(@ViewBuilder builder: (_ view: Self) -> some View) -> some View {
        builder(self)
    }
}

#if DEBUG
#Preview {
    ContentView()
}
#endif
