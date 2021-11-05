//
//  HomeViewController.swift
//  SignUpLoginDemo
//
//  Created by Panchami Shenoy on 18/10/21.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit
import FirebaseFirestore
import RealmSwift
class HomeViewController: UIViewController {
    var noteRealm : NotesItem?
    var searching = false
    var delegate :MenuDelegate?
    let realmInstance = try! Realm()
    var filteredNotes : [NoteItem] = []
    var notes: [NoteItem] = []
    var notesRealm : [NotesItem] = []
    var flag = true
    var toggleButton = UIBarButtonItem()
    var width: CGFloat = 0
    @IBOutlet weak var NoteCollectionView: UICollectionView!
    @IBOutlet weak var label: UILabel!
    let x = Auth.auth().currentUser?.uid
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var hasMoreNotes = true
      var listView = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
       if AccessToken.current?.tokenString == nil{
         
            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                if user == nil {
                   let status = NetworkManager.shared.checkSignIn()
                    if(status == false){
                        self.transitionToLogin()
                    }
                }
              }
            }
       
        configureNavigation()
     configureCollectionView()
        configureSearchBar()
    }
    override func viewDidAppear(_ animated: Bool) {
        fetchNoteRealm()
        fetchNote()
        configureCollectionView()
        hasMoreNotes = true
    }
    
    func configureSearchBar(){
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
    }
    
    func configureCollectionView() {
        
        width = (view.frame.width - 20)
        let layout = UICollectionViewFlowLayout()
        NoteCollectionView.collectionViewLayout = layout
        NoteCollectionView.delegate = self
        NoteCollectionView.dataSource = self
    }
    
    @IBAction func onLogOut(_ sender: Any) {
        
        do {
           NetworkManager.shared.signout()
            NetworkManager.shared.googleSignOut()
            LoginManager.init().logOut()
            transitionToLogin()
            }
    }
    
    func transitionToLogin() {
        let loginViewController = storyboard?.instantiateViewController(withIdentifier: "SigninVC")
        
        view.window?.rootViewController = loginViewController
        view.window?.makeKeyAndVisible()
    }
    
    func configureNavigation() {
        self.navigationItem.title = "Home Page"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:UIImage(systemName: "list.dash"), style: .plain, target: self, action: #selector(handleMenu))
       let toggleButton = UIBarButtonItem(image: UIImage(systemName: "rectangle.grid.1x2.fill"), style: .done, target: self, action: #selector(toggleButtonTapped))
        let addButton = UIBarButtonItem(image :UIImage(systemName: "square.and.pencil") ,style:.plain,target:self,action:#selector(addNote))
               navigationItem.rightBarButtonItems = [addButton,toggleButton]
        
    }
    
    @objc func toggleButtonTapped(){
        if !flag {
                   flag = !flag
                   width = (view.frame.width - 20)
                   toggleButton.image = UIImage(systemName: "rectangle.grid.1x2.fill")
                   
               }else {
                   
                   flag = !flag
                   width = (view.frame.width - 20) / 2
                   toggleButton.image = UIImage(systemName: "rectangle.split.2x1.fill")
                   
               }
               NoteCollectionView.reloadData()
    }
    @objc func handleMenu() {
      
        delegate?.menuHandler()
       
    }
    
    @objc func addNote() {
       
        let addNoteController = storyboard?.instantiateViewController(withIdentifier: "AddNoteViewController") as! AddNoteViewController
        addNoteController.modalPresentationStyle = .fullScreen
        present(addNoteController,animated: true,completion: nil)
    }
  
    func fetchNote() {
        NetworkManager.shared.fetchNote { notes in
                    if notes.count < 7{
                        self.hasMoreNotes = false
                    }
                    self.notes = notes
                    print(self.notes)
                    DispatchQueue.main.async {
                        self.NoteCollectionView.reloadData()
                    }
                }
    }
    
    func fetchNoteRealm(){
        RealmManager.shared.fetchNotes{ notesArray in
            self.notesRealm = notesArray
        }
    }
    
    @objc func onDeleteNote(_ sender: UIButton) {
        var deleteNoteId = notes[sender.tag].noteId
        noteRealm = notesRealm[sender.tag]
        DatabaseManager.shared.deleteNote(noteId: deleteNoteId, note: noteRealm!)
       notes.remove(at: sender.tag)
        notesRealm.remove(at:sender.tag)
        NoteCollectionView.reloadData()
       }
        
}
extension HomeViewController :UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searching{
            return filteredNotes.count
        }else {
        return notes.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "noteCell", for: indexPath) as! NoteCell
        if searching{
      
        cell.cellTitle.text = filteredNotes[indexPath.row].title
        cell.cellContent.text = filteredNotes[indexPath.row].note
        
        }
        else{
            cell.cellTitle.text = notes[indexPath.row].title
            cell.cellContent.text = notes[indexPath.row].note
        }
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(onDeleteNote), for: .touchUpInside)
            return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let UpdateNoteViewController = storyboard!.instantiateViewController(withIdentifier: "UpdateNoteViewController") as! UpdateNoteViewController
            UpdateNoteViewController.noteFirebase = notes[indexPath.row]
            let title = notes[indexPath.row].title
          let content = notes[indexPath.row].note
        let predict = NSPredicate.init(format: "%K == %@", "title",title)
         let predict2 = NSPredicate.init(format: "%K == %@", "note",content)
         let query = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.or, subpredicates: [predict,predict2])
        let noteReal = realmInstance.objects(NotesItem.self).filter(query)
        UpdateNoteViewController.noteRealm = noteReal.first
        UpdateNoteViewController.modalPresentationStyle = .fullScreen
        present(UpdateNoteViewController, animated: true, completion: nil)
}
    func createSpinner()->UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
      let spinner =  UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
}
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: width, height : 100 )
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 10.0, left: 1.0, bottom: 1.0, right: 1.0)
    }
    
}

extension HomeViewController:UISearchResultsUpdating,UISearchBarDelegate{
    func updateSearchResults(for searchController: UISearchController) {
          let count = searchController.searchBar.text?.count
           let searchText = searchController.searchBar.text!
           if !searchText.isEmpty {
               searching = true
               filteredNotes.removeAll()
               filteredNotes = notes.filter({$0.title.prefix(count!).lowercased() == searchText.lowercased()})
           }
           else{
               searching = false
               filteredNotes.removeAll()
               filteredNotes = notes
           }
           NoteCollectionView.reloadData()
       }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        filteredNotes.removeAll()
        NoteCollectionView.reloadData()
    }
    
}
extension HomeViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > NoteCollectionView.contentSize.height-scrollView.frame.size.height-100{
            guard hasMoreNotes else { return}
            guard !fetchingMoreNotes else {
               print("\n\nfetching ")
                return
                
            }
            print("\n\n2222222222222222222222222222222")
            
            NetworkManager.shared.fetchMoreNotes { notes in
                
                if notes.count < 7{
                    self.hasMoreNotes = false
                }
                self.notes.append(contentsOf: notes)
                self.NoteCollectionView.reloadData()
            }
           
        }
    }
}
