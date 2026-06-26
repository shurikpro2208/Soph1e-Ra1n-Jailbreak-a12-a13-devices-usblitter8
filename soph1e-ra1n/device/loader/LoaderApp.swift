import SwiftUI

@main
struct LoaderApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var selectedPackageManager = "Sileo"

    var body: some View {
        NavigationView {
            List {
                Section("Package Managers") {
                    ForEach(["Sileo", "Zebra", "Cydia"], id: \.self) { pm in
                        Button(action: {
                            selectedPackageManager = pm
                            installPackageManager(pm)
                        }) {
                            HStack {
                                Image(systemName: iconForPM(pm))
                                    .foregroundColor(.blue)
                                Text(pm)
                                    .foregroundColor(.primary)
                                Spacer()
                                if selectedPackageManager == pm {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }

                Section("Tools") {
                    NavigationLink("u0 Launcher") {
                        Text("Launch unc0ver")
                    }
                    NavigationLink("Taurine Launcher") {
                        Text("Launch Taurine")
                    }
                    NavigationLink("System Info") {
                        SystemInfoView()
                    }
                }

                Section("Bootstrap") {
                    Button("Reinstall Bootstrap", role: .destructive) {
                        reinstallBootstrap()
                    }
                }
            }
            .navigationTitle("soph1e ra1n Loader")
        }
    }

    func iconForPM(_ name: String) -> String {
        switch name {
        case "Sileo": return "shippingbox.fill"
        case "Zebra": return "pawprint.fill"
        case "Cydia": return "cydia"
        default: return "square.grid.3x3"
        }
    }

    func installPackageManager(_ name: String) {
        let task = Process()
        task.launchPath = "/usr/bin/dpkg"
        task.arguments = ["-i", "/bootstrap/\(name.lowercased()).deb"]
        task.launch()
        task.waitUntilExit()
    }

    func reinstallBootstrap() {
        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = ["/bootstrap/reinstall.sh"]
        task.launch()
    }
}

struct SystemInfoView: View {
    @State private var info: [String: String] = [:]

    var body: some View {
        List {
            ForEach(Array(info.keys.sorted()), id: \.self) { key in
                HStack {
                    Text(key).bold()
                    Spacer()
                    Text(info[key] ?? "?")
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("System Info")
        .onAppear {
            collectInfo()
        }
    }

    func collectInfo() {
        let task = Process()
        task.launchPath = "/usr/bin/uname"
        task.arguments = ["-a"]
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        info["Kernel"] = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .newlines) ?? "?"

        if let version = try? String(contentsOfFile: "/bootstrap/version.txt") {
            info["Bootstrap"] = version.trimmingCharacters(in: .newlines)
        }
        info["Exploit"] = "soph1e ra1n"
        info["Tethered"] = "Yes (re-exploit after reboot)"
    }
}
