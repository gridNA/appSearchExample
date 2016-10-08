//
//  Copyright © 2016 Kate Gridina. All rights reserved.
//

import Foundation

struct VegetableJsonParser {
    
    private func vegetableJson(fromData jsonData: Data) -> [Any]? {
        let json =  try? JSONSerialization.jsonObject(with: jsonData)
        return json as? [Any]
    }
    
    private func vegetableArray(fromJson json: Any?) -> [Vegetable] {
        guard let jsonArray = json as? [Any] else { return [] }
        var vegetables = [Vegetable]()
        for object in jsonArray {
            var vegetable = Vegetable()
            if let item = object as? [String : Any] {
                if let id = item["id"] as? String {
                    vegetable.id = id
                }
                if let imageName = item["imageName"] as? String {
                    vegetable.imageName = imageName
                }
                if let description = item["description"] as? String {
                    vegetable.description = description
                }
                if let keywords = item["keywords"] as? String {
                    vegetable.keywords = keywords
                }
                if let image = item["image"] as? String {
                    vegetable.image = image
                }
            }
            vegetables.append(vegetable)
        }
        return vegetables
    }
    
    func vegetables(fromFilePath filePath: String) -> [Vegetable]? {
        guard let filePath = Bundle.main.path(forResource: filePath, ofType: "json"),
            let contentData = FileManager.default.contents(atPath: filePath) else {
                return nil
        }
        
        let vJson = vegetableJson(fromData: contentData)
        return vegetableArray(fromJson: vJson)
    }
    
}
