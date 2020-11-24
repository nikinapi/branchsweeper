//
//  ViewController.swift
//  branchsweeper
//
//  Created by Nik Savko on 24.11.2020.
//

import UIKit

class ViewController: UIViewController, UIDocumentPickerDelegate {
    
    override func viewDidLoad() {
        self.addKeyCommand(UIKeyCommand(input: "o",
                                        modifierFlags: .command,
                                        action: #selector(handleOpenCommand(_:))))
    }
    
    @objc private func handleOpenCommand(_ command: UIKeyCommand) {
        let types = [kUTTypeFolder].map { $0 as String }
        let controller = UIDocumentPickerViewController(documentTypes: types, in: .open)
        controller.allowsMultipleSelection = false
        controller.modalPresentationStyle = .formSheet
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.window?.windowScene?.sizeRestrictions?.minimumSize = CGSize(width: 850, height: 600)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first, let repo = GitRepo(url: url) else {
            return
        }
        
        self.view.window?.windowScene?.title = url.lastPathComponent
        
        repo.checkoutOrCreate(branch: "old-branches-purge")
    }
}

