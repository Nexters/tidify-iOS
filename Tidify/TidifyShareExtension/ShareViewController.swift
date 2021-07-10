//
//  ShareViewController.swift
//  TidifyShareExtension
//
//  Created by Manjong Han on 2021/07/10.
//

import UIKit

class ShareViewController: UIViewController {
    
    override func viewDidLoad() {
            super.viewDidLoad()

            let extensionItems = extensionContext?.inputItems as! [NSExtensionItem]

            for extensionItem in extensionItems {
                if let itemProviders = extensionItem.attachments {
                    for itemProvider in itemProviders {
                        if itemProvider.hasItemConformingToTypeIdentifier("public.url") {
                            itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil, completionHandler: { (url, error) -> Void in
                                if (url as? NSURL) != nil {
                                    DispatchQueue.main.async {

                                        let alert = UIAlertController(title: "북마크로 저장할까요?", message: "\(String(describing: url!))", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "저장", style: .default, handler: {
                                            (a) -> Void in
                                            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
                                        }))
                                        alert.addAction(UIAlertAction(title: "다음에", style: .cancel, handler: {
                                            (a) -> Void in
                                            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
                                        }))
                                        self.present(alert, animated: true, completion: nil)

                                    }
                                }
                            })
                        }
                    }
                }
            }
        }

}
