//
//  GroupAmtViewController.swift
//  RecieptApp
//
//  Created by Brice Redmond on 8/20/18.
//  Copyright © 2018 Brice Redmond. All rights reserved.
//

import UIKit

class GroupAmtViewController: UIViewController {

    @IBOutlet weak var groupAmtTextField: UITextField!
    var payments: String?
    var paymentButtons: [PaymentButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        groupAmtTextField.borderStyle = UITextBorderStyle.roundedRect
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination.childViewControllers[0] is OrganizationViewController
        {
            let orgVC = segue.destination.childViewControllers[0] as? OrganizationViewController
            orgVC?.numGroups = Int((groupAmtTextField?.text)!)
            orgVC?.instantiatedBefore = false
            
            if(!paymentButtons.isEmpty) {
                orgVC?.paymentButtons = paymentButtons
                paymentButtons.removeAll()
            }else{
                orgVC?.payments = payments
            }
        }
    }
    
    @IBAction func donePressed(_ sender: Any)
    {
        if let numGroups = Int((groupAmtTextField?.text)!) {
            if(numGroups > 1) {
            
                self.performSegue(withIdentifier: "AmtToOrg", sender: nil)
                

            }else{
                print("Enter a number more than 1!")
            }
        }else{
            print("Enter a number of groups!")
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    
}
