//
//  capacityviewcontroller.swift
//  IEcalculator
//
//  Created by Andreza on 12/29/18.
//  Copyright © 2018 Gustavo Sousa. All rights reserved.
//

import Foundation
import UIKit
import SQLite3




class capacityviewcontroller:UIViewController {

    
//database variables
    var db: OpaquePointer?
    var turno1: Float=0
    var turno2: Float=0
    var turno3: Float=0

 //Defining the Text Boxes
    @IBOutlet weak var ct: UITextField!
    @IBOutlet weak var weeks: UITextField!
    @IBOutlet weak var dpw: UITextField!
    @IBOutlet weak var rr: UITextField!
    @IBOutlet weak var ddMenu: UIButton!
    @IBOutlet weak var seta: UIButton!
    
    
    @IBOutlet weak var ddText: UILabel!
    
    
//Defining the Labels
    @IBOutlet weak var jph: UILabel!
    @IBOutlet weak var jpd: UILabel!
    @IBOutlet weak var jpy: UILabel!
    
    
    @IBAction func rra(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        rr.text = "\(currentValue)"
 

        
        self.calculatecapacity(sender)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("wp.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        self.readValues()
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
          let sa1 = sqlite3_column_double(stmt, 1)
          let sa2 = sqlite3_column_double(stmt, 2)
          let sa3 = sqlite3_column_double(stmt, 3)
            
          turno1=Float(sa1)
          turno2=Float(sa2)
          turno3=Float(sa3)
        }
        
    
    }
    
    
    
    @IBAction func calculatecapacity(_ sender: AnyObject) {
        var ct1,weeks1,dpw1,rr1,jph1,jpd1,jpy1,shift: Float
        if ct.text=="" {
            return
        }
        let textoturno=ddText.text
        let a="1 Shift"
        let b="2 Shifts"
        let c="3 Shifts"
        
        var tct1:String
        tct1=ct.text!
        
        
        weeks1=Float(weeks.text!)!
        dpw1=Float(dpw.text!)!
        rr1=Float(rr.text!)!
        shift=0
 
        if textoturno == a {
        shift=turno1
        }
        else if textoturno == b{
        shift=turno1+turno2
        }
        else if textoturno == c{
        shift=turno1+turno2+turno3
        }
        
       tct1=tct1.replacingOccurrences(of: ",", with: ".")
        ct1=(tct1 as NSString).floatValue
        
        jph1=(60/(ct1/60))*(rr1/100)
        jpd1=jph1*shift
        jpy1=jpd1*weeks1*dpw1
        
        jph.text="\(jph1)"
        jpd.text="\(jpd1)"
        jpy.text="\(jpy1)"
        
        jph.text=String(format:"%.1f",jph1)
        jpd.text=String(format:"%.0f",jpd1)
        jpy.text=String(format:"%.0f",jpy1)
        
    }
    
    @IBAction func ddMenuShow(_ sender: UIButton) {
        
        if (sender.tag == 0) {
            sender.tag = 1;
            self.ddMenu.isHidden = false
            seta.setTitle("▲", for:.normal)
   
        } else {
            sender.tag = 0;
            self.ddMenu.isHidden = true
            seta.setTitle("▼", for:.normal)
        }
    }
    
    @IBAction func ddMenuSelectionMade(_ sender: UIButton) {
        
        self.ddText.text=sender.titleLabel?.text
        
        self.calculatecapacity(sender)
        
        //self.ddText.text = sender.titleLabel.text
        
        
       seta.setTitle("▼", for:.normal)
        
        self.seta.tag = 0
        
        
        self.ddMenu.isHidden = true
       
        
        switch (sender.tag) {
        case 1:
       
            
            break;
        case 2:

            break;
        case 3:

            
            break;
            
        default:
            break;
        }
        
        
        
    }
    
}




