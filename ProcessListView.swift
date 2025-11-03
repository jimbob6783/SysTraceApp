//
//  ProcessListView.swift
//  SysTraceApp
//
//  Created by Chris Bridges on 11/2/25.
//
import SwiftUI

struct ProcessListView: View {
    @ObservedObject var viewModel: ProcessListViewModel

    var body: some View {
        List(viewModel.processes) { process in
            VStack(alignment: .leading) {
                Text("\(process.name) (PID: \(process.pid))")
                Text("CPU: \(process.cpu, specifier: "%.1f")%  Mem: \(process.memory, specifier: "%.1f")%")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Processes")
    }
}

