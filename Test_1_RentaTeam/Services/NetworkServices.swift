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
    
    func getDataFromServer(page: Int = 1, completion: @escaping(Swift.Result<[PhotoModel], AppError>) -> Void) {
        let headers: HTTPHeaders = [ "Content-Type": "application/json",
                                     "Authorization": "\(apiKey)" ]
        let parameters: [String: Any] = [ "query": "nature",
                                          "page" : page,
                                          "per_page": 50 ]
        AF.request(URL_PEXELS, method: .get, parameters: parameters, headers: headers).responseJSON { [weak self] response in
            print("request is - ", response.request?.urlRequest as Any)
            print("response is - ", response.value as Any)
            
            guard let data = response.data as? Data else {
                print("Error in Alamofire.request at getAdsFromServer")
                return
                completion(.failure(AppError.noDataProvided))
            }
            do {
                let rspns = try JSONDecoder().decode( ResponseFromServer.self, from: data)
                let photos = rspns.photos
                var photosArray: [PhotoModel] = []
                photos.forEach({ photo in
                    var url: String = ""
                    if let tmpUrl = photo.src.medium as? String {
                        url = tmpUrl
                    } else {
                        let tmpUrl = photo.src.original
                        url = tmpUrl
                    }
                    let tmpPhoto = PhotoModel(id: photo.id, photographer: photo.photographer, averageColor: photo.avgColor, url: url)
                    photosArray.append(tmpPhoto)
                })
                if photosArray.count == photos.count {
                    completion(.success(photosArray))
                }
            } catch {
                // do catch
            }
        }
    }
    
    func downloadImage(url: URL, completion: @escaping(_ image: PhotoCache) -> ()) {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage)
        } else {
            let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 20)
            let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, err in
                guard let imageData = data,
                let image = UIImage(data: imageData) else { return }
                let date = Date()
                let photoCache = PhotoCache(image: image, dateOfDownloaded: date)
                self?.imageCache.setObject(photoCache, forKey: url.absoluteString as NSString)
                
                DispatchQueue.main.async {
                    completion(photoCache)
                }
            }
            dataTask.resume()
        }
    }
    
}


