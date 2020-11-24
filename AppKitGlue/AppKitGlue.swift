//
//  AppKitGlue.swift
//  AppKitGlue
//
//  Created by Nik Savko on 24.11.2020.
//

import Foundation

final class AppKitGlue: NSObject, MacOSBridge {
    func task() -> Task {
        return TaskImp()
    }
}
