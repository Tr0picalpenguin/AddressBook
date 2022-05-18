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


    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    
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
        nameLabel.text = person.name
        let favoriteImageNamed = person.isFavorite ? "star.fill" : "star"
        let favoriteImage = UIImage(systemName: favoriteImageNamed)
        favoriteButton.setImage(favoriteImage, for: .normal)
       
    }
    
    
    
    
    // MARK: - Actions
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        delegate?.toggleFavoriteButtonWasTapped(cell: self)
    }
    
} // End of Class
