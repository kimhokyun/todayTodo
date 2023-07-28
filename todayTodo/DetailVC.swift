//
//  DetailVC.swift
//  TodoNoty
//
//  Created by 임병철 on 2023/05/25.
//

import Foundation
import UIKit

protocol DetailDelegate:AnyObject {
    func registComplete()
}

class DetailVC:UIViewController, Storyboarded {
    
    @IBOutlet weak var picker:UIDatePicker!
    @IBOutlet weak var titleTF:UITextField!
    
    var todoTitle = ""
    var date:Double = 0
    
    weak var delegate:DetailDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.date = Date()
    }
    
    @IBAction func pressCancel() {
        view.endEditing(true)
        dismiss(animated: true)
    }
    
    @IBAction func pressSave() {
        view.endEditing(true)
        
        guard let t = titleTF.text, !t.isEmpty else {
            // 제목 입력 검사
            showAlert("제목을 입력해 주세요.")
            return
        }
        
        let dt = picker.date
        guard dt.timeIntervalSince1970 > Date().timeIntervalSince1970 else {
            // 데이트 피커 날짜 검사
            showAlert("현재보다 나중 시간대를 설정해 주세요.")
            return
        }
        
        let todo = Todo.createTodo(t, dt.timeIntervalSince1970)
        todo.insert()
        
        showAlert("할일이 등록되었습니다.") { [weak self] in
            self?.dismiss(animated: true) {
                self?.delegate?.registComplete()
            }
        }
    }
    
    
    func showAlert(_ msg:String,_ handler:(() -> Void)? = nil) {
        let alert = UIAlertController(title: "알림", message: msg, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default) { action in
            handler?()
        }
        alert.addAction(confirm)
        present(alert, animated: false)
    }
}

