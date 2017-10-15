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

class GameViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, UINavigationControllerDelegate {
    
    @IBOutlet weak var itemDescription: UILabel!
    
    var savedGame: SavedGame?
    
    var selectedGameLevel: GameLevel?
    
    var playerProfile: PlayerProfile? /**{
        
        get{
            
            /**
            if let navigationController = navigationController as? GameViewNavigationController{
                return navigationController.playerProfile
            }
             **/
            
            return nil
        }
        
        set(newPlayerProfile){
            
            /**
            if let navigationController = navigationController as? GameViewNavigationController{
                navigationController.playerProfile = newPlayerProfile
            }
             **/
        }
    } **/
    
    lazy var imagePicker: UIImagePickerController = {
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        return imagePicker
    }()
    
    
    
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
    
        if let currentIdx = self.currentlySelectedItem, let collectibleType = collectibleManager?.getCollectibleAtIndex(index: currentIdx)?.getCollectibleType(){
            
            let collectibleDetailInfo = collectibleType.getDetailInformation()
            let collectibleName = collectibleType.getCollectibleName()
            
            
            let alertController = UIAlertController(title: collectibleName, message: collectibleDetailInfo, preferredStyle: .alert)
            
            let okay = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alertController.addAction(okay)
            
            present(alertController, animated: true, completion: nil)
            
         
        }
        
        showAlertController(title: "", message: "", buttonTitle: "", buttonHandler: nil, completion: nil)
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
    
    var currentPlayer: Player?{
        
        return currentGameScene?.player
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
        
       itemDescription.isHidden = false
        itemDescription.isEnabled = false
    }
    
    
    /** The game view controller has to UINavigation Controller delegate ....**/
    /** check that camera is available **/
    
    /**
    var imagePicker: UIImagePickerController?{
        
        if let navigationController = navigationController as? GameViewNavigationController{
            return navigationController.imagePicker
        }
        
        return nil
    }
    **/
    
    /** When the player accepts the mission, open the media picker manager **/
    
    @objc func openMediaPickerManager(notification: Notification?) {
        
        /**
        guard let imagePicker = self.imagePicker else {
            print("Error: imagePicker not accessible")
            return
            
        }**/
        
        guard let sourceTypeStr = notification?.userInfo?["sourceType"] as? String else {
            print("Error: unable to access the notification's user info dictionary")
            return
        }
        
        let sourceType = sourceTypeStr == "camera" ? UIImagePickerControllerSourceType.camera : UIImagePickerControllerSourceType.savedPhotosAlbum
        
        imagePicker.sourceType = sourceType
        
        present(self.imagePicker, animated: true, completion: {
            
            if let gameScene = notification?.object as? GameScene{
                
                gameScene.run(SKAction.run {
                    gameScene.cameraMissionPrompt!.removeFromParent()
                    
                }, completion: {
                    
                })
            }
        })
        
    }

    var nonPlayerCharacterPrompt: SKSpriteNode?
    
    
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
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(showGameSavedConfirmation(notification:)), name: Notification.Name.GetDidSaveGameNotification(), object: nil)
        
        
        /**
        NotificationCenter.default.addObserver(self, selector: #selector(showActivityIndicator(notification:)), name: Notification.Name.GetDidRequestGameRestartNotification(), object: nil)


        NotificationCenter.default.addObserver(self, selector: #selector(removeActivityIndicator), name: Notification.Name.GetDidFinishRestartingGameNotification(), object: nil)
        **/
        
    }
  
    
    /**
    @objc func removeActivityIndicator(){
        
        if(self.activityIndicatorIsRunning){
            self.restartActivityIndicator.stopAnimating()
            self.activityIndicatorCenterXConstraint.constant = 2000
            self.activityIndicatorIsRunning = false
        }
        
    }
    
    @objc func showActivityIndicator(notification: Notification?){
        
        self.restartActivityIndicator.startAnimating()
        self.activityIndicatorCenterXConstraint.constant -= 2000
        self.activityIndicatorIsRunning = true
        
    }
 
     **/
    
    @objc func showGameSavedConfirmation(notification: Notification?){
        self.showAlertController(title: "Game Saved!", message: "Game Session for Level \(self.currentGameScene!.currentGameLevel.rawValue) has been saved!", buttonTitle: "Okay", buttonHandler: nil, completion: nil)
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
        
        if let selectedGameLevel = self.selectedGameLevel{
            
        
            currentGameScene = GameScene(currentGameLevel: selectedGameLevel, playerProfile: self.playerProfile!)
            
            guard let scene = self.currentGameScene else {
                fatalError("Error: failed to load game scene ")
            }
            
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            // Present the scene
                self.skView.presentScene(scene)

            
        
        } else if self.savedGame != nil {
            
            currentGameScene = GameScene(playerProfile: self.playerProfile!, savedGame: self.savedGame!)
            
            guard let scene = self.currentGameScene else {
                fatalError("Error: failed to load game scene ")
            }
            
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            // Present the scene
            self.skView.presentScene(scene)
            
            
            
        }
        
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
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(dismissCurrentViewController(notification:)), name: Notification.Name.GetDidRequestBackToMainMenuNotification(), object: nil)
    
        
    }
    
    @objc func dismissCurrentViewController(notification: Notification?){
        
        let removeActivityIndicator = {
            
            if let menuViewController = self.presentingViewController as? MainMenuController{
                
                menuViewController.activityIndicatorView.stopAnimating()
                
                menuViewController.activityIndicatorViewCenterYConstraint.constant = -1500
                menuViewController.gameStartOptionsBottomConstraint.constant = 0
                
            }
            
            
            if let levelChoiceController = self.presentingViewController as? LevelChoiceViewController{
                
                levelChoiceController.removeActivityIndicator()
                
            }
        }
        
        self.showAlertController(title: "Are you sure you want to quit?", message: "Click quit to go back to the main menu", confirmationTitle: "Quit", cancellationTitle: "Cancel", confirmationHandler: {
    
            alertAction in
            

            self.currentGameScene?.isPaused = true
            self.currentGameScene = nil
            self.skView.removeFromSuperview()
            
            
          
            
            self.dismiss(animated: true, completion:{
                
              
              
            })
            
        }, cancellationHandler: nil, completion: {
            
            removeActivityIndicator()
            
        })
        
    
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
    
   
    
    func showAlertController(title: String, message: String, buttonTitle: String, buttonHandler:((UIAlertAction) -> Void)?, completion: (()->(Void))?){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        
        let okay = UIAlertAction(title: buttonTitle, style: .default, handler: buttonHandler)
        
        alertController.addAction(okay)
        
        present(alertController, animated: true, completion: completion)
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



extension GameViewController: UIImagePickerControllerDelegate{
    
    
    /** The picked image can be stored in the player after dismissing the media picer controller or before; determine which one is more efficient **/
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            //save the picked image in the player
            
            self.currentPlayer!.pickedImage = pickedImage
            
            //property observer in the player posts a notification which can then be received by the NPC
        }
        
        
        
        picker.dismiss(animated: true, completion: {
            
            
            
        })
        
        
        
    }
    
    
}

