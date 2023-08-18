//
//  FriendTableViewCell.swift
//  Talk-Messanger
//
//  Created by 한승우 on 2023/01/17.
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewLabel: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        imageViewLabel.layer.cornerRadius = CGFloat(10)
        imageViewLabel.layer.borderWidth = CGFloat(1)
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
