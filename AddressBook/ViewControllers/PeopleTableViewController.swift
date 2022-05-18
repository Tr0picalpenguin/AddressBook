//
//  PeopleTableViewController.swift
//  AddressBook
//
//  Created by Trevor Adcock on 10/12/21.
//

import UIKit

class PeopleTableViewController: UITableViewController {
    
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var favoritesOnlyToggle: UISwitch!

    
    var group: Group?

    // MARK: - Lifecycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        groupNameTextField.text = group?.name
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let group = group,
            let newName = groupNameTextField.text
        else { return }
        GroupController.shared.update(group: group, name: newName)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if favoritesOnlyToggle.isOn {
            return filteredPeople.count
        } else {
            return group?.people.count ?? 0
        }
           
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as? ContactTableViewCell else { return UITableViewCell()}
        
        if favoritesOnlyToggle.isOn {
            let person = filteredPeople[indexPath.row]
            cell.person = person
        } else {
            let person = group?.people[indexPath.row]
            cell.person = person
        }
        cell.delegate = self
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let group = group else { return }
            if favoritesOnlyToggle.isOn {
                let person = filteredPeople[indexPath.row]
                PersonContoller.delete(person: person, in: group)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            let person = group.people[indexPath.row]
            PersonContoller.delete(person: person, in: group)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "toPersonDetail",
              let personDetailViewController = segue.destination as? PersonDetailViewController,
              let selectedRow = tableView.indexPathForSelectedRow?.row
        else { return }
        if favoritesOnlyToggle.isOn {
            let person = filteredPeople[selectedRow]
            personDetailViewController.person = person
        }
        let person = group?.people[selectedRow]
        personDetailViewController.person = person
    }
    
    // MARK: - Actions
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        guard let group = group else { return }
        PersonContoller.createPerson(group: group)
        tableView.reloadData()
    }
 
    @IBAction func favoritesOnlyToggle(_ sender: Any) {
        tableView.reloadData()
    }
    
    private var filteredPeople: [Person] {
        if favoritesOnlyToggle.isOn {
            return group?.people.filter { $0.isFavorite } ?? []
        } else {
            return group?.people ?? []
        }
    }

    
} // End of Class

extension PeopleTableViewController: PersonTableViewCellDelegate {
    func toggleFavoriteButtonWasTapped(cell: ContactTableViewCell) {
        guard let person = cell.person else {return}
        PersonContoller.toggleIsFavorite(person: person)
        cell.updateViews()
    }
}
