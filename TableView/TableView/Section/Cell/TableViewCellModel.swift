//
//  TableViewCellModel.swift
//  TableView
//
//  Created by Vadym Zhydenko on 23.10.2020.
//

import Foundation

protocol TableViewCellModel {
    
    var viewClass: TableViewCellClass { get }
    var viewReuseIdentifier: String { get }
    var viewHeight: TableViewSubviewHeight { get }
    var selection: TableViewCellModelSelection { get }
    
}

extension TableViewCellModel {
    
    var viewReuseIdentifier: String { String(describing: viewClass.value) }
    var viewHeight: TableViewSubviewHeight { .fill }
    var selection: TableViewCellModelSelection { .none }
    
}
