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

    //MARK: ******** ITEM DETAILS VIEW PROPERTIES
    
    @IBAction func dismissItemDetailsButton(_ sender: UIButton) {
        
        
        UIView.animate(withDuration: 1.50, animations: {
            
            self.itemDetailsViewCenterYConstraint.constant -= 500
            
            self.view.layoutIfNeeded()

        })
    }
    
    var itemDetailsAreDisplayed: Bool = false
    
    
    
    @IBOutlet weak var itemDetailsImage: UIImageView!
    
    @IBOutlet weak var itemDetailsViewCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var itemDetailsViewCenterYConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemQuantityLabel: UILabel!
    @IBOutlet weak var totalMassLabel: UILabel!
    @IBOutlet weak var totalMetalContentLabel: UILabel!
    @IBOutlet weak var totalUnitValueLabel: UILabel!
    @IBOutlet weak var totalMonetaryValueLabel: UILabel!
    
    
    @IBOutlet weak var skView: SKView!
    
    @IBOutlet weak var itemCollectionView: UICollectionView!
    
    @IBOutlet weak var itemViewingWindow: UIView!
    
  
    @IBOutlet weak var itemWindowHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var itemViewWindowCenterXConstraint: NSLayoutConstraint!
    
    
   
    lazy var startGameButton: UIButton = {
       
        let button = UIButton(type: .system)
        
       // button.addTarget(self, action: #selector(loadGame), for: UIControlEvents.allTouchEvents)
        
        button.setTitle("Start Game", for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
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
        
       
    }
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.itemCollectionView.delegate = self
        self.itemCollectionView.dataSource = self
        
        self.itemViewWindowCenterXConstraint.constant = -UIScreen.main.bounds.size.width
        self.itemDetailsViewCenterXConstraint.constant = -UIScreen.main.bounds.size.width
        registerNotifications()

        self.view.backgroundColor = UIColor.orange
        

        loadGame()
        
        
       
    }
    
   
    
    func loadGame(){
        
            /**
            UIView.animate(withDuration: 1.00, animations: {
                
                self.skViewCenterXConstant -= 2000
                
                skView.setNeedsLayout()
                
            }) **/
            
            progressView.isHidden = false
            
            // Load the SKScene from 'GameScene.sks'
            currentGameScene = GameScene(currentGameLevel: .Level1, progressView: self.progressView)
            
            guard let scene = self.currentGameScene else {
                fatalError("Error: failed to load game scene ")
                
            }
            
            
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            // Present the scene
    
                self.skView.presentScene(scene)

            
        
           /**
            UIView.animate(withDuration: 1.00, animations: {
                
                self.skViewCenterXConstant -= 2000
                
                skView.setNeedsLayout()

            }) **/
            
            
        
    }
    
    @IBAction func dismissItemViewingWindow(_ sender: Any) {
        
        
        UIView.animate(withDuration: 1.50, animations: {
            
            self.itemViewWindowCenterXConstraint.constant -= UIScreen.main.bounds.size.width
            
            if(self.itemDetailsAreDisplayed){
                self.itemDetailsViewCenterYConstraint.constant -= 500
            }
            
            self.itemDetailsViewCenterXConstraint.constant -= UIScreen.main.bounds.size.width
            
            self.itemViewingWindow.layoutIfNeeded()
            
        })
        
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
        
        
        UIView.animate(withDuration: 1.00, animations: {
            
            self.itemCollectionView.reloadData()
            
            self.itemViewWindowCenterXConstraint.constant += UIScreen.main.bounds.width
            self.itemDetailsViewCenterXConstraint.constant += UIScreen.main.bounds.width
            
            self.itemViewingWindow.layoutIfNeeded()
        })
        
    }
    
    func showItemDetails(forCollectible collectible: Collectible){
        
        itemTitleLabel.text = "Item Name: \(collectible.getCollectibleName())"
        itemQuantityLabel.text = "Quantity: \(collectible.getQuantityOfCollectible())"
        itemDetailsImage.image = UIImage(cgImage: collectible.getCollectibleTexture().cgImage())
        
        totalMassLabel.text = "Total Mass: \(collectible.getCollectibleMass())"
        totalUnitValueLabel.text = "Unit Value: \(collectible.getCollectibleUnitValue())"
        totalMonetaryValueLabel.text = "Total Monetary Value: \(collectible.getCollectibleMonetaryValue())"
        totalMetalContentLabel.text = "Total Metal Content: \(collectible.getCollectibleMetalContent())"
        totalUnitValueLabel.text = "Unit Value: \(collectible.getCollectibleUnitValue())"
        
        UIView.animate(withDuration: 1.50, animations: {
            
            if(!self.itemDetailsAreDisplayed){
                self.itemDetailsViewCenterYConstraint.constant += 500
                self.view.layoutIfNeeded()
                self.itemDetailsAreDisplayed = true
            }
           
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
    
    var progressViewCenterXConstant: CGFloat = 0.00
    var progressViewCenterYConstant: CGFloat = 200.00
    var progressViewHeightConstant: CGFloat = 10.00
    var progressViewWidthConstant: CGFloat = 250.00

  
    
    //MARK: ******* Computed properites - UIElement Constraints
    
  
    
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
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let collectibleManager = collectibleManager else {
            fatalError("Error: failed to access player collectible manager")
            
        }
        
        if let collectibleAtIndex = collectibleManager.getCollectibleAtIndex(index: indexPath.row){
            
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
