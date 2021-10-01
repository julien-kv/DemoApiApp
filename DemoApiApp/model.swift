//
//  model.swift
//  DemoApiApp
//
//  Created by Julien on 30/09/21.
//

import Foundation

struct Welcome:Codable{
    var results:[Result]
    
}
struct Result:Codable{
    var urls:URLS
}

struct URLS:Codable{
    var small:URL
}
