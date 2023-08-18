//
//  AddChatTableViewCell.swift
//  Talk-Messanger
//
//  Created by 한승우 on 2023/02/08.
//

import UIKit

class AddChatTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageViewLabel: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageViewLabel.layer.cornerRadius = CGFloat(10)
        imageViewLabel.layer.borderWidth = CGFloat(1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
