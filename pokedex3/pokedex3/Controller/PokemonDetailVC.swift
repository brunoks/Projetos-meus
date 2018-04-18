//
//  PokemonDetailVC.swift
//  pokedex3
//
//  Created by Bruno Vieira on 19/10/17.
//  Copyright © 2017 Bruno Vieira. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    var pokemon: Pokemon!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var discriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var evoLbl: UILabel!
    
    
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = pokemon.name.capitalized
        let img = UIImage(named: "\(pokemon.pokedexId)")
        
        mainImg.image = img
        currentEvoImg.image = img
        pokedexLbl.text = "\(pokemon.pokedexId)"
        pokemon.downloadPokemonDetail {
            print("Did arrive here?")
            //Whatever we write will only be called after the network call is complete!
            updateUI()
        }

        func updateUI() {
            attackLbl.text = pokemon.attack
            defenseLbl.text = pokemon.defense
            weightLbl.text = pokemon.weight
            heightLbl.text = pokemon.height
            typeLbl.text = pokemon.type
            discriptionLbl.text = pokemon.discription
            
            if pokemon.nextEvolutionId == "" {
                evoLbl.text = "No Evolutions"
                nextEvoImg.isHidden = true
            } else {
                nextEvoImg.isHidden = false
                nextEvoImg.image = UIImage(named: pokemon.nextEvolutionId)
                let str = "Next Evolution: \(pokemon.nextEvolutionName) - LVL \(pokemon.nextEvolutionLevel)"
                evoLbl.text = str
            }
        }
    }
    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
