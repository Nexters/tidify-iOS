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

    if let item = extensionContext?.inputItems.first as? NSExtensionItem,
            let itemProvider = item.attachments?.first as? NSItemProvider,
            itemProvider.hasItemConformingToTypeIdentifier("public.url") {
            itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil) { (url, error) in
                if let shareURL = url as? URL {
                  userDefault.set(shareURL.relativeString, forKey: "SharedURL")
                }
                self.extensionContext?.completeRequest(returningItems: [], completionHandler:nil)
            }
        }

    self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
  }

  override func configurationItems() -> [Any]! {
    let item: SLComposeSheetConfigurationItem = .init()
    item.title = "Safari 혹은 Chrome사용을 권장합니다."
    return [item]
  }
}
