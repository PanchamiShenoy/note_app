//
//  NotesItem.swift
//  SignUpLoginDemo
//
//  Created by Panchami Shenoy on 29/10/21.
//

import Foundation

import RealmSwift

class NotesItem: Object {
    @objc dynamic var name = ""
    @objc dynamic  var title = ""
    @objc dynamic  var note = ""
    @objc dynamic  var uid = ""
    @objc dynamic   var date = Date()
    
    
}
