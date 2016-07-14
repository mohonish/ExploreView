//
//  FeaturedCollectionViewCell.swift
//  ExploreView
//
//  Created by Mohonish Chakraborty on 15/07/16.
//  Copyright © 2016 mohonish. All rights reserved.
//

import UIKit

class FeaturedCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cellImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        customizeCell()
    }
    
    func customizeCell() {
        
        cellImageView.layer.cornerRadius = 20.0
        cellImageView.layer.borderColor = UIColor.lightGrayColor().CGColor
        cellImageView.layer.borderWidth = 1.0
        cellImageView.layer.masksToBounds = true
        cellImageView.clipsToBounds = true
        
    }

}
