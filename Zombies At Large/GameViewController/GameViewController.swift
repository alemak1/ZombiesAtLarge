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



/** TODO: Use delegates to manage the unrescued characters, the required collectibles, and the must kill zombies **/

class GameViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var gameStatsViewCenterXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var zombiesKilledLabel: UILabel!
    
    
    @IBOutlet weak var shootingAccuracyLabel: UILabel!
    
    
    @IBOutlet weak var totalCollectiblesValueLabel: UILabel!
    
    
    @IBOutlet weak var numberOfItemsCollectedLabel: UILabel!
    
    
    //MARK: ******** ITEM DETAILS VIEW PROPERTIES
    
    @IBOutlet weak var detailInfoLabel: UILabel!
    @IBOutlet weak var itemInfoLabelsAlignLeftConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var detailInformationCenterXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var itemDetailWindow: UIView!
    
    @IBAction func showItemDetailInformation(_ sender: UIButton) {
        
        self.showItemDetailInformation()
    }
    

    var itemDetailInfoIsShowing: Bool = false
    
    
    @IBAction func dismissItemDetailsButton(_ sender: UIButton) {
    
        self.dismissItemDetails()
    }
    
   
    
    var itemDetailsAreDisplayed: Bool = false
    var currentlySelectedItem: Int?
    
    
    @IBOutlet weak var itemDetailsImage: UIImageView!
    
    @IBOutlet weak var itemDetailsViewCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var itemDetailsViewCenterYConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemQuantityLabel: UILabel!
    @IBOutlet weak var totalMassLabel: UILabel!
    @IBOutlet weak var totalMetalContentLabel: UILabel!
    @IBOutlet weak var totalUnitValueLabel: UILabel!
    @IBOutlet weak var totalMonetaryValueLabel: UILabel!
    
    @IBOutlet weak var unitMetalContentLabel: UILabel!
    
    @IBOutlet weak var collectibleIsActiveSwitch: UISwitch!
    
    @IBOutlet weak var collectibleIsActiveLabel: UILabel!
    
    
    @IBAction func activateCollectible(_ sender: UISwitch) {
        
        let labelText = collectibleIsActiveSwitch.isOn ? "Deactivate":"Activate"
        collectibleIsActiveLabel.text = labelText
        
        if let currentlySelectedCollectibleIdx = self.currentlySelectedItem, let collectibleManager = self.collectibleManager, let rawValue = collectibleManager.getCollectibleAtIndex(index: currentlySelectedCollectibleIdx)?.getCollectibleType().rawValue {
            
            let userInfo: [String:Any] = [
                "collectibleRawValue":rawValue,
                "isActive":collectibleIsActiveSwitch.isOn
            ]
            
            NotificationCenter.default.post(name: Notification.Name.GetDidActivateCollectibleNotificationName(), object: nil, userInfo: userInfo)
            
            if collectibleIsActiveSwitch.isOn, let currentIdx = self.currentlySelectedItem, collectibleManager.getCollectibleAtIndex(index: currentIdx)?.getCollectibleType().rawValue == CollectibleType.Camera.rawValue{
                
                showAlertController(title: "Activate Camera", message: "To get a portrait, activate the camera.", confirmationTitle: "Okay", cancellationTitle: "Cancel", confirmationHandler: nil, cancellationHandler: nil, completion: nil)
            }
            
        }
    }
    
    
    @IBOutlet weak var skView: SKView!
    
    @IBOutlet weak var itemCollectionView: UICollectionView!
    
    @IBOutlet weak var itemViewingWindow: UIView!
    
  
    @IBOutlet weak var itemWindowHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var itemViewWindowCenterXConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var itemViewWindowCenterYConstraint: NSLayoutConstraint!
    
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
        
        self.gameStatsViewCenterXConstraint.constant = -2000
        
        self.itemCollectionView.delegate = self
        self.itemCollectionView.dataSource = self
        
        self.itemViewWindowCenterXConstraint.constant = -UIScreen.main.bounds.size.width*2
        self.itemDetailsViewCenterXConstraint.constant = -UIScreen.main.bounds.size.width*2
        registerNotifications()

        self.view.backgroundColor = UIColor.orange
        
        
        loadGame()
        
        becomeFirstResponder()
       
    }
    
    
    
    
    func showGameStatsView(){
        
        self.gameStatsViewCenterXConstraint.constant += 2000
        
        UIView.animate(withDuration: 1.50, delay: 0.00, options: .curveEaseOut, animations: {
            
            self.view.layoutIfNeeded()
        }, completion: {
            
            isFinishedAnimating in
            
            if(isFinishedAnimating){
                
                DispatchQueue.global().async {
                    
                    //Fetch game stat data
                    //TODO....

                    DispatchQueue.main.sync {
                        
                        //update labels
                        //TODO....
                        
                        self.gameStatsViewCenterXConstraint.constant += 2000
                        
                        UIView.animate(withDuration: 1.50, delay: 2.00, options: .curveEaseIn, animations: {
                            
                            self.view.layoutIfNeeded()
                            
                        }, completion: {
                            
                            isFinishedAnimating in
                            
                            if(isFinishedAnimating){
                                
                                self.gameStatsViewCenterXConstraint.constant = -2000
                                
                            }
                            
                        })
                    }
                }
                
               
                
            }
            
        })
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if(event?.subtype == UIEventSubtype.motionShake){
            if collectibleManager != nil, collectibleManager!.getActiveStatusFor(collectibleType: .Grenade){
                
                NotificationCenter.default.post(name: Notification.Name.GetDidSetOffGrenadeNotificationName(), object: nil, userInfo: nil)

            }
        }
    }
   
    
    func loadGame(){
        
        
            
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

            
        
        
        
    }
    
    @IBAction func dismissItemViewingWindow(_ sender: Any) {
        
        if(itemDetailsAreDisplayed){
            self.dismissItemDetails()
            
        }
        
        self.itemViewWindowCenterXConstraint.constant = -UIScreen.main.bounds.size.width*2
        self.itemDetailsViewCenterXConstraint.constant = -UIScreen.main.bounds.size.width*2
        
        
        self.view.layoutIfNeeded()
      
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
    
    
    
    func registerNotifications(){
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(showCollectionView), name: Notification.Name(rawValue:Notification.Name.ShowInventoryCollectionViewNotification), object: nil)
        
    
        
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
    
   
    
    func showAlertController(title: String, message: String, confirmationTitle: String, cancellationTitle: String, confirmationHandler: ((UIAlertAction) -> Void)?, cancellationHandler: ((UIAlertAction) -> Void)?, completion: (() -> Void)?){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        
        let okay = UIAlertAction(title: confirmationTitle, style: .default, handler: confirmationHandler)
        
        let cancel = UIAlertAction(title: cancellationTitle, style: .cancel, handler: cancellationHandler)
        
        alertController.addAction(okay)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: completion)
    }

    
    
}

