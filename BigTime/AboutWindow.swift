//
//  AboutWindow.swift
//  BigTime
//
//  Created by ash on 2/14/25.
//

import SwiftUI
import Luminare

class AboutWindowController: NSObject {
    private var window: NSWindow?

    static let shared = AboutWindowController()
    
    private override init() {
        super.init()
    }

    func showAboutView() {
        if window == nil {
            let aboutView = AboutView()
            let hostingController = NSHostingController(rootView: aboutView)

            let window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 600, height: 450),
                styleMask: [.titled, .closable, .fullSizeContentView],
                backing: .buffered,
                defer: false
            )
            
            window.center()
            window.contentViewController = hostingController
            window.isReleasedWhenClosed = false
            window.titlebarAppearsTransparent = true
            window.isMovableByWindowBackground = true

            self.window = window
        }

        window?.makeKeyAndOrderFront(nil)
    }
}

struct AboutView: View {
    private var appVersion: String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return "Unknown"
    }
    
    @State private var selectedView: String = "about"
    
    var body: some View {
        HStack(spacing: 0) {
            // Sidebar
            List {
                LuminareSection {
                    Button("aboutMenuLabel") {
                        selectedView = ""
                    }
                    .buttonStyle(LuminareButtonStyle())
                    
                    Button("creditsLabel") {
                        selectedView = "credits"
                    }
                    .buttonStyle(LuminareButtonStyle())
                }
                
                Image(systemName: "heart.fill")
                    .imageScale(.large)
                    .foregroundStyle(.tertiary)
            }
            .listStyle(.sidebar)
            .scrollContentBackground(.hidden)
            .frame(width: 200)
            
            Divider().ignoresSafeArea(.all)
            
            // Main Content
            VStack {
                switch selectedView {
                case "credits":
                    CreditsView()
                default:
                    AboutContentView(appVersion: appVersion)
                }
            }
            .layoutPriority(1)
            .padding()
            .frame(minWidth: 350, minHeight: 350)
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button(action: {
                    if let url = URL(string: "https://asboy2035.pages.dev/apps/stand") {
                        NSWorkspace.shared.open(url)
                    }
                }) {
                    Label("websiteLabel", systemImage: "globe")
                }
            }
        }
        .background(VisualEffectView(material: .sidebar, blendingMode: .behindWindow).edgesIgnoringSafeArea(.all))
    }
}

struct GitHubRelease: Codable {
    var tag_name: String
}

struct CreditsView: View {
    struct Dependency {
        let name: String
        let url: String
        let license: String
        let systemImage: String
    }

    let dependencies: [Dependency] = [
        Dependency(name: "SwiftUI", url: "https://developer.apple.com/xcode/swiftui/", license: "Apple License", systemImage: "swift"),
        Dependency(name: "Luminare", url: "https://github.com/MrKai77/Luminare", license: "BSD 3-Clause License", systemImage: "macwindow.and.cursorarrow"),
        Dependency(name: "LaunchAtLogin", url: "https://github.com/sindresorhus/LaunchAtLogin-Modern", license: "MIT License", systemImage: "bolt.fill")
    ]

    var body: some View {
        VStack {
            VStack {
                LuminareSection {
                    ForEach(dependencies, id: \.name) { dependency in
                        Button(action: {
                            if let url = URL(string: dependency.url) {
                                NSWorkspace.shared.open(url)
                            }
                        }) {
                            VStack {
                                Label(dependency.name, systemImage: dependency.systemImage.isEmpty ? "shippingbox.fill" : dependency.systemImage)
                                Text(dependency.license)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .buttonStyle(LuminareButtonStyle())
                        .frame(height: 45)
                    }
                }
                Spacer()
            }
            .navigationTitle("creditsLabel")
        }
    }
}

struct AboutContentView: View {
    var appVersion: String

    var body: some View {
        VStack {
            Image(nsImage: NSApplication.shared.applicationIconImage)
                .resizable()
                .scaledToFit()
                .frame(width: 75, height: 75)
            
            Text("appName")
                .font(.title)
            Text(appVersion)
                .foregroundStyle(.secondary)
            
            Spacer()
            .buttonStyle(LuminareCompactButtonStyle())
            .frame(width: 150, height: 35)
            Text("thanksText")
            Text("madeWithLove")
        }
        .padding()
        .navigationTitle("aboutLabel")
    }
}

#Preview {
    AboutView()
}
