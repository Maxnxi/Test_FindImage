//
//  CellViewModel.swift
//  Test_1_RentaTeam
//
//  Created by Maksim Ponomarev on 09.11.2021.
//

import Foundation
import UIKit

class CellViewModel {
    
    let image: UIImage
    let metaInfo: String
    let downloadDate: String
    
    init(image: UIImage, metaInfo: String, downoladDate: String) {
        self.image = image
        self.metaInfo = metaInfo
        self.downloadDate = downoladDate
    }
}
