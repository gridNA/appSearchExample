//
//  Copyright © 2016 Kate Gridina. All rights reserved.
//

import UIKit
import CoreSpotlight
import MobileCoreServices

class VegetablesEmptyController: UIViewController {

    var vegetablesEmptyActivity: NSUserActivity?

    override func viewDidLoad() {
        super.viewDidLoad()
        createUserActivity()
    }

    private func createUserActivity() {
        vegetablesEmptyActivity = NSUserActivity(activityType: "com.kategridina.appSearchDemo.vegetableSearchExtention.vegetablesEmpty")
        vegetablesEmptyActivity?.title = "Here can be a Vegetable"
        vegetablesEmptyActivity?.keywords = Set(["empty, test, no vegie"])
        vegetablesEmptyActivity?.isEligibleForSearch = true
        vegetablesEmptyActivity?.isEligibleForPublicIndexing = true
        vegetablesEmptyActivity?.isEligibleForHandoff = true
        let attributes = CSSearchableItemAttributeSet()
        attributes.thumbnailURL = Bundle.main.url(forResource: "vegetables", withExtension: "jpg")
        vegetablesEmptyActivity?.contentAttributeSet = attributes
        //vegetablesEmptyActivity?.delegate = self // use delegate if needed
        //vegetablesEmptyActivity?.webpageURL = URL(string: "https://vegetables.com/secodView") // will be used in web markup
        //vegetablesEmptyActivity?.needsSave = true // is used when activity state should be updated
        //vegetablesEmptyActivity?.expirationDate = Date(timeIntervalSince1970: TimeInterval(1111)) // if activity can expire
        vegetablesEmptyActivity?.becomeCurrent()
    }
    
}

