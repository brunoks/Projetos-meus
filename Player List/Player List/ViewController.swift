//
//  ViewController.swift
//  Player List
//
//  Created by Luciano Pezzin on 27/09/2018.
//  Copyright © 2018 Luciano Pezzin. All rights reserved.
//

import UIKit


struct PlayList {
    var name: String?
    var desc: String?
    var subdesc: String?
    var avatar: String?
    var read: Bool?
    var isSelected: Bool?
}
class ViewController: UITableViewController {
    

    private let cell = "cell"
    private var oldIndexPath: IndexPath!
    
    var dataTable = [PlayList(name: "Andre Agassi", desc: "Winner of a Grand Slam singles titles and 1", subdesc: "Olympic singles gold medal", avatar: "", read: false, isSelected: false),
                     PlayList(name: "Roger Federer", desc: "Preparing Olympic Games U.S now", subdesc: "Winner if 1 Grand Slam singles title", avatar: "", read: false, isSelected: false),
                     PlayList(name: "Paul Anna", desc: "Preparing Olympic Games U.S now", subdesc: "1975 French Open quarterfinalist", avatar: "", read: false, isSelected: false),
                     PlayList(name: "Na li", desc: "Will not attend any Olympic Games", subdesc: "Born in Hubei, China. Now has won 3 awards", avatar: "", read: false, isSelected: false),
                     PlayList(name: "Sue Barker", desc: "Winner of a Grand Slam singles titles and 1", subdesc: "Olympic singles gold medal", avatar: "", read: false, isSelected: false),
                     PlayList(name: "Allen Wolf", desc: "Ranked World No.3", subdesc: "1926 Franch Open Champion", avatar: "", read: true, isSelected: false),
                     PlayList(name: "Allen Wolf", desc: "Ranked World No.3", subdesc: "1926 Franch Open Champion", avatar: "", read: true, isSelected: false),
                     PlayList(name: "Allen Wolf", desc: "Ranked World No.3", subdesc: "1926 Franch Open Champion", avatar: "", read: true, isSelected: false),
                     PlayList(name: "Allen Wolf", desc: "Ranked World No.3", subdesc: "1926 Franch Open Champion", avatar: "", read: true, isSelected: false),
                     PlayList(name: "Allen Wolf", desc: "Ranked World No.3", subdesc: "1926 Franch Open Champion", avatar: "", read: true, isSelected: false),
                     PlayList(name: "Andre Agassi", desc: "Winner of a Grand Slam singles titles and 1", subdesc: "Olympic singles gold medal", avatar: "", read: false, isSelected: false),
                     PlayList(name: "Roger Federer", desc: "Preparing Olympic Games U.S now", subdesc: "Winner if 1 Grand Slam singles title", avatar: "", read: false, isSelected: false),
                     PlayList(name: "Paul Anna", desc: "Preparing Olympic Games U.S now", subdesc: "1975 French Open quarterfinalist", avatar: "", read: false, isSelected: false),
                     PlayList(name: "Na li", desc: "Will not attend any Olympic Games", subdesc: "Born in Hubei, China. Now has won 3 awards", avatar: "", read: false, isSelected: false),
                     PlayList(name: "Sue Barker", desc: "Winner of a Grand Slam singles titles and 1", subdesc: "Olympic singles gold medal", avatar: "", read: false, isSelected: false),
                     PlayList(name: "Allen Wolf", desc: "Ranked World No.3", subdesc: "1926 Franch Open Champion", avatar: "", read: true, isSelected: false),
                     PlayList(name: "Allen Wolf", desc: "Ranked World No.3", subdesc: "1926 Franch Open Champion", avatar: "", read: true, isSelected: false),
                     PlayList(name: "Allen Wolf", desc: "Ranked World No.3", subdesc: "1926 Franch Open Champion", avatar: "", read: true, isSelected: false),
                     PlayList(name: "Allen Wolf", desc: "Ranked World No.3", subdesc: "1926 Franch Open Champion", avatar: "", read: true, isSelected: false),
                     PlayList(name: "Allen Wolf", desc: "Ranked World No.3", subdesc: "1926 Franch Open Champion", avatar: "", read: true, isSelected: false),
                     ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainCustom()
        addLeftBarIcon()
        addRightBarIcon()
    }
    func addLeftBarIcon() {
        let logoImage = UIImage.init(named: "menu")
        let logoImageView = UIImageView.init(image: logoImage)
        logoImageView.frame = CGRect(x:0, y:0.0, width: 20,height: 20)
        logoImageView.contentMode = .scaleAspectFit
        let imageItem = UIBarButtonItem.init(customView: logoImageView)
        let widthConstraint = logoImageView.widthAnchor.constraint(equalToConstant: 25)
        let heightConstraint = logoImageView.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        navigationItem.leftBarButtonItem =  imageItem
    }
    func addRightBarIcon() {

        let barButtom = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
        barButtom.tintColor = .white
        navigationItem.rightBarButtonItem = barButtom
    }
    @objc func search() {
        print("opa")
    }
    func mainCustom() {
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 48/255, green: 46/255, blue: 67/255, alpha: 1.0)
        self.navigationController?.navigationBar.isTranslucent = false
        self.tableView.register(PlayListcell.self, forCellReuseIdentifier: cell)
        
