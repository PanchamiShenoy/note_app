//
//  NoteCell.swift
//  SignUpLoginDemo
//
//  Created by Panchami Shenoy on 26/10/21.
//

import UIKit

class NoteCell: UICollectionViewCell {
    var note :NoteItem?{
        didSet{
            cellTitle.text = note?.title
            cellContent.text = note?.note
        }
    }
   
    @IBOutlet weak var cellContent: UILabel!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
}
