//
//  Copyright © 2016 Kate Gridina. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreSpotlight

class VegetableDetailsViewController: UIViewController {

    @IBOutlet weak var vegetableImageView: UIImageView!
    @IBOutlet weak var vegetableDescription: UILabel!
    @IBOutlet weak var vegetableKeywords: UILabel!
    var vegetable: Vegetable?
    var vegetableDetailsActivity: NSUserActivity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Vegetable Details"
        createUserActivity()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupDetails(withVegetable: vegetable)
    }
    
    private func createUserActivity() {
        guard let vegi = vegetable else { return }
        
        vegetableDetailsActivity = NSUserActivity(activityType: "com.kategridina.appSearchDemo.vegetableSearchExtention.vegetableDetails")
        vegetableDetailsActivity?.title = vegi.imageName + " details"
        vegetableDetailsActivity?.keywords = Set(["vegetable details", "details"])//(vegi.keywords?.components(separatedBy: ", ") ?? [])
        vegetableDetailsActivity?.isEligibleForSearch = true
        vegetableDetailsActivity?.isEligibleForPublicIndexing = true
        vegetableDetailsActivity?.isEligibleForHandoff = true
        vegetableDetailsActivity?.userInfo = ["vegetable": vegi.id]
        
        let attributes = CSSearchableItemAttributeSet()
        attributes.thumbnailURL = Bundle.main.url(forResource: vegi.image, withExtension: "jpg")
        if #available(iOS 10.0, *) {
            // NOTE: use thid in case of weak binding
            //attributes.weakRelatedUniqueIdentifier = vegi.id
            attributes.domainIdentifier = vegi.id // is needed to remove Action when it is not used
        }
        attributes.relatedUniqueIdentifier = vegi.id
        vegetableDetailsActivity?.contentAttributeSet = attributes
        
        //vegetableDetailsActivity?.delegate = self // use delegate if needed
        //vegetableDetailsActivity?.webpageURL = URL(string: "https://vegetables.com/vegetableDetails") // will be used in web markup
        //vegetableDetailsActivity?.needsSave = true // is used when activity state should be updated
        //vegetableDetailsActivity?.expirationDate = Date(timeIntervalSince1970: TimeInterval(1111)) // if activity can expire
        vegetableDetailsActivity?.becomeCurrent()
    }
    
    private func setupDetails(withVegetable vegetable: Vegetable?) {
        guard let vegi = vegetable else { return }
        vegetableImageView.image = UIImage(named: vegi.image)
        vegetableKeywords?.text = vegi.keywords
        vegetableDescription?.text = vegi.description
    }
    
}
