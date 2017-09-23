//
//  GameViewController.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/1/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit




class GameViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource {


    lazy var skView: SKView? = {
        
        let skView = SKView()
        
        skView.translatesAutoresizingMaskIntoConstraints = false
        
        return skView
    }()
    
    
    lazy var startGameButton: UIButton = {
       
        let button = UIButton(type: .system)
        
        button.addTarget(self, action: #selector(loadGame), for: UIControlEvents.allTouchEvents)
        
        button.setTitle("Start Game", for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var inventoryCollectionView: UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        flowLayout.itemSize = CGSize(width: 150.0, height: 150.0)
        
        flowLayout.minimumInteritemSpacing = 5.00
        flowLayout.minimumLineSpacing = 5.00
        
       let collectionViewRect = CGRect(x: 0.00, y: 0.00, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.50)
        
        let collectionView = UICollectionView(frame: collectionViewRect, collectionViewLayout: flowLayout)
        
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(InventoryItemCell.self, forCellWithReuseIdentifier: "InventoryItemCell")
        
        return collectionView
    }()
    
    
    var currentGameScene: GameScene?
    
    var collectibleManager: CollectibleManager?{
        
        return currentGameScene?.player.collectibleManager

    }
    
    lazy var progressView: UIProgressView = {
        
 
        let progressView = UIProgressView(progressViewStyle: UIProgressViewStyle.bar)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.isHidden = false
        progressView.progress = 0.00
        
        return progressView
        
    }()
    

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        

        
        view.addSubview(startGameButton)
        
        NSLayoutConstraint.activate([
            startGameButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            startGameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startGameButton.widthAnchor.constraint(equalToConstant: 200.00),
            startGameButton.heightAnchor.constraint(equalToConstant: 100.00)
            
            ])
        
        if let skView = self.skView{
     
            self.view.addSubview(skView)
           self.view.addSubview(progressView)
            
           inventoryCollectionView.translatesAutoresizingMaskIntoConstraints = false
           self.view.addSubview(self.inventoryCollectionView)
            

        NSLayoutConstraint.activate(self.skViewConstraints)
       NSLayoutConstraint.activate(self.inventoryConstraints)
       NSLayoutConstraint.activate(self.progressViewConstraints)
            
        
            
           
            
        } else {
            fatalError("Error: failed to add the skView")
            
        }
        

    }
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        registerNotifications()

        self.view.backgroundColor = UIColor.orange
        
        loadGame()

        
        
        
       
    }
    
    
    @objc func loadGame(){
        if let skView = self.skView {
            
            /**
            UIView.animate(withDuration: 1.00, animations: {
                
                self.skViewCenterXConstant -= 2000
                
                skView.setNeedsLayout()
                
            }) **/
            
            progressView.isHidden = false
            
            // Load the SKScene from 'GameScene.sks'
            currentGameScene = GameScene(currentGameLevel: .Level2, progressView: self.progressView)
            
            guard let scene = self.currentGameScene else {
                fatalError("Error: failed to load game scene ")
                
            }
            
            
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            // Present the scene
            skView.presentScene(scene)
            
           /**
            UIView.animate(withDuration: 1.00, animations: {
                
                self.skViewCenterXConstant -= 2000
                
                skView.setNeedsLayout()

            }) **/
            
            
        }
    }
  
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    @objc func showCollectionView(){
        
        /**
        self.inventoryCollectionView.reloadData()

        UIView.animate(withDuration: 1.00, animations: {
            
            self.inventoryCollectionView.reloadData()
            self.inventoryHeightConstraint.constant = 200
    
          
            self.view.layoutIfNeeded()
        })
    **/
        
        let inventoryVC = InventoryViewController(nibName: nil, bundle: nil)
        
        inventoryVC.arrayOfCollectibles = collectibleManager!.getCollectiblesArray()
        
        present(inventoryVC, animated: true, completion: {
            
            inventoryVC.collectionView.reloadData()
        })
        
    }
    
    
    
