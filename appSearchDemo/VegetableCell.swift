//
//  Copyright © 2016 Kate Gridina. All rights reserved.
//

import UIKit

class VegetableCell: UITableViewCell {
    
    @IBOutlet weak var vegetableImage: UIImageView?
    @IBOutlet weak var vegetableDescription: UILabel?
    @IBOutlet weak var vegetableTitle: UILabel?
    
    func setupCell(withVegateble vegetable: Vegetable) {
        vegetableImage?.image = UIImage(named: vegetable.image)
        vegetableTitle?.text = vegetable.imageName
        vegetableDescription?.text = vegetable.description
    }
}
