//
//  MapLocation.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/14/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit
import MapKit

class MapLocation: Collectible{
    
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D?
    
    convenience init(latitude: CLLocationDegrees, longitude: CLLocationDegrees, title: String?, subtitle: String?) {
        
        self.init(withCollectibleType: .CompassPointB)
        self.title = title
        self.subtitle = subtitle
        self.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        
    }
    
    override init(withCollectibleType someCollectibleType: CollectibleType) {
        super.init(withCollectibleType: someCollectibleType)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
