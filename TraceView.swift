//
//  TraceView.swift
//  SysTraceApp
//
//  Created by Chris Bridges on 11/2/25.
//
import SwiftUI

struct TraceView: View {
    @ObservedObject var traceManager: TraceManager

    var body: some View {
        List(traceManager.events) { event in
            HStack {
                Text(event.timestamp.formatted(date: .omitted, time: .standard))
                    .frame(width: 100, alignment: .leading)
                Text(event.processName)
                    .frame(width: 120, alignment: .leading)
                Text(event.syscall)
                    .frame(width: 100, alignment: .leading)
                Text(event.details)
                    .lineLimit(1)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Trace Events")
    }
}

