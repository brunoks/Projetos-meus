//
//  UserProfileController.swift
//  MessageChat
//
//  Created by Mac Novo on 30/11/18.
//  Copyright © 2018 Bruno iOS Dev. All rights reserved.
//

import UIKit
struct ConfigureCellAtendimento {
    var image: UIImage?
    var title: String?
    var color: UIColor?
}
class UserProfileController: UITableViewController {
    
    var friend: Friend? {
        didSet {
            
        }
    }
    var dataTable =
        [
            [
                ConfigureCellAtendimento(image: #imageLiteral(resourceName: "recent-1"), title: "", color: UIColor()),
                ConfigureCellAtendimento(image: #imageLiteral(resourceName: "recent-1"), title: "", color: UIColor()),
                ConfigureCellAtendimento(image: #imageLiteral(resourceName: "recent-1"), title: "", color: UIColor())
            ],
            [
                ConfigureCellAtendimento(image: #imageLiteral(resourceName: "like"), title: "FeedBack", color: UIColor(red: 0/255, green: 94/255, blue: 184/255, alpha: 1.0)),
                ConfigureCellAtendimento(image: #imageLiteral(resourceName: "rightArrow"), title: "Messenger", color: UIColor(red: 252/255, green: 159/255, blue: 91/255, alpha: 1.0)),
                ConfigureCellAtendimento(image: #imageLiteral(resourceName: "info"), title: "Sobre", color: UIColor(red: 242/255, green: 100/255, blue: 25/255, alpha: 1.0)),
                ConfigureCellAtendimento(image: #imageLiteral(resourceName: "sair"), title: "Sair", color: UIColor(red: 45/255, green: 216/255, blue: 129/255, alpha: 1.0)),
                ]
    ]
    
    var cellid = "perfilcell"
    let perfilCell = "perfilcellasd"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView = UITableView(frame: CGRect(), style: .grouped)
        self.tableView.tableFooterView = UIView()
        self.tableView.register(ProfileViewCell.self, forCellReuseIdentifier: perfilCell)
        self.tableView.register(OptionsViewCell.self, forCellReuseIdentifier: cellid)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataTable.count
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 0 {
            return 50
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataTable[section].count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            if indexPath.row < 1 {
                return 400
            } else {
                return 60
            }
        case 1:
            return 45
        default:
            return 45
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: self.perfilCell, for: indexPath) as! ProfileViewCell
            switch indexPath.row {
            case 0:
                cell.setupImageProfile()
                cell.user = friend
                return cell
            case 1:
                cell.user = friend
                cell.setupDados()
                return cell
            case 2:
                
                
                return cell
            default:
                return UITableViewCell()
            }
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! OptionsViewCell
            let dataCell = dataTable[indexPath.section][indexPath.row]
            
            cell.setImageAndTitle(dataCell.image!, dataCell.title!, color: dataCell.color!)
            return cell
        default:
            return UITableViewCell()
        }
    }
}

