import UIKit
import HockeySDK_Source
import Photos
import ARAnalytics

class ARHockeyFeedbackDelegate: NSObject {

    func listenForScreenshots() {
        let mainQueue = NSOperationQueue.mainQueue()
        let notifications = NSNotificationCenter.defaultCenter()
        notifications.addObserverForName(UIApplicationUserDidTakeScreenshotNotification, object: nil, queue: mainQueue) { notification in
            // When I looked at how Hockey did this, I found that they would delay by a second
            // presumably it can take a second to have the image saved in the asset store before
            // we can pull it out again.
            ar_dispatch_after(1, self.showFeedbackWithRecentScreenshot)
        }
    }

    func showFeedback(image:UIImage? = nil) {
        let hockeyProvider = ARAnalytics.providerInstanceOfClass(HockeyAppProvider.self)
        var analyticsLog: BITHockeyAttachment?

        let processID = NSProcessInfo.processInfo().processIdentifier
        if let messages = hockeyProvider.messagesForProcessID(UInt(processID)) as? [String] {
            let message = messages.joinWithSeparator("\n")
            let data = message.dataUsingEncoding(NSUTF8StringEncoding)!
            analyticsLog = BITHockeyAttachment(filename: "analytics_log.txt", hockeyAttachmentData: data, contentType: "text")
        }

        let initialMessage = "Hey there\nI have some feedback:\n\n"

        // Create an array of optionals, then flatmap them to be only real values
        let items = ([initialMessage, image, analyticsLog] as [AnyObject?]).flatMap{ $0 }

        let vc = BITHockeyManager.sharedHockeyManager().feedbackManager
        vc.showFeedbackComposeViewWithPreparedItems(items)
    }

    func showFeedbackWithRecentScreenshot() {
        let fetch = PHFetchOptions()
        fetch.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]

        let results = PHAsset.fetchAssetsWithMediaType(.Image, options: fetch)
        guard let result = results.lastObject as? PHAsset else {
            self.showFeedback()
            return
        }

        PHImageManager.defaultManager().requestImageForAsset(result, targetSize: UIScreen.mainScreen().bounds.size, contentMode: .AspectFit, options: nil) { image, info in
            self.showFeedback(image)
        }
    }
}
