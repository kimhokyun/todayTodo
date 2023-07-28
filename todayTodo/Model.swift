//
//  Model.swift
//  TodoNoty
//
//  Created by 임병철 on 2023/05/25.
//

import Foundation
import RealmSwift
import UserNotifications

// Todo 테이블 정의
class Todo:Object {
    /// 생성시간을 기본키로 설정
    @Persisted(primaryKey: true) var id:String
    /// 제목
    @Persisted var title:String
    /// 알림 시간
    @Persisted var date:Double
    
    /// Record 인스턴스 생성
    static func createTodo(_ title:String,_ date:Double) -> Todo {
        let todo = Todo()
        todo.id = "\(Date().timeIntervalSince1970)".replacingOccurrences(of: ".", with: "")
        todo.title = title
        todo.date = date
        return todo
    }
    
    /// 목록에 표시할 시간
    var displayDate:String {
        return "[\(dateFormat)]"
    }
    
    /// 날짜 포맷
    var dateFormat:String {
        return "a hh:mm".toDateFormat(date: Date(timeIntervalSince1970: date))
    }
    
    /// 로컬 알림 등록
    func requestSendNoti() {
        let notiContent = UNMutableNotificationContent()
        notiContent.title = dateFormat
        notiContent.body = title

        let time = date - Date().timeIntervalSince1970
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)

        let request = UNNotificationRequest(
            identifier: id,
            content: notiContent,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { (error) in
            print(#function, error ?? "")
        }

    }
    
    /// DB Insert
    func insert() {
        requestSendNoti()
        let realm = try! Realm()
        try! realm.write {
            realm.add(self)
        }
    }

}
