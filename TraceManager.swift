
import Foundation
import Combine
import OSLog

@MainActor
class TraceManager: ObservableObject {
    @Published var events: [TraceEvent] = []
    private var timer: Timer?
    private var lastDate: Date?

    // MARK: - Start and Stop

    func startTracing() {
        stopTracing()
        events.removeAll()
        lastDate = Date(timeIntervalSinceNow: -5)

        // Poll the unified log every second
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            Task { @MainActor in
                await self.fetchNewLogs()
            }
        }

        print("🟢 SysTrace logging started.")
    }

    func stopTracing() {
        timer?.invalidate()
        timer = nil
        print("🔴 SysTrace logging stopped.")
    }

    // MARK: - Fetch New Logs

    private func fetchNewLogs() async {
        do {
            // Get system-wide logs (no root needed)
            let store = try OSLogStore.local()
            let startPosition: OSLogPosition

            if let last = lastDate {
                startPosition = store.position(date: last)
            } else {
                startPosition = store.position(timeIntervalSinceLatestBoot: -5)
            }

            let entries = try store.getEntries(at: startPosition)
                .compactMap { $0 as? OSLogEntryLog }

            // Update timestamp for next polling
            lastDate = Date()

            // Convert entries to your model
            let newEvents = entries.map { entry in
                TraceEvent(
                    timestamp: entry.date,
                    processName: entry.process,
                    syscall: entry.subsystem.isEmpty ? "log" : entry.subsystem,
                    details: entry.composedMessage
                )
            }

            // Update the published list (limit to 500 for performance)
            if !newEvents.isEmpty {
                self.events.append(contentsOf: newEvents)
                if self.events.count > 500 {
                    self.events.removeFirst(self.events.count - 500)
                }
            }

        } catch {
            print("⚠️ Error reading unified logs: \(error)")
        }
    }
}
