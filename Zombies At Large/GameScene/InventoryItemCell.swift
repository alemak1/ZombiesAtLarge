//
//  InventoryItemCell.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/23/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit


class InventoryItemCell: UICollectionViewCell{
    
    
    var itemName: String?
    
    var itemImage: UIImage?
    
    var itemUnitValue: Double = 0.00
    var numberOfItems: Int = 0
    var totalValue: Double = 0.00
    var itemUnitMetalContent: Double = 0.00
    var totalMetalContent: Double = 0.00
    
    lazy var nameLabel: UILabel = {
        
        let nameLabel = UILabel()
        nameLabel.textColor = UIColor.black
        nameLabel.font = UIFont(name: "Didot", size: 5.00)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return nameLabel
    }()
    
    
   lazy var itemImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
    
        return imageView
    }()
    
    override func willMove(toSuperview newSuperview: UIView?) {
        
        
     

    }
    
    /**
    convenience init(collectibleType: CollectibleType) {
        
        let defaultFrame = CGRect(x: 0, y: 0, width: 200, height: 200)
        
        self.init(frame: defaultFrame)
        
        let bgImage = #imageLiteral(resourceName: "red_button09")
        self.backgroundView = UIImageView(image: bgImage)
        self.backgroundView!.contentMode = .scaleAspectFill
        
       itemImageView.frame = CGRect(x: frame.minX, y: frame.minY+frame.height*0.05, width: frame.width, height: frame.height*0.60)
        
       nameLabel.frame = CGRect(x: frame.minX, y: frame.minY+frame.height*0.65, width: frame.width, height: frame.height*0.30)
        
        contentView.addSubview(itemImageView)
        
        let cgImage = collectibleType.getTexture().cgImage()
        itemImageView.image = UIImage(cgImage: cgImage)

        contentView.addSubview(nameLabel)
        nameLabel.text = collectibleType.getCollectibleName()

        
        
    }**/
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        let bgImage = #imageLiteral(resourceName: "red_button09")
        self.backgroundView = UIImageView(image: bgImage)
        self.backgroundView!.contentMode = .scaleAspectFill
        
        itemImageView.frame = CGRect(x: frame.minX, y: frame.minY+frame.height*0.05, width: frame.width, height: frame.height*0.60)
        
        nameLabel.frame = CGRect(x: frame.minX, y: frame.minY+frame.height*0.65, width: frame.width, height: frame.height*0.30)
        
        contentView.addSubview(itemImageView)
        contentView.addSubview(nameLabel)
      

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
}
