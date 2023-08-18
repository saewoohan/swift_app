//
//  TabBarViewController.swift
//  Talk-Messanger
//
//  Created by 한승우 on 2023/01/17.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.layer.borderWidth = 0.5
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
