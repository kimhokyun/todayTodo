//
//  TodoCell.swift
//  TodoNoty
//
//  Created by 임병철 on 2023/05/25.
//

import Foundation
import UIKit

class TodoCell:UITableViewCell, TableCell {
    
    @IBOutlet weak var dateLB:UILabel!
    @IBOutlet weak var titleLB:UILabel!
    
    func updateCell(_ todo:Todo) {
        dateLB.text = todo.displayDate
        titleLB.text = todo.title
    }
}
