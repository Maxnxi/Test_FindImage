//
//  MainViewCell.swift
//  Test_1_RentaTeam
//
//  Created by Maksim Ponomarev on 09.11.2021.
//

import UIKit

class MainViewCell: UICollectionViewCell {
    
    static let reuseId: String = "mainViewCell"
    
    @IBOutlet weak var metaInfoLabel: UILabel!
    @IBOutlet weak var metaInfoView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backGroundView: UIView!
    
    func configureCell(viewModel: CellViewModel) {
        imageView.image = viewModel.image
        metaInfoLabel.text = viewModel.metaInfo
        metaInfoView.layer.cornerRadius = 10
        backGroundView.layer.cornerRadius = 20
    }
    
}