        let label = UILabel()
        label.text = "Play List"
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        self.navigationItem.title = "Play List"
        
//        self.navigationController?.navigationBar.addSubview(label)
//        label.centerXAnchor.constraint(equalTo: (self.navigationController?.navigationBar.centerXAnchor)!).isActive = true
//        label.centerYAnchor.constraint(equalTo: (self.navigationController?.navigationBar.centerYAnchor)!).isActive = true
//        label.widthAnchor.constraint(equalToConstant: self.view.frame.width / 2).isActive = true
//        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor(red: 48/255, green: 46/255, blue: 67/255, alpha: 1.0)

    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("\(size)")
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectRow(indexPath,tableView)
    }

    private func selectRow(_ indexPath: IndexPath,_ tableView: UITableView) {
        if !tableView.isEditing {
            self.read(i: indexPath.row)
            self.dataTable[indexPath.row].isSelected = true
            self.deselect()
            self.oldIndexPath = indexPath
            self.tableView.reloadRows(at: [indexPath], with: .none)
            
            performSegue(withIdentifier: "tomessage", sender: nil)
        }
    }
    private func deselect() {
        if self.oldIndexPath != nil {
            self.dataTable[self.oldIndexPath.row].isSelected = false
            self.tableView.reloadRows(at: [self.oldIndexPath], with: .none)
        }
    }

//    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let read =  UIContextualAction(style: .normal, title: "Files", handler: { (action,view,completionHandler ) in
//            self.read(i: indexPath.row)
//            completionHandler(true)
//        })
//        read.backgroundColor = UIColor(red: 255/255, green: 42/255, blue: 104/255, alpha: 1.0)
//        let img = UIImage(named: "message")
//        read.image = img
//
//        let config = UISwipeActionsConfiguration(actions: [read])
//        return config
//    }
    
    override func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        self.selectRow(indexPath!, tableView)
    }
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        self.deselect()
        let read =  UIContextualAction(style: .normal, title: nil, handler: { (action,view,completionHandler ) in
            self.read(i: indexPath.row)
            completionHandler(true)
        })
        read.backgroundColor = UIColor(red: 255/255, green: 42/255, blue: 104/255, alpha: 1.0)
        let img = UIImage(named: "message")
        read.image = img
        
        let config = UISwipeActionsConfiguration(actions: [read])
        return config
    }
    
    
    func read(i: Int) {
        self.dataTable[i].read = true
        let indexPath = IndexPath(row: i, section: 0)
        self.tableView.reloadRows(at: [indexPath], with: .none)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataTable.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cell, for: indexPath) as! PlayListcell
        cell.setupViews(self.dataTable[indexPath.row], i: indexPath.row)
        return cell
    }

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}
extension UIView {
    func fillSuperview() {
        anchor(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.bottomAnchor, trailing: superview?.trailingAnchor)
    }
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
}

