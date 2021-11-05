
import Foundation
import RealmSwift

struct DatabaseManager {
    static let shared = DatabaseManager()
    
    func updateNote(note:NoteItem , realmNote:NotesItem,title:String,content:String)
    {
        NetworkManager.shared.updateNote(note)
        RealmManager.shared.updateNote(title, content,realmNote)
    }
    
    func addNote(note:[String:Any],realmNote:NotesItem)
    {
        NetworkManager.shared.addNote(note: note)
        RealmManager.shared.addNote(note: realmNote)
    }
    
    func deleteNote(noteId:String,note:NotesItem){
        NetworkManager.shared.deleteNote(noteId)
        RealmManager.shared.deleteNote(note: note)
    }
    
}
