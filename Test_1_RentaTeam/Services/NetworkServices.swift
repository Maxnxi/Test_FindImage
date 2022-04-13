//
//  Networkservices.swift
//  Test_1_RentaTeam
//
//  Created by Maksim Ponomarev on 09.11.2021.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

let apiKey = "563492ad6f91700001000001d862ba01d13343e2866c8ea4066b27ec"
let URL_PEXELS = "https://api.pexels.com/v1/search"

class NetworkServices {
    

    var imageCache = NSCache<NSString, PhotoCache>()
    
    func getDataFromServer(page: Int = 1, query: String, completion: @escaping(Swift.Result<[PhotoModel], AppError>) -> Void) {
        let headers: HTTPHeaders = [ "Content-Type": "application/json",
                                     "Authorization": "\(apiKey)" ]
        let parameters: [String: Any] = [ "query": query.lowercased(),
                                          "page" : page,
                                          "per_page": 10 ]
        AF.request(URL_PEXELS, method: .get, parameters: parameters, headers: headers).responseJSON { response in
            print("request is - ", response.request?.urlRequest as Any)
            print("response is - ", response.value as Any)
            
            guard let data = response.data as? Data else {
                print("Error in Alamofire.request at getAdsFromServer")
                return completion(.failure(AppError.noDataProvided))
            }
            do {
                let rspns = try JSONDecoder().decode( ResponseFromServer.self, from: data)
                if rspns.totalResults == 0 {
                    print("rspns.totalResults == 0")
                    completion(.failure(AppError.noPhotoOnServer))
                }
                guard let photos = rspns.photos else {
                    print("photos = rspns.photos")
                    return completion(.failure(AppError.noPhotoOnServer))
                }
                var photosArray: [PhotoModel] = []
                photos.forEach({ photo in
                    var url: String = ""
                    if let tmpUrl = photo.src.medium as? String {
                        url = tmpUrl
                    } else {
                        let tmpUrl = photo.src.original
                        url = tmpUrl
                    }
                    let idString = String(describing: photo.id)
                    
                    let tmpPhoto = PhotoModel(id: idString, photographer: photo.photographer, averageColor: photo.avgColor, url: url)
                    photosArray.append(tmpPhoto)
                })
                if photosArray.count == photos.count {
                    completion(.success(photosArray))
                }
            } catch {
                print("Catch is here")
                // do catch
                // временно
                completion(.failure(AppError.noPhotoOnServer))
            }
        }
    }
    
    func downloadImage(url: URL, completion: @escaping(_ image: PhotoCache?) -> ()) {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            print("Cached images")
            completion(cachedImage)
        } else {
            AF.request(url).responseImage { response in
                switch response.result {
                case .success(let image):
                    let date = Date()
                    let photoCache = PhotoCache(image: image, dateOfDownloaded: date)
                    completion(photoCache)
                case .failure(let err):
                    print("Error in downloadImage - ", err)
                    completion(nil)
                }
            }
        }
    }
    
}


