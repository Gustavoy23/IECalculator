//
//  SecondViewController.swift
//  IEcalculator
//
//  Created by Gustavo on 12/28/18.
//  Copyright © 2018 Gustavo Sousa. All rights reserved.
//

import UIKit
import SQLite3
import Foundation

let sharedInstance = SecondViewController()


class SecondViewController: UIViewController {

    
    @IBOutlet weak var sa1: UITextField!
    @IBOutlet weak var sa2: UITextField!
    @IBOutlet weak var sa3: UITextField!
    
    @IBOutlet weak var sb1: UITextField!
    @IBOutlet weak var sb2: UITextField!
    @IBOutlet weak var sb3: UITextField!
    
    
    
    var db: OpaquePointer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        print("\(documentsDirectory)")
        self.hideKeyboardWhenTappedAround()
        //Get Temporary Directory
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("wp.sqlite")
        
        //Open Database
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error Opening Database")
        }
        
        
        //Creating Table
        let createTableQuery = "CREATE TABLE IF NOT EXISTS tab (id INTEGER PRIMARY KEY, vsa1 TEXT, vsa2 TEXT, vsa3 TEXT, vsb1 TEXT, vsb2 TEXT, vsb3 TEXT)"
        
        //Checking Table
        if sqlite3_exec(db, createTableQuery,nil,nil,nil) != SQLITE_OK{
            print("Error Creating the Table")
        }
        
        
        self.gerartabela()
        self.readValues()
    }
    
    
    @IBAction func calcpattern(_ sender: Any) {
 
        
        var vsa1,vsa2,vsa3,vsb1,vsb2,vsb3: String
        
        vsa1 = sa1.text!
        vsa2 = sa2.text!
        vsa3 = sa3.text!
        vsb1 = sb1.text!
        vsb2 = sb2.text!
        vsb3 = sb3.text!
       
      vsa1=vsa1.replacingOccurrences(of: ",", with: ".")
      vsa2=vsa2.replacingOccurrences(of: ",", with: ".")
      vsa3=vsa3.replacingOccurrences(of: ",", with: ".")
      vsb1=vsa1.replacingOccurrences(of: ",", with: ".")
      vsb2=vsa1.replacingOccurrences(of: ",", with: ".")
      vsb3=vsb3.replacingOccurrences(of: ",", with: ".")
   
 
        
        var stmt: OpaquePointer?
        
        let queryString = "REPLACE INTO tab (id,vsa1,vsa2,vsa3,vsb1,vsb2,vsb3) VALUES ('1',?,?,?,?,?,?)"
        


        
    //Preparing the Query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }

         if sqlite3_bind_double(stmt, 1,(vsa1 as NSString).doubleValue) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        if sqlite3_bind_double(stmt, 2,(vsa2 as NSString).doubleValue) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        if sqlite3_bind_double(stmt, 3,(vsa3 as NSString).doubleValue) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        if sqlite3_bind_double(stmt, 4,(vsb1 as NSString).doubleValue) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        if sqlite3_bind_double(stmt, 5,(vsb2 as NSString).doubleValue) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        if sqlite3_bind_double(stmt, 6,(vsb3 as NSString).doubleValue) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
      /*  if sqlite3_bind_int(stmt, 2, (powerRanking! as NSString).intValue) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }*/
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting hero: \(errmsg)")
            return
        }
        
     
        
        print("Replaced successfully")
        
        
        
    }
    
    
   
    func gerartabela(){
        let vsa1 = sa1.text
        let vsa2 = sa2.text
        let vsa3 = sa3.text
        let vsb1 = sb1.text
        let vsb2 = sb2.text
        let vsb3 = sb3.text
        
        //let vsb3="gustavo"
        
        var stmt: OpaquePointer?
        
        let queryString = "INSERT OR IGNORE INTO tab (id,vsa1,vsa2,vsa3,vsb1,vsb2,vsb3) VALUES ('1',?,?,?,?,?,?)"
        
        //  let queryString = sharedInstance.db!.executeUpdate("INSERT INTO tabela (id, sa1,sa2,sa3,sb1,sb2,sb3) VALUES (?,?,?,?,?,?,?)", withArgs: [i, vsa1,vsa2,vsa3,vsb1,vsb2,vsb3])
        
        //withArgs: ["SampleImageName", imageID])
        
        
        //Preparing the Query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        if sqlite3_bind_double(stmt, 1,(vsa1! as NSString).doubleValue) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        if sqlite3_bind_double(stmt, 2,(vsa2! as NSString).doubleValue) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        if sqlite3_bind_double(stmt, 3,(vsa3! as NSString).doubleValue) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        if sqlite3_bind_double(stmt, 4,(vsb1! as NSString).doubleValue) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        if sqlite3_bind_double(stmt, 5,(vsb2! as NSString).doubleValue) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        if sqlite3_bind_double(stmt, 6,(vsb3! as NSString).doubleValue) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        /*  if sqlite3_bind_int(stmt, 2, (powerRanking! as NSString).intValue) != SQLITE_OK{
         let errmsg = String(cString: sqlite3_errmsg(db)!)
         print("failure binding name: \(errmsg)")
         return
         }*/
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting hero: \(errmsg)")
            return
        }
        
        
        
        print("Gerada Inicial Funcionou")
        
        
        
    }
    
    func readValues(){
        
        let queryString = "SELECT * FROM tab where id=1"
        
        var stmt:OpaquePointer?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let gsa1 = sqlite3_column_double(stmt, 1)
            let gsa2 = sqlite3_column_double(stmt, 2)
            let gsa3 = sqlite3_column_double(stmt, 3)
            let gsb1 = sqlite3_column_double(stmt, 4)
            let gsb2 = sqlite3_column_double(stmt, 5)
            let gsb3 = sqlite3_column_double(stmt, 6)
            
            
            sa1.text=String("\(gsa1)")
            sa2.text=String("\(gsa2)")
            sa3.text=String("\(gsa3)")
            sb1.text=String("\(gsb1)")
            sb2.text=String("\(gsb2)")
            sb3.text=String("\(gsb3)")

            
        }
        
        
    }
    
    
    }




