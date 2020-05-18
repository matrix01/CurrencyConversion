//
//  DeviceModel.swift
//  CurrencyConverter
//
//  Created by milan.mia on 5/16/20.
//  Copyright © 2020 fftsys. All rights reserved.
//

import Foundation

/// DeviceModel
internal struct DeviceModel {
    static var bundleVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }

    static var platform: String {
        var size: Int = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var machine = [CChar](repeating: 0, count: size)
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
        return String(cString: machine) // 例: iPad3,1
    }
}

struct Platform {
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
}

