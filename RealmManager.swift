//
//  RealmManager.swift
//  SignUpLoginDemo
//
//  Created by Panchami Shenoy on 29/10/21.
//

import Foundation
import RealmSwift
struct RealmManager {
    static var shared = RealmManager()
    let realmInstance = try! Realm()
    var notesRealm : [NotesItem] = []
    func addNote(note:NotesItem){
        try! realmInstance.write({
            realmInstance.add(note)
        })
    }
   mutating func deleteNote(note:NotesItem){
        try! realmInstance.write({
            realmInstance.delete(note)
        })
    }
    
    func updateNote(_ title:String,_ noteContent:String,_ note:NotesItem){
        let realmInstance = try! Realm()
        try! realmInstance.write({
            note.title = title
            note.note = noteContent
        })
        
    }
  mutating  func fetchNotes(completion :@escaping([NotesItem])->Void) {
      var notesArray :[NotesItem] = []
        let notes = realmInstance.objects(NotesItem.self)
        for note in notes
        {
            notesRealm.append(note)
            notesArray.append(note)
            
        }
      completion(notesArray)
      print(notes)
      
    }
}
