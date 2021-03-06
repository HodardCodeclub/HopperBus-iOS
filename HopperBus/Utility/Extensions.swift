//
//  Extensions.swift
//  HopperBus
//
//  Created by Tosin Afolabi on 22/08/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

import UIKit

extension UIColor {

    class func HopperBusBrandColor() -> UIColor {
        return UIColor(red: 0.000, green: 0.294, blue: 0.416, alpha: 1.0)
    }
}

extension UIImage {

    class func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)

        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect);

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();

        return image
    }
}

extension Array {
    func flattenToString() -> String {
        var finalString = ""
        for (_, str) in self.enumerate() {
            let s = str as! String
            let ss = s.stringByReplacingOccurrencesOfString(":", withString: ".", options: .LiteralSearch, range: nil)
            finalString += "\(ss) "
        }
        return finalString
    }
}

extension String {
    func doubleValue() -> Double
    {
        let minusAscii: UInt8 = 45
        let dotAscii: UInt8 = 46
        let zeroAscii: UInt8 = 48

        var res = 0.0
        let ascii = self.utf8

        var whole = [Double]()
        var current = ascii.startIndex

        let negative = current != ascii.endIndex && ascii[current] == minusAscii
        if (negative)
        {
            current = current.successor()
        }

        while current != ascii.endIndex && ascii[current] != dotAscii
        {
            whole.append(Double(ascii[current] - zeroAscii))
            current = current.successor()
        }

        //whole number
        var factor: Double = 1
        for var i = whole.count - 1; i >= 0; i--
        {
            res += Double(whole[i]) * factor
            factor *= 10
        }

        //mantissa
        if current != ascii.endIndex
        {
            factor = 0.1
            current = current.successor()
            while current != ascii.endIndex
            {
                res += Double(ascii[current] - zeroAscii) * factor
                factor *= 0.1
                current = current.successor()
            }
        }

        if (negative)
        {
            res *= -1;
        }
        
        return res
    }

    subscript (i: Int) -> String {
        return String(Array(arrayLiteral: self)[i])
    }

    func replace(target: String, withString: String) -> String {
        return self.stringByReplacingOccurrencesOfString(target, withString: withString, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
}

extension NSDate {

    class func isSaturday() -> Bool {
        if NSDate.getDay() == 7 { return true }
        return false
    }

    class func isSunday() -> Bool {
        if NSDate.getDay() == 1 { return true }
        return false
    }

    class func isWeekend() -> Bool {
        let weekday = NSDate.getDay()
        if weekday == 1 || weekday == 7 {
            return true
        }
        return false
    }

    class func isHoliday() -> Bool {

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"

        let termDates = [
            "autumnTermBeginDate": dateFormatter.dateFromString("17-09-2015")!,
            "autumnTermEndDate": dateFormatter.dateFromString("11-12-2015")!,
            "springTermBeginDate": dateFormatter.dateFromString("11-01-2016")!,
            "springTermEndDate": dateFormatter.dateFromString("18-03-2016")!,
            "summerTermBeginDate":  dateFormatter.dateFromString("18-04-2016")!,
            "summerTermEndDate": dateFormatter.dateFromString("17-06-2016")!
        ]

        let today = NSDate()

        let isAutumnTerm = NSDate.isDate(today, inRangeFirstDate: termDates["autumnTermBeginDate"]!, lastDate: termDates["autumnTermEndDate"]!)
        let isSpringTerm = NSDate.isDate(today, inRangeFirstDate: termDates["springTermBeginDate"]!, lastDate: termDates["springTermEndDate"]!)
        let isSummerTerm = NSDate.isDate(today, inRangeFirstDate: termDates["summerTermBeginDate"]!, lastDate: termDates["summerTermEndDate"]!)

        if isAutumnTerm || isSpringTerm || isSummerTerm {
            return false
        }

        return true
    }

    class func isOutOfService() -> Bool {

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"

        let outOfServiceDay1 = dateFormatter.dateFromString("02-05-2016")!
        let outOfServiceDay2 = dateFormatter.dateFromString("30-05-2016")!

        let today = NSDate()

        if NSDate.isSameDay(today, asSecondDate: outOfServiceDay1) || NSDate.isSameDay(today, asSecondDate: outOfServiceDay2) {
            return true
        }

        let outOfServiceDates = [
            "range1Start": dateFormatter.dateFromString("24-12-2015")!,
            "range1End": dateFormatter.dateFromString("03-01-2016")!,
            "range2Start": dateFormatter.dateFromString("25-03-2016")!,
            "range2End": dateFormatter.dateFromString("29-03-2016")!,
            "range3Start":  dateFormatter.dateFromString("27-08-2015")!,
            "range3End": dateFormatter.dateFromString("29-08-2015")!
        ]

        let isInRange1 = NSDate.isDate(today, inRangeFirstDate: outOfServiceDates["range1Start"]!, lastDate: outOfServiceDates["range1End"]!)
        let isInRange2 = NSDate.isDate(today, inRangeFirstDate: outOfServiceDates["range2Start"]!, lastDate: outOfServiceDates["range2End"]!)
        let isInRange3 = NSDate.isDate(today, inRangeFirstDate: outOfServiceDates["range3Start"]!, lastDate: outOfServiceDates["range3End"]!)

        if isInRange1 || isInRange2 || isInRange3 {
            return true
        }

        return false
    }

    class func isDate(date: NSDate, inRangeFirstDate firstDate:NSDate, lastDate:NSDate) -> Bool {
        return !(date.compare(firstDate) == NSComparisonResult.OrderedAscending) && !(date.compare(lastDate) == NSComparisonResult.OrderedDescending)
    }

    class func getDay() -> Int {
        let date = NSDate()
        return NSCalendar.currentCalendar().component(.Weekday, fromDate: date)
    }

    class func isSameDay(firstDate: NSDate, asSecondDate secondDate: NSDate) -> Bool {
        let componentFlags: NSCalendarUnit = [ NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day ]
        let components1 = NSCalendar.currentCalendar().components(componentFlags, fromDate:firstDate)
        let components2 = NSCalendar.currentCalendar().components(componentFlags, fromDate:secondDate)
        return  ( (components1.year == components2.year) && (components1.month == components2.month) && (components1.day == components2.day) )
    }
    
    class func currentTimeAsString() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.stringFromDate(NSDate())
    }
}
