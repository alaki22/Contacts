//
//  DataSource.swift
//  hw4
//
//  Created by Ani Lakirbaia on 04.02.25.
//

import Foundation

import UIKit

class DataSource: NSObject {
    
    var contacts: [ContactSection] = [
        ContactSection(title: "A", contacts: [Contact(name: "Ana", number: "599112233"), Contact(name: "Anita", number: "555111222")]),
        ContactSection(title: "K", contacts: [Contact(name: "Kote", number: "595111333")]),
        ContactSection(title: "M", contacts: [Contact(name: "Mariam", number: "555444333"), Contact(name: "Marita", number: "599223344")])
    ]
    
    
    func toggleExpanded(section: Int){
        contacts[section].isExpanded.toggle()
    }
    
   
    func getContact(at indexPath: IndexPath) -> Contact{
        return contacts[indexPath.section].contacts[indexPath.row]
    }
    
    func getSectionCount()->Int{
        return contacts.count
    }
    
    func getHeaderTitle(in section: Int)->String{
       return contacts[section].title
    }
    
    func isSectionExpanded(in section: Int)->Bool{
        return contacts[section].isExpanded
    }
    
    func getRowCount(in section: Int)->Int{
        return contacts[section].isExpanded ? contacts[section].contacts.count : 0
    }
    
    
    //returns true if section was deleted and false otherwise
    func deleteContact(at indexPath : IndexPath)->Bool{
        if contacts[indexPath.section].contacts.count == 1 {
            contacts.remove(at: indexPath.section)
            return true
        }else{
            contacts[indexPath.section].contacts.remove(at: indexPath.row)
            return false
        }
    }
    
   
    
   
    
    // Returns either an inserted section index or an inserted row index path
        func addContact(name: String, number: String) -> (section: Int, row: Int?)? {
            guard let title = name.first?.uppercased() else { return nil }
            let contact = Contact(name: name, number: number)
            let sectionIndex = contacts.firstIndex { $0.title == title }

            if let sectionIndex = sectionIndex {
                return createNewContact(contact: contact, in: sectionIndex)
            } else {
                return (createNewSection(title: title, contact: contact), nil)
            }
        }

        private func createNewSection(title: String, contact: Contact) -> Int {
            let section = ContactSection(title: title, contacts: [contact])
            contacts.append(section)
            contacts.sort { $0.title < $1.title }
            return contacts.firstIndex { $0.title == title } ?? 0
        }

        private func createNewContact(contact: Contact, in sectionIndex: Int) -> (Int, Int) {
            contacts[sectionIndex].contacts.append(contact)
            contacts[sectionIndex].contacts.sort { $0.name < $1.name }
            let newRow = contacts[sectionIndex].contacts.firstIndex { $0.name == contact.name } ?? 0
            return (sectionIndex, newRow)
        }
}
