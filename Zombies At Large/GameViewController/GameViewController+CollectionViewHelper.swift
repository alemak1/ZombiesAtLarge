//
//  GameViewController+CollectionViewHelper.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/28/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import UIKit


extension GameViewController{
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let collectibleManager = collectibleManager else {
            fatalError("Error: failed to access player collectible manager")
            
        }
        
        
        
        if let collectibleAtIndex = collectibleManager.getCollectibleAtIndex(index: indexPath.row){
            
            self.currentlySelectedItem = indexPath.row
            showItemDetails(forCollectible: collectibleAtIndex)
            
        }
        
    }
    
    /** The inventory display will have one section for all the inventory items only **/
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let collectibleManager = collectibleManager else {
            return 0
        }
        
        return collectibleManager.getTotalNumberOfUniqueItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let collectibleManager = collectibleManager else {
            fatalError("Error: failed to access player collectible manager")
            
        }
        
        let cell = itemCollectionView.dequeueReusableCell(withReuseIdentifier: "InventoryItemCell", for: indexPath) as! InventoryItemCell
        
        
        //let collectiblesArray = collectibleManager.getCollectiblesArray()
        let collectibleAtIndex = collectibleManager.getCollectibleAtIndex(index: indexPath.row)
        
        print("Obtained collectible at index \(indexPath.row) with name \(collectibleAtIndex!.getCollectibleName())")
        
        if let collectible = collectibleAtIndex{
            
            print("Configuring collection view item cell...")
            
            let title = collectible.getCollectibleName()
            let image = UIImage(cgImage: collectible.getCollectibleTexture().cgImage())
            
            cell.itemName.text = title
            cell.itemImage.image = image
            
            print("Collection View item configured with title \(title) and with image \(image)")
            
        }
        
        return cell
        
    }
    
    
    
}
