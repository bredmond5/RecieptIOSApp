//
//  FinalViewController.swift
//  RecieptApp
//
//  Created by Brice Redmond on 9/5/18.
//  Copyright © 2018 Brice Redmond. All rights reserved.
//

import UIKit

class FinalViewController: UIViewController {

    var tax: Double?
    var tip: Double?
    var autoGrat: Double?
    
    var groups: [Group] = []
    var paymentButtons: [PaymentButton] = []
    
    @IBOutlet weak var finalPaymentsStackView: UIStackView!
    
    @IBOutlet weak var finishedStackView: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(groups)
        
        var percentTotals: [Double] = []
        var totalPayment: Double = 0
        
        for group in groups {
            totalPayment += group.paymentRequired
        }
        
        for group in groups {
            percentTotals.append(group.paymentRequired/totalPayment)
        }
        
        calculateFinalPayments(totalPayment, percentTotals)
        
        for group in groups {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 187, height: 30))
            label.font = UIFont.systemFont(ofSize: 17)
            label.textColor = .black
            let formattedPayment = String(format: "$%.02f", group.finalPayment)
            label.text = "Group " + String(group.number) + " pays: " + formattedPayment
            finalPaymentsStackView.addArrangedSubview(label)
        }
        
        // Do any additional setup after loading the view.
    }
    
    func calculateFinalPayments(_ totalPayment: Double, _ percentTotals: [Double]) {
        var count = 0
        var paymentWithOther: Double = 0
        let taxDouble = Double(round(100 * (tax!))/100)
        let tipDouble = Double(round(100 * (tip!))/100)
        let autoGratDouble = Double(round(100 * (autoGrat!))/100)
        
        for percent in percentTotals {
            let taxAmt = percent * taxDouble
            let tipAmt = percent * tipDouble
            let autoGratAmt = percent * autoGratDouble
            groups[count].finalPayment = groups[count].paymentRequired + taxAmt + tipAmt + autoGratAmt
            groups[count].finalPayment = Double(round(100 * groups[count].finalPayment)/100)
            paymentWithOther += groups[count].finalPayment
            count += 1
        }
        
        fixPayment(totalPayment + taxDouble + tipDouble + autoGratDouble, paymentWithOther)
        
        print("total payment: " + String(totalPayment))
        print("payment made with other: " + String(paymentWithOther))
    }
    
    func fixPayment(_ totalPayment: Double, _ payment: Double){
        let difference = totalPayment - payment
        let groupToPay = Int(arc4random_uniform(UInt32(groups.count - 1)))
        groups[groupToPay].finalPayment += difference
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.destination.childViewControllers[0] is PercentsViewController {
            let percentVC = segue.destination.childViewControllers[0] as? PercentsViewController
            percentVC?.paymentButtons = paymentButtons
            percentVC?.groups = groups
            percentVC?.autoGrat = String(autoGrat!)
            percentVC?.tip = String(tip!)
            percentVC?.tax = String(tax!)
        }
        
    }

    @IBAction func backPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "FinalToPercents", sender: nil)
        
    }
    @IBAction func finishPressed(_ sender: Any) {
        swapStackViews(finishedEnabled: true)
    }
    
    func swapStackViews(finishedEnabled: Bool) {
        finalPaymentsStackView.isHidden = finishedEnabled
        finishedStackView.isHidden = !finishedEnabled
        finishedStackView.isUserInteractionEnabled = finishedEnabled
    }
    
    @IBAction func noPressed(_ sender: Any) {
        swapStackViews(finishedEnabled: false)
    }
    

}
