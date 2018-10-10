//
//  MyButton.swift
//  RecieptApp
//
//  Created by Brice Redmond on 9/3/18.
//  Copyright © 2018 Brice Redmond. All rights reserved.
//

import Foundation
import UIKit

class PaymentButton: RoundedButton{
    var group: Group?
    var price: Double?
    
    func changeGroup(groupGiven: Group?) {
        if(group != nil) {
            group?.paymentRequired -= price!
        }
        
        if(groupGiven != nil) {
            group = groupGiven
            let groupNumber = String(group!.number)
            group?.paymentRequired += price!
            let formattedAmount = String(format: "$%.02f", price!)
            let newTitle = formattedAmount + " - Group " + groupNumber
            setTitle(newTitle, for: UIControlState.normal)
        }else{
            group = nil
        }
    }
    
    func restart() {
        group = nil
        let formattedAmount = String(format: "$%.02f", price!)
        setTitle(formattedAmount, for: UIControlState.normal)
    }
}
