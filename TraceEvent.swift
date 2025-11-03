//
//  TraceEvent.swift
//  SysTraceApp
//
//  Created by Chris Bridges on 11/2/25.
//
import Foundation

struct TraceEvent: Identifiable {
    let id = UUID()
    let timestamp: Date
    let processName: String
    let syscall: String
    let details: String
}
