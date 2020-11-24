//
//  MacOSBridge.swift
//  branchsweeper
//
//  Created by Nik Savko on 24.11.2020.
//

import Foundation

@objc(MacOSBridge) protocol MacOSBridge: NSObjectProtocol {
    init()
    
    func task() -> Task
}

@objc protocol Task {
    
    var currentDirectoryURL: URL? { get set }
    var executableURL: URL? { get set }
    var arguments: [String]? { get set }
    
    @discardableResult func execute() -> String
}
