//
//  Channels.swift
//  SpartaHack 2017
//
//  Created by Chris McGrath on 1/16/17.
//  Copyright © 2017 Chris McGrath. All rights reserved.
//

import UIKit

class Channels: NSObject, NSCoding {
    var channels: [NSDictionary]
    
    init(channels: [NSDictionary]) {
        self.channels = channels
        
        super.init()
        saveChannels()
    }
    
    required init(coder decoder: NSCoder) {
        self.channels = decoder.decodeObject(forKey: "dictChannels") as! [NSDictionary]
    }
    
    func encode (with aCoder: NSCoder) {
        aCoder.encode(channels, forKey: "dictChannels")
    }
    
    func saveChannels () {
        var channelsToSave = [Channels]()
        channelsToSave.append(self)
        let savedData: Data = NSKeyedArchiver.archivedData(withRootObject: channelsToSave)
        let defaults = UserDefaults.standard
        defaults.set(savedData, forKey: "dictChannels")
        defaults.synchronize()
        print("Saved channels successfully")
    }
}
