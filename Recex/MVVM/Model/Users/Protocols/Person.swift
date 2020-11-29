//
//  Person.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 11/28/20.
//

import Foundation

protocol Person : Identifiable {
    
    var PersonID : String { get }
    var Firstname : String { get set }
    var Lastname : String { get set }
    var Email : String { get }
    var Creation : String { get }
    var Role : String { get }
    
    var SuggestionModelData : String{ get set }
    
    var Posts : [String] { get set }
    var Followers : [String] { get set }
    var Following : [String] { get set }
    
    var ShareIdentifier : String { get }
}
