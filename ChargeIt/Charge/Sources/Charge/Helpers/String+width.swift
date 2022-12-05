//
//  File.swift
//  
//
//  Created by Александр Казак-Казакевич on 05.12.2022.
//

import Foundation
import UIKit

extension String {
    func width(withHeight height: CGFloat, font: UIFont) -> CGFloat {
        let rect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = (self as NSString).boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}
