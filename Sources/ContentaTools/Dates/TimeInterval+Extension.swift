//
//  TimeInterval+Extension.swift
//

import Foundation

extension TimeInterval {
    public static var second: TimeInterval { return 1           }
    public static var minute: TimeInterval { return second * 60 }
    public static var hour: TimeInterval   { return minute * 60 }
    public static var day: TimeInterval    { return hour * 24   }
    public static var week: TimeInterval   { return day * 7     }
    public static var month: TimeInterval  { return day * 30    }
    public static var year: TimeInterval   { return day * 365   }
}