    func registerNotifications(){
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(showCollectionView), name: Notification.Name(rawValue:Notification.Name.ShowInventoryCollectionViewNotification), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateProgressBar(notification:)), name: Notification.Name(rawValue:Notification.Name.didMakeProgressTowardsGameLoadingNotification), object: nil)

        
        
    }
    
    @objc func updateProgressBar(notification: Notification?){
        
        if let progressAmount = notification?.userInfo?["progressAmount"] as? Float{
        
            self.progressView.progress += Float(progressAmount)
        }
    }
    
    
    /** skView Constraints **/
    
    lazy var skViewLeftConstraint: NSLayoutConstraint = {
        
        return skView!.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: self.skViewLeftConstraintConstant)
        
    
    }()
    
    
    lazy var skViewRightConstraint: NSLayoutConstraint = {
        
        return skView!.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: self.skViewLeftConstraintConstant)
        
    }()
    
    
    lazy var skViewTopConstraint: NSLayoutConstraint = {
    
        return skView!.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.skViewTopConstraintConstant)
        
    }()
    
    lazy var skViewBottomConstraint: NSLayoutConstraint = {
        
        return skView!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: self.skViewBottomConstraintConstant)
        
    }()
    
    lazy var skViewCenterXConstraint: NSLayoutConstraint = {
        
        return skView!.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.skViewCenterXConstant)
        
    }()
    
    lazy var skViewCenterYConstraint: NSLayoutConstraint = {
        
        return self.skView!.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: self.skViewCenterYConstant)
        
    }()
    
    lazy var skViewWidthAnchorConstraint: NSLayoutConstraint = {
        
        return self.skView!.widthAnchor.constraint(equalToConstant: self.skViewWidthAnchorConstant)
        
    }()
    
    lazy var skViewHeightAnchorConstraint: NSLayoutConstraint = {
        
        return skView!.heightAnchor.constraint(equalToConstant: self.skViewHeightAnchorConstant)
        
    }()

    var skViewWidthAnchorConstant: CGFloat = UIScreen.main.bounds.width
        
        /**
        get{
            let isCompactVertical = self.traitCollection.verticalSizeClass == .compact
        
            return isCompactVertical ? UIScreen.main.bounds.width: UIScreen.main.bounds.height
        }
        **/
        
        
    
    
    var skViewHeightAnchorConstant: CGFloat = UIScreen.main.bounds.height
        
        /**
        get{
            let isCompactVertical = self.traitCollection.verticalSizeClass == .compact
        
            return isCompactVertical ? UIScreen.main.bounds.height: UIScreen.main.bounds.width
        }
        **/
        
  
    
    var inventoryCVcenterXConstraint: NSLayoutConstraint{
        return self.inventoryCollectionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.inventoryCVcenterXConstant)
    }

    var inventoryCVcenterYConstraint: NSLayoutConstraint{
        return self.inventoryCollectionView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: self.inventoryCVcenterYConstant)
    }
    
    var inventoryCVheightAnchorConstraint: NSLayoutConstraint{
        return self.inventoryCollectionView.heightAnchor.constraint(equalToConstant: 200)

    }
    
    var inventoryCVwidthAnchorConstraint: NSLayoutConstraint{
        return self.inventoryCollectionView.widthAnchor.constraint(equalToConstant: 400)
        
    }
    
    
    var progressViewCenterXConstraint: NSLayoutConstraint{
        return self.progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: self.progressViewCenterXConstant)
        
    }
    
    var progressViewCenterYConstraint: NSLayoutConstraint{
        return self.progressView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: self.progressViewCenterYConstant)
        
    }
    
    var progressViewWidthConstraint: NSLayoutConstraint{
        return self.progressView.widthAnchor.constraint(equalToConstant: self.progressViewWidthConstant)
        
    }
    
    var progressViewHeightConstraint: NSLayoutConstraint{
        return self.progressView.heightAnchor.constraint(equalToConstant: self.progressViewHeightConstant)
        
    }
    
    var inventoryLeftConstraint: NSLayoutConstraint{
        return self.inventoryCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor)
    }
    
    var inventoryRightConstraint: NSLayoutConstraint{
        return self.inventoryCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
    }
    
    var inventoryBottomConstraint: NSLayoutConstraint{
        return self.inventoryCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
    }
    
    var inventoryHeightConstraint: NSLayoutConstraint{
        return self.inventoryCollectionView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    var progressViewCenterXConstant: CGFloat = 0.00
    var progressViewCenterYConstant: CGFloat = 200.00
    var progressViewHeightConstant: CGFloat = 10.00
    var progressViewWidthConstant: CGFloat = 250.00

    var inventoryCVcenterXConstant: CGFloat = 0.000
    var inventoryCVcenterYConstant: CGFloat = 250.00

    var skViewCenterYConstant: CGFloat = 0.00
    var skViewCenterXConstant: CGFloat = 0.00
    
    var skViewTopConstraintConstant: CGFloat = 0.00
    var skViewBottomConstraintConstant: CGFloat = 0.00
    var skViewLeftConstraintConstant: CGFloat = 0.00
    var skViewRightConstraintConstant: CGFloat = 0.00
    
    //MARK: ******* Computed properites - UIElement Constraints
    
    var inventoryConstraints: [NSLayoutConstraint]{
        //return [self.inventoryCVcenterXConstraint,self.inventoryCVcenterYConstraint, self.inventoryCVheightAnchorConstraint,self.inventoryCVwidthAnchorConstraint]
        
        return [self.inventoryHeightConstraint,self.inventoryLeftConstraint,self.inventoryRightConstraint,self.inventoryBottomConstraint]
    }
    
    var progressViewConstraints: [NSLayoutConstraint]{
            return [self.progressViewCenterXConstraint,self.progressViewCenterYConstraint,self.progressViewWidthConstraint,self.progressViewHeightConstraint]
    }
    
    var skViewConstraints: [NSLayoutConstraint]{
        return [self.skViewCenterXConstraint,self.skViewCenterYConstraint,self.skViewHeightAnchorConstraint,self.skViewWidthAnchorConstraint]
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        
        /**
        NSLayoutConstraint.deactivate(self.skViewConstraints)
        
        
        self.skViewHeightAnchorConstant = 1400
        
        self.skViewHeightAnchorConstant = 1400
        
        NSLayoutConstraint.activate(self.skViewConstraints)
         **/

    }
    
   
    
    
}

extension GameViewController{
    
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
        
        let cell = inventoryCollectionView.dequeueReusableCell(withReuseIdentifier: "InventoryItemCell", for: indexPath) as! InventoryItemCell
        
        
        //let collectiblesArray = collectibleManager.getCollectiblesArray()
        let collectibleAtIndex = collectibleManager.getCollectibleAtIndex(index: indexPath.row)
        
        print("Obtained collectible at index \(indexPath.row) with name \(collectibleAtIndex!.getCollectibleName())")
        
        if let collectible = collectibleAtIndex{
            
            print("Configuring collection view item cell...")
        
            let title = collectible.getCollectibleName()
            let image = UIImage(cgImage: collectible.getCollectibleTexture().cgImage())
        
            cell.nameLabel.text = title
            cell.itemImageView.image = image
            
            print("Collection View item configured with title \(title) and with image \(image)")
        
        }
        
        return cell
        
    }
    
}
