//
//  MaxCountTableViewCellDelegate.swift
//  
//
//  Created by Александр Казак-Казакевич on 24.12.2022.
//

import Foundation

protocol MaxCountTableViewCellDelegate: AnyObject {
    func maxCountDidChange(to index: Int)
}
