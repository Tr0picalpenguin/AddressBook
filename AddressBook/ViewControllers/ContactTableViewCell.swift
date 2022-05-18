//
//  ContactTableViewCell.swift
//  AddressBook
//
//  Created by Scott Cox on 5/17/22.
//

import UIKit

protocol PersonTableViewCellDelegate: AnyObject {
    func toggleFavoriteButtonWasTapped(cell: ContactTableViewCell)
}

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    
    
    // MARK: Properties
    
    var person: Person? {
        didSet {
            updateViews()
        }
    }
    
 
    weak var delegate: PersonTableViewCellDelegate?
    
    // MARK: - Helper Functions
    func updateViews() {
        guard let person = person else {return}
        contactNameLabel.text = person.name
        if person.isFavorite == true {
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
    
    
    
    // MARK: - Actions
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        delegate?.toggleFavoriteButtonWasTapped(cell: self)
    }
    
} // End of Class
