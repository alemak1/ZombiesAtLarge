//
//  InventoryViewController.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/23/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class InventoryViewController: UIViewController{
    
    var arrayOfCollectibles: [Collectible]?
    var collectionView: UICollectionView!
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        print("viewWillLayoutSubviews:")
        showDataSourceInfo()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: 200)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(InventoryItemCell.self, forCellWithReuseIdentifier: "InventoryItemCell")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0.0),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0.0)
            ])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("viewWillAppear:")
        showDataSourceInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("viewDidLoad:")

        showDataSourceInfo()
        
      
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension InventoryViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let array = arrayOfCollectibles else { return 0 }
        
        return array.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "InventoryItemCell", for: indexPath) as! InventoryItemCell
        
      
     
    
        
        return cell
    
    }
    
    
    func showDataSourceInfo(){
        
        let numberOfItems = arrayOfCollectibles?.count ?? 0
        let firstItem = arrayOfCollectibles?.first ?? Collectible(withCollectibleType: .Bomb)
        let lastItem = arrayOfCollectibles?.last ?? Collectible(withCollectibleType: .Bomb)
        
        print("The data source has a total of \(numberOfItems) items")
        print("The first item has name \(firstItem.getCollectibleName()) and has a monetary value of \(firstItem.getCollectibleMonetaryValue())")
        print("The last item has name \(lastItem.getCollectibleName()) and has a monetary value of \(lastItem.getCollectibleMonetaryValue())")

        
        
    }
    
    
}

extension InventoryViewController: UICollectionViewDelegate{
    
}
