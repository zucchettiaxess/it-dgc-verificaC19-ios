//
//  SettingsCell.swift
//  Verifier
//
//  Created by Emilio Apuzzo on 19/10/21.
//

import UIKit

class SettingsCell: UITableViewCell {

    @IBOutlet weak var containerView: AppShadowView!
    @IBOutlet weak var titleLabel: AppLabel!
    @IBOutlet weak var valueLabel: AppLabel!
    @IBOutlet weak var iconView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        valueLabel.isHidden = true
        iconView.isHidden = true
        self.selectionStyle = .none
        setup()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setup(){
        titleLabel.font = .boldSystemFont(ofSize: 15)
        valueLabel.font = .systemFont(ofSize: 15)
    }
    
    func fillCell(title: String, icon: String?, value: String?){
        titleLabel.text = title
        if let value = value {
            valueLabel.isHidden = false
            valueLabel.text = value
        }
        if let icon = icon {
            iconView.image = UIImage(named: icon)
            iconView.isHidden = false
        }
    }

}
