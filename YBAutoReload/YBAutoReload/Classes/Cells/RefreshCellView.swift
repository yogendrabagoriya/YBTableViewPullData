//
//  RefreshCellView.swift
//  AutoLoad
//
//  Created by Yogendra Bagoriya on 11/09/16.
//  Copyright © 2016 Yogendra Bagoriya. All rights reserved.
//

import Foundation
import UIKit

class RefreshCellView : UITableViewCell
{
    @IBOutlet weak var progressView : UIActivityIndicatorView!
    @IBOutlet weak var progressLabel : UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func startStopLoading(_ isStart : Bool)
    {
        if(isStart)
        {
            progressView.startAnimating()
            progressLabel.text = "Fetching Data"
        }
        else
        {
            progressView.stopAnimating()
            progressLabel.text = "Pull for more data"
        }
    }
}
