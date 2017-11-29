//
//  Expense+CoreDataProperties.swift
//  Expenses
//
//  Created by David Auger on 11/27/17.
//  Copyright © 2017 David Auger. All rights reserved.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense>
    {
        return NSFetchRequest<Expense>( entityName: "Expense" )
    }

    @NSManaged public var name    : String?
    @NSManaged public var amount  : Double
    @NSManaged public var raw_date: NSDate?

}
