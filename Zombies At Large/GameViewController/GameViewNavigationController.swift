//
//  GameViewNavigationController.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 10/4/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import UIKit

class GameViewNavigationController: UINavigationController,UINavigationControllerDelegate{
    
    public var playerProfile: PlayerProfile?

    lazy var imagePicker: UIImagePickerController = {
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        return imagePicker
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let gameViewController = viewControllers.first as? GameViewController{
            gameViewController.playerProfile = playerProfile
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
}

extension GameViewNavigationController: UIImagePickerControllerDelegate{

    
    /** The picked image can be stored in the player after dismissing the media picer controller or before; determine which one is more efficient **/
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage, let gameViewController = viewControllers.first as? GameViewController{
            //save the picked image in the player
            gameViewController.currentPlayer!.pickedImage = pickedImage
            
            //property observer in the player posts a notification which can then be received by the NPC
        }
        
        
        
        picker.dismiss(animated: true, completion: {
            
            
            
        })
        
        
        
    }
    
    
}
