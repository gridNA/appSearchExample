//
//  Copyright © 2016 Kate Gridina. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreSpotlight

class VegetablesController: UIViewController {
    
    @IBOutlet weak var vegetablesTable: UITableView?
    var vegetables: [Vegetable]?
    var vegetablesSearchResults: [Vegetable]?
    var vegetablesSearchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vegetables = VegetableJsonParser().vegetables(fromFilePath: "vegetables")
        setupSearchableContent()
        setupNavigationController()
        vegetablesSearchController = setupSearchController()
    }
    
    private func setupSearchController() -> UISearchController {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.definesPresentationContext = true
        controller.dimsBackgroundDuringPresentation = false
        controller.hidesNavigationBarDuringPresentation = false
        controller.searchBar.sizeToFit()
        
        vegetablesTable?.tableHeaderView = controller.searchBar
        return controller
    }
    
    private func setupNavigationController() {
        navigationController?.navigationItem.title = "Vegetables"
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func openDetails(withVegetable vegetable: Vegetable?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vegetableDetailsController = storyboard.instantiateViewController(withIdentifier: "VegetableDetailsViewController") as? VegetableDetailsViewController,
            let selectedVegatable = vegetable else { return }
        vegetableDetailsController.vegetable = selectedVegatable
        navigationController?.pushViewController(vegetableDetailsController, animated: true)
    }
    
    func openDetails(withVegetableIndex index: String) {
        let selectedVegetable = vegetables?.filter { v in
            return v.id == index
            }.first
        openDetails(withVegetable: selectedVegetable)
    }
    
    func currentVegetablesArray() -> [Vegetable] {
        if vegetablesSearchController.isActive {
            return vegetablesSearchResults ?? [Vegetable]()
        }
        return vegetables ?? [Vegetable]()
    }
    
    // MARK: CoreSpotlight
    
    private func setupSearchableContent() {
        var searchableItems = [CSSearchableItem]()
        vegetables?.forEach {vegetable in
            let attributes = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
            attributes.title = vegetable.imageName
            attributes.thumbnailURL = Bundle.main.url(forResource: vegetable.image, withExtension: "jpg")
            attributes.contentDescription = vegetable.description
            attributes.keywords = vegetable.keywords?.components(separatedBy: ", ")
            let searchableVegetable = CSSearchableItem(uniqueIdentifier: vegetable.id, domainIdentifier: "vegetable", attributeSet: attributes)
            // NOTE: expiration date of item
            //searchableVegetable.expirationDate = Date(timeIntervalSince1970: TimeInterval(1111))
            searchableItems.append(searchableVegetable)
        }
        
        CSSearchableIndex.default().indexSearchableItems(searchableItems) { (error) -> Void in
            if error != nil {
                print(error?.localizedDescription)
            }
        }
    }
    
    func cleanSearchableVegetable(withIndex index: [String]) {
        let currentIndexingState = CSSearchableIndex(name: Bundle.main.bundleIdentifier!)
        currentIndexingState.fetchLastClientState(completionHandler: {state, error in
            var currentState = Data()
            if let clientState = state {
                currentState = clientState
                // NOTE: do something with the state here if needed
            }
            
            currentIndexingState.beginBatch()
            
            currentIndexingState.deleteSearchableItems(withDomainIdentifiers: index, completionHandler: { error in
                guard let deletionError = error else { return }
                print("error occurred during actions deletion: \(deletionError)")
            })
            
            currentIndexingState.deleteSearchableItems(withIdentifiers: index, completionHandler: { error in
                guard let deletionError = error else { return }
                print("error occurred during items deletion: \(deletionError)")
            })
            
            currentIndexingState.endBatch(withClientState: currentState, completionHandler: { error in
                guard let deletionError = error else { return }
                print("error occurred during items deletion: \(deletionError)")
            })
        })
    }
    
    // IOS 10
    
    func continueSearch(withString searchString: String) {
        vegetablesSearchController.isActive = true
        vegetablesSearchController.searchBar.text = searchString
    }
}

extension VegetablesController: UISearchResultsUpdating {
    
    func filterVegetables(forSearchText searchText: String) -> [Vegetable] {
        guard let vegie = vegetables else {
            return [Vegetable]()
        }
        return vegie.filter {v in
            return v.imageName.lowercased().range(of: searchText.lowercased()) != nil ||
            v.description?.lowercased().range(of: searchText.lowercased()) != nil ||
            v.keywords?.lowercased().range(of: searchText.lowercased()) != nil
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        vegetablesSearchResults = filterVegetables(forSearchText: searchText)
        vegetablesTable?.reloadData()
    }
}

extension VegetablesController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentVegetablesArray().count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vegetable = currentVegetablesArray()[indexPath.row]
        let vegetableCellIdentifier = "VegetableCell"
        
        let vegetableCell = tableView.dequeueReusableCell(withIdentifier: vegetableCellIdentifier) as? VegetableCell
        vegetableCell?.setupCell(withVegateble: vegetable)
        return vegetableCell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete, let vegi = vegetables else { return }
        cleanSearchableVegetable(withIndex: [vegi[indexPath.row].id])
        vegetables?.remove(at: indexPath.row)
        vegetablesTable?.reloadData()
    }
    
}

extension VegetablesController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openDetails(withVegetable: vegetables?[indexPath.row])
    }

}

