//
//  FakeModel.swift
//  SpartaHack 2016
//
//  Created by Chris McGrath on 9/9/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//

import Foundation


class SpartaModel: NSObject {

    
    override init () {
        super.init()
    }
    
    func printAnnouncements () {
        let announce = Announcements.sharedInstance
        
        print(announce.spartaAnnouncements)
    }
}
