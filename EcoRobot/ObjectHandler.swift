//
//  ObjectHandler.swift
//  EcoRobot
//
//  Created by Matei Crăiniceanu on 10.05.2023.
//

import Foundation
import SwiftHTTP

struct ObjectHandler {
    
    func handle(_ obj: Recognition){
        
        var midXIsOk: Int {
            get {
                if obj.box.midX < 0.35 && obj.box.midX > 0.25 {
                    return 255
                } else {
                    return 0
                }
            }
        }
        
        var doza = 0
        var sticla = 0
        var plastic = 0
        
        switch obj.name {
        case "doza":
            doza = 255
        case "sticla":
            sticla = 255
        case "plastic":
            plastic = 255
        default:
            print("no")
        }
        
        let ip = "192.168.0.140"
//        let ip = "192.168.0.176"
        
        let link = "http://\(ip)/recognized?d=\(doza)&s=\(sticla)&p=\(plastic)&det=\(midXIsOk)"
        
        print(link)
        
        HTTP.GET(link)
    }
}
