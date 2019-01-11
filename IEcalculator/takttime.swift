//
//  takttime.swift
//  IEcalculator
//
//  Created by Andreza on 12/28/18.
//  Copyright © 2018 Gustavo Sousa. All rights reserved.
//

import Foundation
import UIKit
import SQLite3



class takttime: UIViewController {

//Database Variables
    var db: OpaquePointer?
    var turno1: Float=0
    var turno2: Float=0
    var turno3: Float=0
    
    @IBOutlet weak var seta: UIButton!
    
    @IBOutlet weak var ddText: UILabel!
    
    @IBOutlet weak var ddMenu: UIView!
    
 // textfield
    @IBOutlet weak var volume: UITextField!
    
    @IBOutlet weak var weeks1: UITextField!
    
    @IBOutlet weak var rr1: UITextField!
  
//Defining the Labels Results
    @IBOutlet weak var a1: UILabel!
    @IBOutlet weak var a2: UILabel!
    @IBOutlet weak var a3: UILabel!
    
    
    @IBOutlet weak var b1: UILabel!
    @IBOutlet weak var b2: UILabel!
    @IBOutlet weak var b3: UILabel!
  
   //DEFINING INVISIVLE LABELS
    @IBOutlet weak var ljpy: UILabel!
    @IBOutlet weak var ldpw: UILabel!
    @IBOutlet weak var lweeks: UILabel!
    @IBOutlet weak var l2shifts: UILabel!
    @IBOutlet weak var l3shifts: UILabel!
    
    
    @IBOutlet weak var segmento: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view, typically from a nib.
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
            let id = sqlite3_column_int(stmt, 0)
            let sa1 = sqlite3_column_double(stmt, 1)
            let sa2 = sqlite3_column_double(stmt, 2)
            let sa3 = sqlite3_column_double(stmt, 3)
            let sb1 = sqlite3_column_double(stmt, 4)
            let sb2 = sqlite3_column_double(stmt, 5)
            let sb3 = sqlite3_column_double(stmt, 6)
            
            
            turno1=Float(sa1)
            turno2=Float(sa2)
            turno3=Float(sa3)
            
        }
        
        
    }
  
    @IBAction func rra(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        
        rr1.text = "\(currentValue)"
        self.calculate(sender)
        
    }
    
    @IBAction func barra(_ sender: UISegmentedControl) {
        a1.text=""
        a2.text=""
        a3.text=""
        b1.text=""
        b2.text=""
        b3.text=""
        volume.text=""
        switch segmento.selectedSegmentIndex
        {
        case 0:
            ljpy.text="JPY"
            self.showall()
        case 1:
            ljpy.text="JPW"
            self.showjpw()
        case 2:
             ljpy.text="JPD"
            self.showjpd()
        case 3:
             ljpy.text="JPH"
            self.showjph()
        
        default:
            break
        }
    
        
    }
    
    func showall() {
        self.seta.isHidden = false
        self.ddText.isHidden = false
        self.ddMenu.isHidden = true
        self.volume.isHidden = false
        self.weeks1.isHidden = false
        self.rr1.isHidden = false
        self.a1.isHidden = false
        self.a2.isHidden = false
        self.a3.isHidden = false
        self.b1.isHidden = false
        self.b2.isHidden = false
        self.b3.isHidden = false
        self.ljpy.isHidden = false
        self.ldpw.isHidden = false
        self.lweeks.isHidden = false
        self.l2shifts.isHidden = false
        self.l3shifts.isHidden = false
    }
    
    func showjpw() {
        self.showall()
      self.lweeks.isHidden = true
      self.weeks1.isHidden = true
    }
    
    func showjpd() {
        self.showall()
        self.showjpw()
        self.seta.isHidden = true
        self.ddText.isHidden = true

        self.ldpw.isHidden = true
    }
    
    func showjph() {
        self.showall()
        self.showjpd()

        self.a2.isHidden = true
        self.a3.isHidden = true

        self.b2.isHidden = true
        self.b3.isHidden = true
        self.l2shifts.isHidden = true
        self.l3shifts.isHidden = true
        
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
        self.calculate(sender)
        
        
        seta.setTitle("▼", for:.normal)
        
        self.seta.tag = 0
        
        
        self.ddMenu.isHidden = true
        
        
      self.calculate(sender)
        
        
        
    }

    
    @IBAction func calculate(_ sender: AnyObject) {
        
        var jpy,dpw,weeks,rr,shift1,shift2,shift3,jph1,jph2,jph3,ct1,ct2,ct3: Float
        
        var tjpy:String
        tjpy=volume.text!
        
        if volume.text==""{
            return
       }
        a1.text=""
        a2.text=""
        a3.text=""
        b1.text=""
        b2.text=""
        b3.text=""
        

    tjpy=tjpy.replacingOccurrences(of: ",", with: ".")
         jpy=(tjpy as NSString).floatValue
        dpw=Float(ddText.text!)!
        weeks=Float(weeks1.text!)!
        rr=Float(rr1.text!)!
        let a:String=ljpy.text!
        
        shift1=turno1
        shift2=turno2+turno2
        shift3=turno1+turno2+turno3
        
        let op1="JPY"
        if a==op1{
            jph1=(jpy/(dpw*shift1*weeks))
            jph2=jpy/(dpw*shift2*weeks)
            jph3=jpy/(dpw*shift3*weeks)
        
            ct1=(((60/jph1)*60)*(rr/100))
            ct2=(((60/jph2)*60)*(rr/100))
            ct3=(((60/jph3)*60)*(rr/100))
        
            a1.text=String(format:"%.1f",jph1)
            a2.text=String(format:"%.1f",jph2)
            a3.text=String(format:"%.1f",jph3)
        
            b1.text=String(format:"%.1f",ct1)
            b2.text=String(format:"%.1f",ct2)
            b3.text=String(format:"%.1f",ct3)
            
        } else if ljpy.text=="JPW"{
            jph1=(jpy/(dpw*shift1))
            jph2=jpy/(dpw*shift2)
            jph3=jpy/(dpw*shift3)
            
            ct1=(((60/jph1)*60)*(rr/100))
            ct2=(((60/jph2)*60)*(rr/100))
            ct3=(((60/jph3)*60)*(rr/100))
            
            a1.text=String(format:"%.1f",jph1)
            a2.text=String(format:"%.1f",jph2)
            a3.text=String(format:"%.1f",jph3)
            
            b1.text=String(format:"%.1f",ct1)
            b2.text=String(format:"%.1f",ct2)
            b3.text=String(format:"%.1f",ct3)
            
        }else if ljpy.text=="JPD"{
            jph1=(jpy/(shift1))
            jph2=jpy/(shift2)
            jph3=jpy/(shift3)
            
            ct1=(((60/jph1)*60)*(rr/100))
            ct2=(((60/jph2)*60)*(rr/100))
            ct3=(((60/jph3)*60)*(rr/100))
            
            a1.text=String(format:"%.1f",jph1)
            a2.text=String(format:"%.1f",jph2)
            a3.text=String(format:"%.1f",jph3)
            
            b1.text=String(format:"%.1f",ct1)
            b2.text=String(format:"%.1f",ct2)
            b3.text=String(format:"%.1f",ct3)
            
            
        }else if ljpy.text=="JPH"{
            jph1=jpy
            ct1=(((60/jph1)*60)*(rr/100))
            
            a1.text=String(format:"%.1f",jpy)
            b1.text=String(format:"%.1f",ct1)
          
    
    
       }else{
            print("nao sei")
        return
       }
    }

}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer =     UITapGestureRecognizer(target: self, action:    #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
