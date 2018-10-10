//
//  PercentsViewController.swift
//  RecieptApp
//
//  Created by Brice Redmond on 9/5/18.
//  Copyright © 2018 Brice Redmond. All rights reserved.
//

import UIKit

class PercentsViewController: UIViewController {
    
    @IBOutlet weak var taxTextField: UITextField!
    @IBOutlet weak var tipTextField: UITextField!
    @IBOutlet weak var automaticGratuityTextField: UITextField!
    
    var tax: String?
    var tip: String?
    var autoGrat: String?
    
    var groups: [Group] = []
    var paymentButtons: [PaymentButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(tax != nil)
        {
            taxTextField.text = tax
            tipTextField.text = tip
            automaticGratuityTextField.text = autoGrat
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is UINavigationController {
            if segue.destination.childViewControllers[0] is FinalViewController
            {
                let finalVC = segue.destination.childViewControllers[0] as? FinalViewController
                finalVC?.groups = groups
                finalVC?.paymentButtons = paymentButtons
                finalVC?.autoGrat = Double((automaticGratuityTextField?.text)!)
                finalVC?.tip = Double((tipTextField?.text)!)
                finalVC?.tax = Double((taxTextField?.text)!)
            }else if segue.destination.childViewControllers[0] is OrganizationViewController {
                let orgVC = segue.destination.childViewControllers[0] as? OrganizationViewController
                orgVC?.instantiatedBefore = true
                orgVC?.paymentButtons = paymentButtons
                orgVC?.groups = groups
                orgVC?.autoGrat = automaticGratuityTextField.text
                orgVC?.tax = taxTextField.text
                orgVC?.tip = tipTextField.text
                
            }
        }
    }
    
    
    @IBAction func donePressed(_ sender: Any) {
        
        if taxTextField.text == nil {
            taxTextField.text = "0"
        }
        
        if automaticGratuityTextField.text == nil {
            automaticGratuityTextField.text = "0"
        }
        
        if tipTextField.text == nil {
            tipTextField.text = "0"
        }
        
        if let _ = Double((taxTextField?.text)!), let _ = Double((tipTextField?.text)!),
            let _ = Double((automaticGratuityTextField?.text)!){
             self.performSegue(withIdentifier: "PercentsToFinal", sender: nil)
            
        }else {
            print("One of the text fields has been inputted incorrectly!")
            return
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "PercentsToOrg", sender: nil)
        
    }
}
