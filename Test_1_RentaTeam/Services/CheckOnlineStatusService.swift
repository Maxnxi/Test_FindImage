//
//  CheckOnlineStatusService.swift
//  Test_1_RentaTeam
//
//  Created by Maksim Ponomarev on 10.11.2021.
//

import Foundation

class CheckOnlineStatusService {
    
    static let shared = CheckOnlineStatusService()
    
    private init() { }
    
    // make random fo fun
    func makeRandomServerString() -> String {
        let alphabetString = "abcdefghijklmnopqrstvwxyz"
        let randomLetter = alphabetString.randomElement()
        let stringToUrl = "https://pexels.com/\(randomLetter ?? "z"))"
        print("stringToUrl - ", stringToUrl)
        return stringToUrl
    }
    
    public func checkServerPexelsIsOnline(completion: @escaping(_ result: Bool) -> ()) {
        if let url = URL(string: self.makeRandomServerString()) {
            self.checkServerPexelsIsOnline(url: url) { result in
                if result == true {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    private func checkServerPexelsIsOnline(url: URL, completion: @escaping(_ result: Bool) -> ()) {
        let config = URLSessionConfiguration.default
        if #available(iOS 13.0, *) {
            config.allowsExpensiveNetworkAccess = true
        } else {
            // Fallback on earlier versions
            print("Fallback on earlier versions")
        }
        let session = URLSession(configuration: config)
        var dataTask: URLSessionDataTask?
        dataTask?.cancel()
        
        dataTask = session.dataTask(with: url) { data, response, error in
            if error != nil {
                //Pexels is offline or smth else
                print("Pexels is offline")
                completion(false)
            } else {
                print("Pexels is online")
                print("data is - ", data as Any)
                print("Pexels is online - ", response as Any)
                completion(true)
            }
        }
        dataTask?.resume()
    }
}
