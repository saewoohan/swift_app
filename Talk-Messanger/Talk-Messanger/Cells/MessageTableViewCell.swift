//
//  MessageTableViewCell.swift
//  Talk-Messanger
//
//  Created by 한승우 on 2023/01/27.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var imageViewLabel: UIImageView!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageViewLabel.layer.cornerRadius = CGFloat(10)
        imageViewLabel.layer.borderWidth = CGFloat(1)
        myImageView.layer.cornerRadius = CGFloat(10)
        myImageView.layer.borderWidth = CGFloat(1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
