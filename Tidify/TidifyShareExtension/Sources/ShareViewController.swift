//
//  ShareViewController.swift
//  Tidify_ShareExtension
//
//  Created by Ian on 2022/11/04.
//  Copyright © 2022 Tidify. All rights reserved.
//

import MobileCoreServices
import Social
import UIKit

final class ShareViewController: SLComposeServiceViewController {
  override func isContentValid() -> Bool {
    return contentText.isEmpty == false
  }

  override func didSelectPost() {
    let userDefault = UserDefaults(suiteName: "group.com.ian.Tidify.share")!
    if let text = textView.text {
      userDefault.set(text, forKey: "SharedText")
    }

    if let item = extensionContext?.inputItems.first as? NSExtensionItem {
      if let attachments = item.attachments {
            for attachment: NSItemProvider in attachments {
                if attachment.hasItemConformingToTypeIdentifier("public.url") {
                  attachment.loadItem(forTypeIdentifier: "public.url", options: nil, completionHandler: { (url, error) in
                        if let shareURL = url as? NSURL {
                          userDefault.set(shareURL.relativeString, forKey: "SharedURL")
                        }
                        self.extensionContext?.completeRequest(returningItems: [])
                    })
                }
            }
        }
    }
  }
}
