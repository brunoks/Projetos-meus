//
//  ContatosViewModel.swift
//  iOS-PicPay-Teste
//
//  Created by Mac Novo on 07/12/18.
//  Copyright © 2018 Bruno iOS Dev. All rights reserved.
//

import UIKit
import SDWebImage
struct ContatosViewModel {
    let id: Int
    let img: String
    let name: String
    let username: String
    
    let imageView = UIImageView()
    init(contato: Contato) {
        self.id = contato.id
        self.img = contato.img
        self.name = contato.name
        self.username = contato.username
    
        self.imageView.sd_setImage(with: URL(string: self.img), placeholderImage: UIImage(named: "noprofile.png"))
    }
}
