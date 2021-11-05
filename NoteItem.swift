//
//  NoteItem.swift
//  SignUpLoginDemo
//
//  Created by Panchami Shenoy on 28/10/21.
//

import Foundation
import FirebaseFirestore

struct NoteItem {
    var noteId :String
    var title: String
    var note: String
    var uid: String
    var date: Date

}
