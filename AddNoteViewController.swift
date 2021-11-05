//
//  AddNoteViewController.swift
//  SignUpLoginDemo
//
//  Created by Panchami Shenoy on 26/10/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import RealmSwift
class AddNoteViewController: UIViewController {
    let uid = Auth.auth().currentUser?.uid
    let realmInstance = try! Realm()
    @IBOutlet weak var noteTitle: UITextField!
    
    @IBOutlet weak var noteContent: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //printNote()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: .none)
    }
    
    @IBAction func onAdd(_ sender: Any) {
        let noteTitle :String = noteTitle.text!
        let noteContent :String = noteContent.text!
        let newNote: [String: Any] = ["title": noteTitle,"note":noteContent,"uid": uid,"timestamp":Date()]
       let note1 = NotesItem()
        note1.note = noteContent
        note1.title = noteTitle
        note1.uid = uid!
        note1.date = Date()
        DatabaseManager.shared.addNote(note: newNote, realmNote: note1)
        
        self.noteTitle.text = ""
        self.noteContent.text = ""
       
    }
    
    func printNotes(){
        
        let notes = realmInstance.objects(NotesItem.self)
        for note in notes
        {
            print(note)
        }
    }
    
    func getDate() ->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        return dateFormatter.string(from:Date())
    }
    
    
    }

