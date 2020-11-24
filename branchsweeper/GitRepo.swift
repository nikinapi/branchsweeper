//
//  GitRepo.swift
//  branchsweeper
//
//  Created by Nik Savko on 24.11.2020.
//

import UIKit

class GitRepo {
    let url: URL
    
    init?(url: URL) {
        guard FileManager.default.fileExists(atPath: url.appendingPathComponent(".git").path) else {
            return nil
        }
        
        self.url = url
    }
    
    private static let sh = URL(fileURLWithPath: "/bin/sh")
    
    private static let envGit: URL = {
        let task = UIApplication.macOSBridge.task()
        task.executableURL = GitRepo.sh
        task.arguments = ["-c", "which git"]
        return URL(fileURLWithPath: task.execute().trimmingCharacters(in: .whitespacesAndNewlines))
    }()
    
    private func shell(command: String) -> Task {
        let task = UIApplication.macOSBridge.task()
        task.executableURL = Self.sh
        task.currentDirectoryURL = self.url
        task.arguments = ["-c", command]
        
        return task
    }
    
    func listBranches() -> [String] {
        let task = self.shell(command: " git branch -a | grep -e 'remotes/origin/.*' | tail -n +2 | sed 's!.*remotes/!!g' ")
        return task.execute().trimmingCharacters(in: .whitespacesAndNewlines).split(separator: "\n").map(String.init)
    }
    
    func log(changeset: String) -> String {
        let task = self.shell(command: " git log \(changeset) ")
        return task.execute()
    }
    
    func checkoutOrCreate(branch: String) {
        self.shell(command: " git checkout \(branch) || git checkout -b \(branch) ").execute()
    }
}
