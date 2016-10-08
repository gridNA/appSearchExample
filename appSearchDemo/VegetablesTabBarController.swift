//
//  Copyright © 2016 Kate Gridina. All rights reserved.
//

import UIKit
import CoreSpotlight

class VegetablesTabBarController: UITabBarController {
    
    let vegetableDetailsActivityType = "com.kategridina.appSearchDemo.vegetableSearchExtention.vegetableDetails"
    let secondViewActivityType = "com.kategridina.appSearchDemo.vegetableSearchExtention.vegetablesEmpty"
    
    private func retrieveNavigationController() -> UINavigationController? {
        return viewControllers?.first as? UINavigationController
    }
    
    func handleUserActivity(_ activity: NSUserActivity) -> Bool {
        if #available(iOS 10.0, *) {
            guard let navController = retrieveNavigationController(),
                let searchQuery = activity.userInfo?[CSSearchQueryString] as? String,
                activity.activityType == CSQueryContinuationActionType else {
                    restoreUserActivityState(activity)
                    return true
            }
            (navController.viewControllers[0] as? VegetablesController)?.continueSearch(withString: searchQuery)
            return true
        }
        restoreUserActivityState(activity)
        return true
    }
    
    override func restoreUserActivityState(_ activity: NSUserActivity) {
        
        if activity.activityType == CSSearchableItemActionType ||
            activity.activityType == vegetableDetailsActivityType,
            let userInfo = activity.userInfo {
            
            guard let selectedVegetableIndex = activity.activityType == CSSearchableItemActionType ?
                userInfo[CSSearchableItemActivityIdentifier] as? String :
                userInfo["vegetable"] as? String else { return }
            
            (retrieveNavigationController()?.viewControllers[0] as? VegetablesController)?.openDetails(withVegetableIndex: selectedVegetableIndex)
        } else if activity.activityType == secondViewActivityType, let _ = viewControllers?[1] as? VegetablesEmptyController {
            selectedIndex = 1
        }
    }
}
