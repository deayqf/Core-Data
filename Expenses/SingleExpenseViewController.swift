//
//  SingleExpenseViewController.swift
//  Expenses
//
//  Created by David Auger on 11/27/17.
//  Copyright © 2017 David Auger. All rights reserved.
//

import UIKit

class SingleExpenseViewController: UIViewController
{
    @IBOutlet weak var nameTextField  : UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var datePicker     : UIDatePicker!
    
    var existing_expense: Expense?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "Add Expense"

        nameTextField.delegate   = self
        amountTextField.delegate = self
        
        nameTextField.text = existing_expense?.name
        
        if let amount = existing_expense?.amount
        {
            amountTextField.text = "\( amount )"
        }
        
        if let date = existing_expense?.date
        {
            datePicker.date = date
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    override func touchesBegan( _ touches: Set<UITouch>, with event: UIEvent? )
    {
        nameTextField.resignFirstResponder()
        amountTextField.resignFirstResponder()
    }
    
    @IBAction func saveExpense( _ sender: Any )
    {
        let name       = nameTextField.text
        let amountText = amountTextField.text ?? ""
        let amount     = Double( amountText ) ?? 0.0
        let date       = datePicker.date
        
        var expense: Expense?
        if let existing_expense = existing_expense
        {
            existing_expense.name   = name
            existing_expense.amount = amount
            existing_expense.date   = date
            
            expense = existing_expense
        }
        else
        {
            expense = Expense( name: name, amount: amount, date: date )
        }
        
        if let expense = expense
        {
            do
            {
                let managed_context = expense.managedObjectContext
                try managed_context?.save()
                
                self.navigationController?.popViewController( animated: true )
            }
            catch
            {
                print( "Context could not be saved" )
            }
        }
    }
}

extension SingleExpenseViewController: UITextFieldDelegate
{
    func textFieldShouldReturn( _ textField: UITextField ) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
}
