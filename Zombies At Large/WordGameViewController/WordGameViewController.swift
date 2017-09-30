//
//  WordGameViewController.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/30/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit
import CoreData


class WordGameViewController: UIViewController{
    
    
    /** SpriteKit View: IBOutlets for Constraints **/
    
    @IBOutlet weak var spriteKitLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var spriteKitTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var spriteKitTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var spriteKitBottomConstraint: NSLayoutConstraint!
    
    
    /** Options (Picker) View: IBOutlets for Constraints **/

    
    @IBOutlet weak var optionsMenuCenterXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var optionsMenuCenterYConstraint: NSLayoutConstraint!
    
    
    /** IBOutlets and IBActions **/
    
    
    @IBOutlet weak var optionsMenu: UIPickerView!
    
    var optionsMenuIsOpen: Bool = false
    
    @IBOutlet weak var optionsButton: UIButton!
    
    @IBAction func showOptionsMenu(_ sender: UIButton) {
        
        self.optionsMenuCenterXConstraint.constant = optionsMenuIsOpen ? -2000: 0
        
        UIView.animate(withDuration: 0.50, animations: {
            
            
            self.view.layoutIfNeeded()
            
            self.optionsMenuIsOpen = !self.optionsMenuIsOpen
            
        })
    }
    
    
    
    override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
        
        self.optionsMenuCenterXConstraint.constant = -2000
        self.optionsMenu.dataSource = self
        self.optionsMenu.delegate = self
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}

extension WordGameViewController: UIPickerViewDataSource,UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return 10
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        return UIButton()
    }
    
    
}
