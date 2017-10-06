//
//  MarketingPageController.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 10/6/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GoogleMobileAds
import WebKit

class MarketingPageController: UIViewController{
    
    @IBOutlet weak var bannerContainer: UIView!
    
    @IBOutlet weak var webView: WKWebView!
    
    
    
    @IBOutlet weak var webViewToBannerViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var webViewToSafetyTopConstraint: NSLayoutConstraint!
    
    
    
    lazy var bannerView: GADBannerView = {
        
        let adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        adBannerView.adUnitID = "ca-app-pub-3595969991114166/3880912913"
       
        adBannerView.delegate = self
        adBannerView.rootViewController = self
        
        return adBannerView
    }()
    
    var marketingPageURL: String?
    
    @IBOutlet weak var bannerContainerTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        loadMarketingPage()
        
        let request = GADRequest()
        bannerView.load(request)
    }
    
    public func loadMarketingPage(){
        
        if let marketingPageURL = self.marketingPageURL{
            let url = URL(string: marketingPageURL)!
            let urlRequest = URLRequest(url: url)
            webView.load(urlRequest)
            
        } else {
            print("Error: Failed to load marketing page URL")
        }
       
    }
    
}




extension MarketingPageController: GADBannerViewDelegate{
    
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
        
    bannerView.translatesAutoresizingMaskIntoConstraints = false
        
        self.bannerContainer.addSubview(bannerView)
        
        bannerView.frame = self.bannerContainer.frame
        
        webViewToSafetyTopConstraint.isActive = false
        webViewToBannerViewConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        
    }
    
    
}
