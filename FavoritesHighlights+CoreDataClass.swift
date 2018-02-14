//
//  FavoritesHighlights+CoreDataClass.swift
//  MLBHighlights iPad
//
//  Created by Ramon Geronimo on 12/25/17.
//  Copyright © 2017 Ramon Geronimo. All rights reserved.
//
//

import Foundation
import CoreData

@objc(FavoritesHighlights)
public class FavoritesHighlights: NSManagedObject {
    convenience init(headline: String, player: String, url: String, team: String, context: NSManagedObjectContext) {
        
        if let ent = NSEntityDescription.entity(forEntityName: "FavoritesHighlights", in: context) {
            
            self.init(entity: ent, insertInto: context)
            self.headline   = headline
            self.player  = player
            self.url = url
            self.team = team
            
        } else {
            
            fatalError("Unable To Find Entity Name!")
        }
    }
}
