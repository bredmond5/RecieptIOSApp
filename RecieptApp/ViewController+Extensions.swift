//
//  ViewController+Extensions.swift
//  RecieptApp
//
//  Created by Brice Redmond on 9/21/18.
//  Copyright © 2018 Brice Redmond. All rights reserved.
//

import UIKit

extension UIViewController {
    func add(childController: UIViewController) {
        childController.willMove(toParentViewController: self)
        view.addSubview(childController.view)
        childController.didMove(toParentViewController: self)
    }
}
