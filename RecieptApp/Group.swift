//
//  Group.swift
//  RecieptApp
//
//  Created by Brice Redmond on 9/3/18.
//  Copyright © 2018 Brice Redmond. All rights reserved.
//

import Foundation

class Group {
    var number: Int
    var paymentRequired: Double
    var finalPayment: Double
    
    init(groupNumber: Int) {
        paymentRequired = 0
        finalPayment = 0
        number = groupNumber
    }
}
