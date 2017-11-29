//
//  ExpensesViewController.swift
//  Expenses
//
//  Created by David Auger on 11/27/17.
//  Copyright © 2017 David Auger. All rights reserved.
//

import UIKit
import CoreData

class ExpensesViewController: UIViewController {

    @IBOutlet weak var expensesTableView: UITableView!
    
    let dateFormatter = DateFormatter()
    var expenses = [ Expense ]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        dateFormatter.timeStyle = .long
        dateFormatter.dateStyle = .long

    }
    
    override func viewWillAppear( _ animated: Bool )
    {
        guard let app_delegate = UIApplication.shared.delegate as? AppDelegate
        else
        {
            return
        }
        
        let managed_context = app_delegate.persistentContainer.viewContext
        let fetch_request: NSFetchRequest<Expense> = Expense.fetchRequest()
        
        do
        {
            expenses = try managed_context.fetch( fetch_request )
            expensesTableView.reloadData()
        }
        catch
        {
            print( "Fetch could not be performed" )
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addNewExpense( _ sender: Any )
    {
        performSegue( withIdentifier: "showExpense", sender: self )
    }
    
    override func prepare( for segue: UIStoryboardSegue, sender: Any? )
    {
        guard let destination  = segue.destination as? SingleExpenseViewController,
              let selected_row = self.expensesTableView.indexPathForSelectedRow?.row
        else
        {
            return
        }
        
        destination.existing_expense = expenses[ selected_row ]
    }
    
    func deleteExpense( at indexPath: IndexPath )
    {
        let expense = expenses[ indexPath.row ]
        
        if let managed_context = expense.managedObjectContext
        {
            managed_context.delete( expense )
            
            do
            {
                try managed_context.save()
                
                self.expenses.remove( at: indexPath.row )
                expensesTableView.deleteRows( at: [ indexPath ], with: .automatic )
            }
            catch
            {
                print( "Delete failed" )
                expensesTableView.reloadRows( at: [indexPath], with: .automatic )
            }
        }
    }
}

extension ExpensesViewController: UITableViewDataSource
{
    func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int ) -> Int
    {
        return expenses.count
    }
    
    func tableView( _ tableView: UITableView, cellForRowAt indexPath: IndexPath ) -> UITableViewCell
    {
        let cell = expensesTableView.dequeueReusableCell( withIdentifier: "expenseCell", for: indexPath )
        
        let expense = expenses[ indexPath.row ]
        
        cell.textLabel?.text = expense.name
        
        if let date = expense.date
        {
            cell.detailTextLabel?.text = dateFormatter.string( from: date )
        }
        
        return cell
    }
    
    func tableView( _ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath )
    {
        if editingStyle == .delete
        {
            deleteExpense( at: indexPath )
        }
    }
}

extension ExpensesViewController: UITableViewDelegate
{
    func tableView( _ tableView: UITableView, didSelectRowAt indexPath: IndexPath )
    {
        performSegue( withIdentifier: "showExpense", sender: self )
    }
}


