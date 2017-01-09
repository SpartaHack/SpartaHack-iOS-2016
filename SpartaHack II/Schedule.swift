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
    var weekdayToEventsDictionary: [Int:[Event]] = [:] // 1:[Event1, Event2, ...] means Sunday holds the events Event1, Event2, ...
    
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
                let weekdayInt = intForWeekday(for: eventDate)
                event.weekday = weekday
                if (weekdayToEventsDictionary[weekdayInt] != nil) {
                    weekdayToEventsDictionary[weekdayInt]?.insert(event, at: 0)
                } else {
                    weekdayToEventsDictionary[weekdayInt] = [event]
                }
            }
        }
    }
    
    func listOfEventsForWeekday(_ weekday: Int) -> [Event] {
        var eventsArray = Array(weekdayToEventsDictionary)[weekday].value
        eventsArray.sort(by: { $0.time?.compare($1.time as! Date) == ComparisonResult.orderedAscending })
        return eventsArray
    }
    
    func listOfEventsForSection(_ section: Int) -> [Event] {
        var weekdayToEventsArray = Array(weekdayToEventsDictionary)
        weekdayToEventsArray.sort { $0.key < $1.key }
        var events = weekdayToEventsArray[section].value
        events.sort(by: { $0.time?.compare($1.time as! Date) == ComparisonResult.orderedAscending })
        return events
    }
    
    func stringForSection(_ section: Int) -> String {
        var weekdayToEventsArray = Array(weekdayToEventsDictionary.keys)
        weekdayToEventsArray.sort { $0.hashValue < $1.hashValue }
        
        if weekdayToEventsArray[section] == 8 {
            return "Sunday"
        }
        
        let dayString = DateFormatter().weekdaySymbols[weekdayToEventsArray[section] - 1]
        return dayString
    }
    
    func intForWeekday(for date: NSDate) -> Int {
        let myCalendar = NSCalendar(calendarIdentifier: .gregorian)
        let myComponents = myCalendar?.components(.weekday, from: date as Date)
        if let weekDay = myComponents?.weekday {
            if weekDay == 1 {
                // Let's make Sunday 8 instead of 1. Seems hacky, but this way our sorting starts with Monday instead of Sunday.
                return 8
            }
            return weekDay
        } else {
            return 1
        }
    }
     
}
