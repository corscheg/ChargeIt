//
//  RootTabBar.swift
//  
//
//  Created by Александр Казак-Казакевич on 02.12.2022.
//

import UIKit

public class RootTabBar: UITabBarController {

    // MARK: UIViewController
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        viewControllers = [Search.build()]
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        selectedIndex = 0
    }
}
