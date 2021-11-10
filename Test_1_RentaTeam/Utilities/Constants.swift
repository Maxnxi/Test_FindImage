//
//  Constants.swift
//  Test_1_RentaTeam
//
//  Created by Maksim Ponomarev on 09.11.2021.
//

import Foundation

//let apiKey = "563492ad6f91700001000001d862ba01d13343e2866c8ea4066b27ec"
//
//let URL_PEXELS = "https://api.pexels.com/v1/search?query=nature"

func pexelsUrl(forApiKey key: String, andNumberOfPhotos number: Int) -> String {
    return "https://api.pexels.com/v1/search?query=nature&per_page=1" //"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&lat=\(annotation.coordinate.latitude)&lon=\(annotation.coordinate.longitude)&radius=1&radius_units=mi&per_page=\(number)&format=json&nojsoncallback=1"
}
