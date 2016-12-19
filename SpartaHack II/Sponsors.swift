//
//  Sponsors.swift
//  SpartaHack 2016
//
//  Created by Chris McGrath on 11/11/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//

import Foundation

class Sponsors: NSObject {
    // holds the collection of sponsors 
    private var spartaSponsors: [Sponsor] = []
    
    // Singleton for sponsors Collection
    static let sharedInstance = Sponsors()
    
    override init () {
        super.init()
    }
    
    func addSponsor(sponsor:Sponsor) {
        // adds announcement to our array
        var valid = true
        
        for obj in spartaSponsors {
            // check to see if the id exists in our array
            if obj.id == sponsor.id {
                // reject new entry
                valid = false
            }
        }
        
        if valid {
            spartaSponsors.append(sponsor)
        }
        
    }
    
    func listOfSponsors () -> [Sponsor] {
        return spartaSponsors
    }

}
