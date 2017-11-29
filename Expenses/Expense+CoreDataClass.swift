//
//  Expense+CoreDataClass.swift
//  Expenses
//
//  Created by David Auger on 11/27/17.
//  Copyright © 2017 Tech Innovator. All rights reserved.
//
//

import UIKit
import CoreData

@objc( Expense )
public class Expense: NSManagedObject
{
    var date: Date?
    {
        get
        {
            return raw_date as Date?
        }
        set
        {
            raw_date = newValue as NSDate?
        }
    }
    
    convenience init?( name: String?, amount: Double, date: Date? )
    {
        let app_delegate = UIApplication.shared.delegate as? AppDelegate
        
        guard let managed_context = app_delegate?.persistentContainer.viewContext
        else
        {
            return nil
        }
        
        self.init( entity: Expense.entity(), insertInto: managed_context )
        
        self.name   = name
        self.amount = amount
        self.date   = date
    }
}
