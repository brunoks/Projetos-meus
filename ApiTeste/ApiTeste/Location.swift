//
//  File.swift
//  ApiTeste
//
//  Created by Bruno Vieira on 16/10/17.
//  Copyright © 2017 Bruno Vieira. All rights reserved.
//

import Foundation

class Location {
    static var sharedInstance = Location()
    private init() {}
    
    var latitude: Double!
    var longitude: Double!
    
}
