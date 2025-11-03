//
//  ProcessListViewModel.swift
//  SysTraceApp
//
//  Created by Chris Bridges on 11/2/25.
//
import Foundation
import Combine

@MainActor
class ProcessListViewModel: ObservableObject {
    @Published var processes: [ProcessInfoModel] = []

    func fetchProcesses() {
        let task = Process()
        task.launchPath = "/bin/ps"
        task.arguments = ["-axo", "pid,comm,%cpu,%mem"]

        let pipe = Pipe()
        task.standardOutput = pipe
        try? task.run()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        guard let output = String(data: data, encoding: .utf8) else { return }

        let lines = output.split(separator: "\n").dropFirst()
        processes = lines.compactMap { line in
            let parts = line.split(separator: " ", omittingEmptySubsequences: true)
            guard parts.count >= 4,
                  let pid = Int(parts[0]),
                  let cpu = Double(parts[2]),
                  let mem = Double(parts[3]) else { return nil }

            return ProcessInfoModel(pid: pid, name: String(parts[1]), cpu: cpu, memory: mem)
        }
    }
}
