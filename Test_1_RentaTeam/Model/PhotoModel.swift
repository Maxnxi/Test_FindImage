//
//  PhotoModel.swift
//  Test_1_RentaTeam
//
//  Created by Maksim Ponomarev on 09.11.2021.
//

import Foundation

class PhotoModel {
    
    let id: Int //3408744,
    let photographer: String //"stein egil liland",
    let avgColor: String //"#557088",
    let url: String //"https://images.pexels.com/photos/3408744/pexels-photo-3408744.jpeg?auto=compress&cs=tinysrgb&h=350"
        
    init(id: Int, photographer: String, averageColor: String, url: String) {
        self.id = id
        self.photographer = photographer
        self.avgColor = averageColor
        self.url = url
    }

}
