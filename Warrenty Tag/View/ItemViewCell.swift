//
//  ItemViewCell.swift
//  Warrenty Tag
//
//  Created by Bishal kumar  on 31/08/21.
//

import UIKit

class ItemViewCell: UITableViewCell {

    @IBOutlet weak var warrentyTimeLabel: UILabel!
    @IBOutlet weak var warrentyDateLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var itemNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
