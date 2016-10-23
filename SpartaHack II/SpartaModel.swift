//
//  FakeModel.swift
//  SpartaHack 2016
//
//  Created by Chris McGrath on 9/9/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//

import Foundation
import Alamofire


class SpartaModel: NSObject {

    
    override init () {
        super.init()
        
        Alamofire.request("https://d.api.spartahack.com/announcements").responseJSON { response in
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }
        
    }
    
    func printAnnouncements () {
        let announce = Announcements.sharedInstance
        
        print(announce.spartaAnnouncements)
    }
}
