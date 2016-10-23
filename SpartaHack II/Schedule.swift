//
//  Schedule.swift
//  SpartaHack 2016
//
//  Created by Chris McGrath on 10/23/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//

import Foundation

class Schedule: NSObject {
    // holds collection of events 
    private var spartaScheulde: [Event] = []
    
    // singleton for schedule 
    static let sharedInstance = Schedule()
    
    override init () {
        super.init()
    }
    
    func addEvent(event:Event) {
        // add event to schedule 
        spartaScheulde.append(event)
    }
}
