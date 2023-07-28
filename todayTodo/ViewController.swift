//
//  ViewController.swift
//  TodoNoty
//
//  Created by 임병철 on 2023/05/25.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var tableVw:UITableView!
    
    var todoList = [Todo]() {
        didSet {
            tableVw.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableVw.dataSource = self
        tableVw.delegate = self
        
        let realm = try! Realm()
        todoList = Array(realm.objects(Todo.self)).sorted(by: { $0.id > $1.id })
        
        NotificationCenter.default.addObserver(self, selector: #selector(fromBg), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(fromBg), name: Notification.Name("Refresh"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("Refresh"), object: nil)
    }
    
    @objc func fromBg() {
        let realm = try! Realm()
        let now = Date().timeIntervalSince1970
        let dels = Array(realm.objects(Todo.self)).filter({ $0.date < now })
        let remain = Array(realm.objects(Todo.self)).filter({ $0.date > now })
        try! realm.write {
            for del in dels {
                realm.delete(del)
            }
            todoList = remain
        }
    }

    @IBAction func pressPlus() {
        let vc = DetailVC.instantiate("Main")
        vc.delegate = self
        present(vc, animated: true)
    }
}

extension ViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TodoCell.instantiate(tableView)
        cell.updateCell(todoList[indexPath.row])
        return cell
    }
}

extension ViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension ViewController:DetailDelegate {
    func registComplete() {
        let realm = try! Realm()
        todoList = Array(realm.objects(Todo.self)).sorted(by: { $0.id > $1.id })
        fromBg()
    }
}
