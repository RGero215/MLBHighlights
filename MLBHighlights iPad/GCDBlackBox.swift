//
//  GCDBlackBox.swift
//  MLBHighlights iPad
//
//  Created by Ramon Geronimo on 12/25/17.
//  Copyright © 2017 Ramon Geronimo. All rights reserved.
//

import Foundation
func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
