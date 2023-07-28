//
//  Extension.swift
//  TodoNoty
//
//  Created by 임병철 on 2023/05/25.
//

import Foundation
import UIKit

extension String {
    func toDateFormat(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = self
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.amSymbol = "오전"
        formatter.pmSymbol = "오후"
        let defaultTimeZoneStr = formatter.string(from: date)
        
        return defaultTimeZoneStr
    }
    
    
}


public protocol Storyboarded {
    static func instantiate(_ name: String) -> Self
}

public extension Storyboarded where Self: UIViewController {
    static func instantiate(_ name: String) -> Self {
        // this pulls out "MyApp.MyViewController"
        let fullName = NSStringFromClass(self)

        // this splits by the dot and uses everything after, giving "MyViewController"
        let className = fullName.components(separatedBy: ".")[1]

        // load our storyboard
        let storyboard = UIStoryboard(name: name, bundle: Bundle.main)

        // instantiate a view controller with that identifier, and force cast as the type that was requested
        let vc = storyboard.instantiateViewController(withIdentifier: className) as! Self

        return vc
    }

}

public protocol TableCell {
    static func instantiate(_ tableView: UITableView) -> Self
}

public extension TableCell where Self: UITableViewCell {
    static func instantiate(_ tableView: UITableView) -> Self {

        let fullName = NSStringFromClass(self)

        let className = fullName.components(separatedBy: ".")[1]

        let cell = tableView.dequeueReusableCell(withIdentifier: className) as! Self

        return cell
    }
}
