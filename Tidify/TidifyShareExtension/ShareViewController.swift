//
//  ShareViewController.swift
//  TidifyShareExtension
//
//  Created by Manjong Han on 2021/07/10.
//

import UIKit

class ShareViewController: UIViewController {

    let urlShareId = "public.url"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let extensionItems = extensionContext?.inputItems as! [NSExtensionItem]

        for extensionItem in extensionItems {
            if let itemProviders = extensionItem.attachments {
                for itemProvider in itemProviders {
                    if itemProvider.hasItemConformingToTypeIdentifier(urlShareId) {
                        itemProvider.loadItem(forTypeIdentifier: urlShareId, options: nil, completionHandler: { (url, error) -> Void in
                            if (url as? NSURL) != nil {
                                let encodedUrl = String(describing: url!)
                                
                                DispatchQueue.main.async {
                                    self.showAlert(url: encodedUrl)
                                }
                            }
                        })
                    }
                }
            }
        }
    }
    
    private func showAlert(url: String) {
        let alert = UIAlertController(title: "북마크로 저장할까요?", message: "\(url)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "저장", style: .default, handler: {
            (a) -> Void in
            self.notifyNewBookMark(url: url)
            self.complete()
        }))
        alert.addAction(UIAlertAction(title: "다음에", style: .cancel, handler: {
            (a) -> Void in
            self.complete()
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    private func notifyNewBookMark(url: String) {
        if let userDefaults = UserDefaults(suiteName: "group.com.aksmj.Tidify") {
            userDefaults.setValue(url, forKey: "newBookMark")
            userDefaults.synchronize()
        }
    }

    private func complete() {
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

}
