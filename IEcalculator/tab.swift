//
//  tab.swift
//  IEcalculator
//
//  Created by Andreza on 1/4/19.
//  Copyright © 2019 Gustavo Sousa. All rights reserved.
//

import Foundation

class tab {
    
    var id: Int
    var vsa1: Double
    var vsa2: Double
    var vsa3: Double
    var vsb1: Double
    var vsb2: Double
    var vsb3: Double
    
    init(id: Int, vsa1: Double,  vsa2: Double, vsa3: Double,vsb1: Double,vsb2: Double,vsb3: Double){
        self.id = id
        self.vsa1 = vsa1
        self.vsa2 = vsa2
        self.vsa3 = vsa3
        self.vsb1 = vsb1
        self.vsb2 = vsb2
        self.vsb3 = vsb3
        
    }
}
