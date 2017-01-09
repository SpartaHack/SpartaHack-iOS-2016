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
    private var spartaSchedule: [Event] = []
    var weekdayDictionary: [Int:Int] = [:] // 1:5 means Sunday 5 events. 3:3 meants Tuesday has 3 events.
    
    // singleton for schedule 
    static let sharedInstance = Schedule()
    
    override init () {
        super.init()
    }
    
    func addEvent(event:Event) {
        // add event to schedule
        var valid = true
        
        for obj in spartaSchedule {
            // check to see if the id exists in our array
            if event.id == obj.id {
                // reject new entry
                valid = false
            }
        }
        
        if valid {
            spartaSchedule.append(event)
            if let eventDate = event.time {
                let weekday = stringForWeekday(for: eventDate)
                event.weekday = weekday
                self.addWeekday(day: intForWeekday(for: eventDate))
            }
        }
    }
    
    func listOfEvents () -> [Event] {
        return spartaSchedule
    }
    
    func addWeekday(day: Int) {
        if let currentCount = weekdayDictionary[day] {
            weekdayDictionary[day] = currentCount + 1
        } else {
            weekdayDictionary[day] = 1
        }
    }
    
    func numberOfWeekdays(for index: Int) -> Int {
        // Pretty gross, but this is how I handle conversions between the weekday dictionary and the table view section array
        let dictionaryIndex = Array(weekdayDictionary.keys)[index]
        var numberOfWeekdays = 0
        if let count = weekdayDictionary[dictionaryIndex] {
            numberOfWeekdays = count
        }
        return numberOfWeekdays
    }
    
    func stringForWeekday(for date: NSDate) -> String {
        let myCalendar = NSCalendar(calendarIdentifier: .gregorian)
        let myComponents = myCalendar?.components(.weekday, from: date as Date)
        let weekDay = myComponents?.weekday
        
        let dayString = DateFormatter().weekdaySymbols[weekDay! - 1]

        return dayString
    }
    
    func intForWeekday(for date: NSDate) -> Int {
        let myCalendar = NSCalendar(calendarIdentifier: .gregorian)
        let myComponents = myCalendar?.components(.weekday, from: date as Date)
        if let weekDay = myComponents?.weekday {
            return weekDay
        } else {
            return 1
        }
    }
     
}
