//
//  RootTabBar.swift
//  
//
//  Created by Александр Казак-Казакевич on 02.12.2022.
//

import UIKit

public class RootTabBar: UITabBarController {
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        
        UIView.appearance().tintColor = .systemOrange
        UIButton.appearance().backgroundColor = .systemOrange
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIViewController
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        viewControllers = [Search.build()]
    }
}
