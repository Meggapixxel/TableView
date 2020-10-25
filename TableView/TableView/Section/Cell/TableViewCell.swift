//
//  TableViewCellModel.swift
//  TableView
//
//  Created by Vadym Zhydenko on 23.10.2020.
//

import UIKit

protocol TableViewCell: UITableViewCell {
    
    @discardableResult func configure(using model: TableViewCellModel) -> Self
    
}
