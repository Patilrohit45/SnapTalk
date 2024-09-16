//
//  Date+Extenstions.swift
//  SnapTalk
//
//  Created by Rohit Patil on 01/09/24.
//

import Foundation

extension Date{
    
    /// if  today: 3:30 PM
    /// if yesterday returns Yesterday
    ///  02/15/25
    var dayOrTimeRepresentaion:String{
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        
        if calendar.isDateInToday(self){
            dateFormatter.dateFormat = "h:mm a"
            let formattedDate = dateFormatter.string(from: self)
            return formattedDate
        }else if calendar.isDateInYesterday(self){
            return "Yesterday"
        }else{
            dateFormatter.dateFormat = "MM/dd/yy"
            return dateFormatter.string(from: self)
        }
    }
    
    var formatToTime:String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let formattedDate = dateFormatter.string(from: self)
        return formattedDate
    }
    
    func toString(format:String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
