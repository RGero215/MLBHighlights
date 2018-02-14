//
//  FavoritesHighlights+CoreDataProperties.swift
//  MLBHighlights iPad
//
//  Created by Ramon Geronimo on 12/25/17.
//  Copyright © 2017 Ramon Geronimo. All rights reserved.
//
//

import Foundation
import CoreData


extension FavoritesHighlights {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoritesHighlights> {
        return NSFetchRequest<FavoritesHighlights>(entityName: "FavoritesHighlights")
    }

    @NSManaged public var headline: String?
    @NSManaged public var player: String?
    @NSManaged public var team: String?
    @NSManaged public var url: String?

}
