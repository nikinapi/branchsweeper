//
//  NSTask.swift
//  branchsweeper
//
//  Created by Nik Savko on 24.11.2020.
//

import Foundation

class TaskImp: Task {
    
    private let task = Process()
    
    var currentDirectoryURL: URL? {
        get { return self.task.currentDirectoryURL }
        set { self.task.currentDirectoryURL = newValue }
    }
    
    var executableURL: URL? {
        get { return self.task.executableURL }
        set { self.task.executableURL = newValue }
    }
    
    var arguments: [String]? {
        get { return self.task.arguments }
        set { self.task.arguments = newValue }
    }
    
    func execute() -> String {
        let pipe_semaphore = DispatchSemaphore(value: 0)
        
        let stdOut = Pipe()
        let stdErr = Pipe()
        
        func set(pipe: Pipe, output: NSMutableString) {
            let handler: (FileHandle) -> Void = {
                let data = $0.readData(ofLength: .max)
                if data.isEmpty {
                    pipe_semaphore.signal()
                    $0.readabilityHandler = nil
                }
                guard let chunk = String(data: data, encoding: .utf8) else {
                    return
                }
                
                output.append(chunk)
            }
            
            pipe.fileHandleForReading.readabilityHandler = handler
        }
        
        let stdOutString: NSMutableString = ""
        let stdErrString: NSMutableString = ""
        
        set(pipe: stdOut, output: stdOutString)
        set(pipe: stdErr, output: stdErrString)
        
        self.task.standardOutput = stdOut
        self.task.standardError = stdErr
        
        self.task.launch()
        self.task.waitUntilExit()
        
        pipe_semaphore.wait()
        pipe_semaphore.wait()
        
        if self.task.terminationStatus != 0, stdErrString.length > 0 {
            print(stdErrString)
        }
        
        return stdOutString as String
    }
}
