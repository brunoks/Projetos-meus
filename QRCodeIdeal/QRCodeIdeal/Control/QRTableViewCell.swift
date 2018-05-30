//
//  QRTableViewCell.swift
//  QRCodeIdeal
//
//  Created by Luciano Pezzin on 28/05/2018.
//  Copyright © 2018 Bruno Vieira. All rights reserved.
//

import UIKit

class QRTableViewCell: UITableViewCell {

    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var qrImage: UIImageView!
    @IBOutlet weak var qrLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
