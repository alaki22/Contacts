//
//  ContactsViewController.swift
//  hw4
//
//  Created by Ani Lakirbaia on 02.02.25.
//
import Foundation

import UIKit



class ContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    
    
    
    var isGridView = false
    let tableView = UITableView()
    var collectionView : UICollectionView?
    private var collectionViewLayout: UICollectionViewFlowLayout?
    private var addAction: UIAlertAction?
    private var spacing: CGFloat { 20 }
    private var itemSize: CGFloat{ 100 }
    private var headerHeight: CGFloat { 40 }
    private var dataSource = DataSource()
    private var gridButton :UIBarButtonItem!
    private var listButton:UIBarButtonItem!
       
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contacts"
        view.backgroundColor = .white
           
        setupNavigationBar()
        setupTableView()
           
    }
    
    func setupNavigationBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddContactAlert))
        gridButton = UIBarButtonItem(
            image: UIImage(systemName: "square.grid.3x3.fill"),
            style: .plain,
            target: self,
            action: #selector(toggleViewMode)
        )
        listButton = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal"),
            style: .plain,
            target: self,
            action: #selector(toggleViewMode)
        )
        navigationItem.rightBarButtonItem = gridButton
    }
    
    
    func setupTableView(){
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)

        layout.headerReferenceSize = CGSize(width: headerHeight, height: headerHeight)
        
        collectionViewLayout = layout

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.backgroundColor = .white
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "gridCell")
        collectionView?.register(ContactHeaderCollectionReusableView.self,
                                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                 withReuseIdentifier: "Header")

        collectionView?.addGestureRecognizer(
            UILongPressGestureRecognizer(
                target: self,
                action: #selector(handleLongPress)
            )
        )

        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        if let collectionView = collectionView {
            view.addSubview(collectionView)
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: view.topAnchor),
                collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
                collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
    }
    
    @objc
    private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: collectionView)
        if let indexPath = collectionView?.indexPathForItem(at: location){
            showDeleteConfirmation(at: indexPath)
        }
    }
    
    @objc func toggleCollapse(_ sender: UIButton) {
        let section = sender.tag
        
        dataSource.toggleExpanded(section:section)
        collectionView?.collectionViewLayout.invalidateLayout()

        
        if isGridView{
            collectionView?.reloadSections(IndexSet(integer: section))
        }else{
            tableView.reloadSections(IndexSet(integer: section), with: .automatic)
        }
        
    }
    

    
    @IBAction private func showAddContactAlert() {
        let alert = UIAlertController(
            title: "Add Contact",
            message: nil,
            preferredStyle: .alert
        )
        var nameField: UITextField?
        alert.addTextField { [unowned self] textField in
            nameField = textField
            textField.placeholder = "Name"
            textField.addTarget(
                self,
                action: #selector(handleNameEnter),
                for: .editingChanged
            )
        }
        
        var numberField: UITextField?
        alert.addTextField { [unowned self] textField in
            numberField = textField
            textField.placeholder = "Phone Number"
            textField.addTarget(
                self,
                action: #selector(handleNameEnter),
                for: .editingChanged
            )
        }
        
        addAction = UIAlertAction(
            title: "Add",
            style: .default,
            handler: { [unowned self] _ in
                let name = nameField?.text
                let number = numberField?.text
                addContact(name: name!, number:number!)
                
            }
        )
        addAction?.isEnabled = false
        alert.addAction(addAction!)
        alert.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil
        ))
        present(alert, animated: true)
    }
    

    func addContact(name: String, number: String) {
            if let update = dataSource.addContact(name: name, number: number) {
                if let row = update.row {
                    let newIndexPath = IndexPath(row: row, section: update.section)
                    isGridView ? collectionView?.insertItems(at: [newIndexPath]): tableView.insertRows(at: [newIndexPath], with: .automatic)
                    
                } else {
                    let newSection = IndexSet(integer: update.section)
                    isGridView ? collectionView?.insertSections(newSection) : tableView.insertSections(newSection, with: .automatic)
                    
                }
            }
        }
    
    @objc
    private func handleNameEnter(_ sender: UITextField) {
        guard let alert = presentedViewController as? UIAlertController else { return }
        
        let nameField = alert.textFields?[0]
        let numberField = alert.textFields?[1]
        
        let isEnabled = !(nameField?.text?.isEmpty ?? true) && !(numberField?.text?.isEmpty ?? true)
        addAction?.isEnabled = isEnabled
    }
    
    
    
    private func showDeleteConfirmation(at indexPath: IndexPath) {
        let contact = dataSource.getContact(at: indexPath)
        let alert = UIAlertController(
            title: "Delete \(contact.name)?",
            message: "Contatc will be deleted permanently",
            preferredStyle: .actionSheet
        )
        addAction = UIAlertAction(
            title: "Delete",
            style: .destructive,
            handler: { [unowned self] _ in
                deleteContact(at: indexPath)
            }
        )
        alert.addAction(addAction!)
        alert.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil
        ))
        present(alert, animated: true)
    }
    
    private func deleteContact(at indexPath: IndexPath) {
        let sectionDeleted = dataSource.deleteContact(at:indexPath)
        if sectionDeleted {
            let section = IndexSet(integer: indexPath.section)
            if isGridView{
                collectionView?.deleteSections(section)
                collectionView?.reloadData()
            }else{
                tableView.deleteSections(section, with: .automatic)
                tableView.reloadData()
            }
        } else {
            if isGridView {
                collectionView?.deleteItems(at: [indexPath])
                collectionView?.reloadData()
            }else{
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    
    @objc func toggleViewMode() {
        isGridView.toggle()
        
        if isGridView {
            tableView.removeFromSuperview()
            collectionView?.reloadData()
            setupCollectionView()
        } else {
            collectionView?.removeFromSuperview()
            tableView.reloadData()
            setupTableView()
        }
        
        navigationItem.rightBarButtonItem = isGridView ? listButton : gridButton
    }
    
    
    // MARK: - UITableView

    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.getSectionCount()
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource.getHeaderTitle(in: section)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.getRowCount(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let contact = dataSource.getContact(at: indexPath)
        cell.textLabel?.text = "\(contact.name)\n\(contact.number)"
        cell.textLabel?.numberOfLines = 2
        return cell
    }

   
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(
            style: .destructive,
            title: "Delete",
            handler: { [unowned self] _, _, _ in
                deleteContact(at: indexPath)
            }
        )
        let actions: [UIContextualAction] = [delete]
        let config = UISwipeActionsConfiguration(actions: actions)
        config.performsFirstActionWithFullSwipe = true
        return config
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = ContactHeaderView()
        headerView.configure(
            with: dataSource.getHeaderTitle(in: section),
            section: section,
            target: self,
            action: #selector(toggleCollapse(_:)),
            isExpanded: dataSource.isSectionExpanded(in: section)
        )
        return headerView
    }
    
    
    //MARK: - UICollectionView
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return dataSource.getRowCount(in: section)
        }
    
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return dataSource.getSectionCount()
        }
    
   
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridCell", for: indexPath)
            let contact = dataSource.getContact(at: indexPath)
            cell.contentView.subviews.forEach { $0.removeFromSuperview() }
            
            let label = UILabel(frame: cell.bounds)
            label.text = "\(contact.name)\n\(contact.number)"
            label.textAlignment = .center
            label.numberOfLines = 2
            
            cell.contentView.addSubview(label)
            cell.layer.borderColor = UIColor.gray.cgColor
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 8
            
            return cell
        }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath:
                            IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            fatalError("Unexpected element kind")
        }
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: "Header",
                                                                       for: indexPath) as! ContactHeaderCollectionReusableView

        let section = indexPath.section
        let title = dataSource.getHeaderTitle(in: section)
        let isExpanded = dataSource.isSectionExpanded(in: section)
        headerView.configure(with: title, section: section, target: self, action: #selector(toggleCollapse(_:)), isExpanded: isExpanded)
        
        return headerView
    }
   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: headerHeight)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let isExpanded = dataSource.isSectionExpanded(in: section)
        return isExpanded ? UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing) : UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
    }
}
