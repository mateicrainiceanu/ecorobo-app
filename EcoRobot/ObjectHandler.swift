//
//  ObjectHandler.swift
//  EcoRobot
//
//  Created by Matei Crăiniceanu on 10.05.2023.
//

import Foundation
import SwiftHTTP

struct ObjectHandler {
    
    var prevRecognizedObject: String?
    
    mutating func handle(_ obj: Recognition){
        
        var shouldRequest: Bool {
            get {
                if let prevRecognitionName = self.prevRecognizedObject {
                    if prevRecognitionName != obj.name {
                        return true
                    } else {
                        return false
                    }
                } else {
                    self.prevRecognizedObject = obj.name
                    return true
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
        
        var midXIsOk: Int {
            get {
                if obj.box.midX < 0.35 && obj.box.midX > 0.25 {
                    return 255
                } else {
                    return 0
                }
            }
        }

        
        if shouldRequest {
            let ip = "192.168.0.140"
    //        let ip = "192.168.0.176"
            
            let link = "http://\(ip)/recognized?d=\(doza)&s=\(sticla)&p=\(plastic)&det=\(midXIsOk)"
            
            print(link)
            
            HTTP.GET(link)
        } else {
            print("NOT REQUESTING; SAME AS LAST TIME")
        }
    }
}
