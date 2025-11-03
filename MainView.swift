//
//  MainView.swift
//  SysTraceApp
//
//  Created by Chris Bridges on 11/2/25.
//
import SwiftUI

struct MainView: View {
    @StateObject private var traceManager = TraceManager()
    @StateObject private var processVM = ProcessListViewModel()
    @State private var showPermissionAlert = false

    var body: some View {
        NavigationSplitView {
            ProcessListView(viewModel: processVM)
                .frame(minWidth: 300)
                .onAppear { processVM.fetchProcesses() }
        } detail: {
            TraceView(traceManager: traceManager)
                .frame(minWidth: 600)
        }
        .toolbar {
            ToolbarItemGroup {
                Button("Start Trace") { startTracingSafely() }
                Button("Stop Trace") { traceManager.stopTracing() }
            }
        }
        .alert("Permissions Required",
               isPresented: $showPermissionAlert,
               actions: {
                   Button("Open Settings") {
                       PermissionsHelper.openFullDiskAccessSettings()
                   }
                   Button("Cancel", role: .cancel) { }
               },
               message: {
                   Text("""
                   SysTrace needs Full Disk Access and administrator privileges to capture system calls.

                   1️⃣ Open System Settings → Privacy & Security → Full Disk Access.
                   2️⃣ Add SysTrace and enable it.
                   3️⃣ Relaunch the app using 'sudo' from Terminal.
                   """)
               })
    }

    private func startTracingSafely() {
        let hasAdmin = PermissionsHelper.hasAdminRights()
        let hasFullDisk = PermissionsHelper.hasFullDiskAccess()

        if hasAdmin && hasFullDisk {
            traceManager.startTracing()
        } else {
            showPermissionAlert = true
        }
    }
}
