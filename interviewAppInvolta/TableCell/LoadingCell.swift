//
//  LoadingCell.swift
//  interviewAppInvolta
//
//  Created by Alexey Il on 20.02.2022.
//

import UIKit

class LoadingCell: UITableViewCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
//        activityIndicator.color = UIColor.white
    }

    
}
