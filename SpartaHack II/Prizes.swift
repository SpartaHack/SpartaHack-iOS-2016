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
    
    private var sponsorPrizes: [Prize] = []
    
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
        
        for obj in sponsorPrizes {
            if obj.id == prize.id {
                valid = false
            }
        }
        
        if valid {
            // if able to get the sponsor name it's all good.
            if prize.getPrizeSponsor() != nil {
                sponsorPrizes.append(prize)
            } else {
                spartaPrizes.append(prize)
            }
        }
        
    }
    
    func listOfPrizes () -> [Prize] {
        let rankSortDescriptor = NSSortDescriptor(key: "rank", ascending: true)
        spartaPrizes = (spartaPrizes as NSArray).sortedArray(using: [rankSortDescriptor]) as! Array
        return spartaPrizes
    }
    
    func listOfSponsorPrizes () -> [Prize] {
        let rankSortDescriptor = NSSortDescriptor(key: "rank", ascending: true)
        sponsorPrizes = (sponsorPrizes as NSArray).sortedArray(using: [rankSortDescriptor]) as! Array
        return sponsorPrizes
    }
}
