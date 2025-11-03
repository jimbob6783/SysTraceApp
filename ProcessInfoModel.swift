//
//  ProcessInfoModel.swift
//  SysTraceApp
//
//  Created by Chris Bridges on 11/2/25.
//
import Foundation

struct ProcessInfoModel: Identifiable {
    let id = UUID()
    let pid: Int
    let name: String
    let cpu: Double
    let memory: Double
}

