//
//  ViewController.swift
//  RecieptApp
//
//  Created by Brice Redmond on 7/15/18.
//  Copyright © 2018 Brice Redmond. All rights reserved.
//

import UIKit

class OrganizationViewController: UIViewController {
    
    @IBOutlet weak var currentGroupLabel: UILabel!
    @IBOutlet var currentGroupButton: UIButton?
    
    @IBOutlet weak var disableSplitDelete: UIButton!
    
    var groups: [Group] = []
    var paymentButtons: [PaymentButton] = []
    var currentPaymentButton: PaymentButton?
    var numGroups: Int?
    var payments: String?
    
    var instantiatedBefore: Bool?
    
    var tax: String?
    var tip: String?
    var autoGrat: String?
    
    @IBOutlet weak var GroupStack: UIStackView!
    @IBOutlet weak var PaymentsStack: UIStackView!
    
    @IBOutlet weak var SplitDeleteStack: UIStackView!
    
    @IBOutlet weak var textFieldLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        addGroupButtons(instantiatedBefore!)
        
        if !paymentButtons.isEmpty {
            for i in 0...paymentButtons.count - 1 {
                var group = paymentButtons[i].group
                let price = paymentButtons[i].price
                paymentButtons.remove(at: i)
                if(group != nil){
                    if group!.number > numGroups! {
                        group = nil
                    }
                }
                createPriceButton(price: price!,
                                  group: group, index: i)
            }
        }else{
            addPaymentButtons()
        }
    }
    
    func addGroupButtons(_ instantiatedBefore: Bool) {
        if(!instantiatedBefore) {
            groups.append(Group(groupNumber: 1))
        }else{
            groups[0].paymentRequired = 0
            numGroups = groups.count
        }
        
        let firstButton = createGroupButton(groupNumber: 1)
        firstButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        currentGroupButton = firstButton
        currentGroupLabel.text = firstButton.titleLabel?.text
        GroupStack.addArrangedSubview(firstButton)
        
        for i in 2...numGroups! {
            if(!instantiatedBefore) {
                groups.append(Group(groupNumber: i))
            }
            groups[i - 1].paymentRequired = 0
            GroupStack.addArrangedSubview(createGroupButton(groupNumber: i))
        }
    }
    
    func createGroupButton(groupNumber i: Int) -> UIButton{
        let button = RoundedButton(frame: CGRect(x: 0, y: 0, width: 187.5, height: 30))
        button.awakeFromNib()
        button.layoutSubviews()
        button.setTitle("Group: " + String(i), for: .normal)
        button.setTitleColor(UIColor.black, for: [])
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.addTarget(self, action: #selector(groupButtonPressed(_:)), for: .touchUpInside)
        
        return button
    }
    
    func addPaymentButtons() {
        let paymentsArray = payments!.components(separatedBy: CharacterSet.newlines)
        for line in paymentsArray{
            print(line)
            if let number = parseNumber(text: line) {
                createPriceButton(price: number, group: nil, index: nil)
            }
        }
    }
    
    func parseNumber(text: String) -> Double? {
        let acceptedLetters = Array(0...9).map(String.init) + ["."]
        
        let characters = text
            
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "o", with: "0")
            .replacingOccurrences(of: ",", with: ".")
            .filter({ acceptedLetters.contains(String($0)) })
        
        return Double(String(characters))
    }
    
    func createPriceButton(price: Double, group: Group?, index: Int?){
        let button = PaymentButton(frame: CGRect(x: 0, y: 0, width: 187.5, height: 30))
        button.awakeFromNib()
        button.layoutSubviews()
        button.price = price
        
        let formattedAmount = String(format: "$%.02f", price)
        button.setTitle(String(formattedAmount), for: .normal)
        button.setTitleColor(UIColor.black, for: [])
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        let uIGest = UILongPressGestureRecognizer(target: self, action: #selector(longPressPriceButton(_:)))
        button.addGestureRecognizer(uIGest)
        button.addTarget(self, action: #selector(priceButtonPressed(_:)), for: .touchUpInside)
        
        if(group != nil) {
            button.changeGroup(groupGiven: groups[(group?.number)! - 1])
        }
        
        if index != nil{
            paymentButtons.insert(button, at: index!)
            PaymentsStack.insertArrangedSubview(button, at: index!)
        }else{
            paymentButtons.append(button)
            PaymentsStack.addArrangedSubview(button)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func groupButtonPressed(_ sender: UIButton) {
        currentGroupLabel.text = sender.titleLabel?.text
        currentGroupButton?.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        currentGroupButton = sender
        currentGroupButton?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        
    }
    
    @IBAction func priceButtonPressed(_ sender: PaymentButton) {

        let stringArr = currentGroupButton?.titleLabel?.text?.components(separatedBy: " ")
        let groupNumber = Int((stringArr?.last)!)
    
        sender.changeGroup(groupGiven: groups[groupNumber! - 1])
        
    }
    
    func split(_ sender: PaymentButton, numSplits: Int) {
        if(numSplits < 2) {
            return
        }
        
        let groupNumber = sender.group?.number
        var percentTotal = sender.price! / Double(numSplits)
        percentTotal = round(100 * Double(percentTotal))/100
        if(groupNumber != nil) {
            sender.setTitle(String(groupNumber!) + "-" + String(percentTotal), for: UIControlState.normal)
            groups[groupNumber! - 1].paymentRequired -= sender.price! - percentTotal
        }else {
             sender.setTitle("$" + String(percentTotal), for: UIControlState.normal)
        }
        
         sender.price = percentTotal
        
        for _ in 1...numSplits - 1 {
            createPriceButton(price: percentTotal, group: nil, index: paymentButtons.index(of: sender)! + 1)
        }
        return
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination.childViewControllers[0] is PercentsViewController
        {
            let percentVC = segue.destination.childViewControllers[0] as? PercentsViewController
            percentVC?.groups = groups
            
            percentVC?.paymentButtons = paymentButtons
            
            if(tax != nil) {
                percentVC?.autoGrat = autoGrat
                percentVC?.tax = tax
                percentVC?.tip = tip
            }
        }
        
        if segue.destination.childViewControllers[0] is GroupAmtViewController
        {
            let grpVC = segue.destination.childViewControllers[0] as? GroupAmtViewController
            for button in paymentButtons {
                grpVC?.paymentButtons.append(button)
            }
            grpVC?.paymentButtons = paymentButtons
            
        }
        
        paymentButtons.removeAll()
    }
    
    func restartButtons() {
        for PaymentButton in paymentButtons {
            PaymentButton.restart()
        }
    }

    @IBAction func donePressed(_ sender: Any) {
        
        for button in paymentButtons {
            if(button.group == nil) {
                print("Payment of " + String(button.price!) + " was never given a group")
                return
            }
        }
        
        self.performSegue(withIdentifier: "OrgToPercents", sender: nil)
    }
    
    @IBAction func backPressed(_ sender: Any) {
        groups = []
        paymentButtons = []
    }
    
    @IBAction func longPressPriceButton(_ gestureRecognizer: UILongPressGestureRecognizer) {
         if gestureRecognizer.state == .began {
            
            if(gestureRecognizer.view is PaymentButton) {
                currentPaymentButton = gestureRecognizer.view as? PaymentButton
            }
            
            let frame = gestureRecognizer.view?.frame
//
//            splitDeleteStackTop.constant = -8 //offset that put them on the same level
//            splitDeleteStackTop.constant += (frame?.maxY)!
//            let newFrame = CGRect(x: (frame?.maxX)!, y: (frame?.maxY)!, width: SplitDeleteStack.frame.width, height: SplitDeleteStack.frame.height)
//            let newFrame = gestureRecognizer.view?.convert(frame!, to: super.view)
//            SplitDeleteStack.frame = newFrame!
        
            enableSplitDeleteStack(true)
        }
    }
    
    @IBAction func splitPressed(_ sender: Any) {
        enableSplitDeleteStack(false)
        enableTextFieldLabelAndEnter(true)
        textFieldLabel.text = "Enter the number of splits: "
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        enableSplitDeleteStack(false)
        deletePaymentButton(button: currentPaymentButton)
    }
    
    @IBAction func disableSplitDeletePressed(_ sender: Any) {
        enableSplitDeleteStack(false)
        enableTextFieldLabelAndEnter(false)
    }
    
    func enableSplitDeleteStack(_ turnOn: Bool) {
        SplitDeleteStack.isHidden = !turnOn
        SplitDeleteStack.isUserInteractionEnabled = turnOn
        disableSplitDelete.isUserInteractionEnabled = turnOn
    }
    
    func deletePaymentButton(button: PaymentButton?) {
        if(button != nil) {
            button!.changeGroup(groupGiven: nil)
            let index = paymentButtons.index(of: button!)
            paymentButtons.remove(at: index!)
            PaymentsStack.removeArrangedSubview(button!)
            currentPaymentButton = nil
        }
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        enableTextFieldLabelAndEnter(true)
        
        textFieldLabel.text = "Enter item price: "
        
    }
    
    func enableTextFieldLabelAndEnter(_ enable: Bool) {
        textField.isHidden = !enable
        textFieldLabel.isHidden = !enable
        enterButton.isHidden = !enable
        textField.isUserInteractionEnabled = enable
        enterButton.isUserInteractionEnabled = enable
    }
    
    @IBAction func enterPressed(_ sender: Any) {
        
        if let textFieldNum = Double((textField?.text)!) {
            if(currentPaymentButton == nil) {
                if(textField.text != nil && Double(textField.text!)! > 0) {
                    createPriceButton(price: Double(textField.text!)!, group: nil, index: nil)
                }
            }else{
                split(currentPaymentButton!, numSplits: Int(textFieldNum))
            }
            
            currentPaymentButton = nil
            
        }
         enableTextFieldLabelAndEnter(false)
    }
}

