//
//  PermissionsHelper.swift
//  SysTraceApp
//
//  Created by Chris Bridges on 11/2/25.
//
// PermissionsHelper.swift
import Foundation
import AppKit

enum PermissionsHelper {
    static func hasAdminRights() -> Bool {
        getuid() == 0
    }

    static func hasFullDiskAccess() -> Bool {
        let protectedPath = "/Library/Application Support/com.apple.TCC"
        return FileManager.default.isReadableFile(atPath: protectedPath)
    }

    static func openFullDiskAccessSettings() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles") {
            NSWorkspace.shared.open(url)
        }
    }
}
