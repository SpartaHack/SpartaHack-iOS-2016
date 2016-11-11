//
//  Prizes.swift
//  SpartaHack 2016
//
//  Created by Chris McGrath on 11/11/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//

import Foundation

class Prizes: NSObject {
    // holds the collection of prizes
    private var spartaPrizes: [Prize] = []
    
    // Singleton for prizes collection
    static let sharedInstance = Prizes()
    
    override init () {
        super.init()
    }
    
    func addPrize(prize:Prize) {
        // adds announcement to our array
        var valid = true
        
        for obj in spartaPrizes {
            // check to see if the id exists in our array
            if obj.id == prize.id {
                // reject new entry
                valid = false
            }
        }
        
        if valid {
            spartaPrizes.append(prize)
        }
        
    }
    
    func listOfPrizes () -> [Prize] {
        return spartaPrizes
    }
}
