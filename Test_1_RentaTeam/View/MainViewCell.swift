//
//  MainViewCell.swift
//  Test_1_RentaTeam
//
//  Created by Maksim Ponomarev on 09.11.2021.
//

import UIKit

class MainViewCell: UICollectionViewCell {
    
    static let reuseId: String = "mainViewCell"
    
    @IBOutlet weak var photoGrapherNameLabel: UILabel!
    @IBOutlet weak var photoIdLabel: UILabel!
    @IBOutlet weak var metaInfoView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backGroundView: UIView!
    
    func configureCell(viewModel: CellViewModel) {
        
        //let resizedImage = UIImage().resizeImage(image: viewModel.image, targetSize: CGSize(width: 150, height: 150))
        
        imageView.image = viewModel.image//resizedImage
        imageView.layer.cornerRadius = 20
        photoIdLabel.text = viewModel.id
        photoGrapherNameLabel.text = viewModel.photoGrapherName
        metaInfoView.layer.cornerRadius = 10
        backGroundView.layer.cornerRadius = 20
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        photoIdLabel.text = ""
        photoGrapherNameLabel.text = ""
        
    }
    
}
