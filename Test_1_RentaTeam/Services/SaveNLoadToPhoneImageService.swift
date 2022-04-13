//
//  SaveNLoadToPhoneImageService.swift
//  Test_1_RentaTeam
//
//  Created by Maksim Ponomarev on 10.11.2021.
// loooks like it does not work
// TODO find out why

import UIKit

class SaveNLoadToPhoneImageService {
    
    static let shared = SaveNLoadToPhoneImageService()
    
    private func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        return documentURL.appendingPathComponent(key)
    }
    
    func saveImage(imageName: String, image: UIImage) {
        guard let data = image.pngData(),
              let filePath = filePath(forKey: imageName) else { return }
        do {
            print("save image to FileManager")
            try data.write(to: filePath, options: .atomic)
        } catch let error {
            print("error saving file with error", error)
        }
    }
    
    func loadImageFromDiskWith(fileName: String) -> UIImage? {
        guard let filePath = filePath(forKey: fileName),
              let fileData = FileManager.default.contents(atPath: filePath.path) else { return nil }
        let image = UIImage(data: fileData)
        return image
    }
    
    func deleteImageFromDisk(fileName: String) {
        guard let filePath = filePath(forKey: fileName) else { return }
        do {
            try FileManager.default.removeItem(atPath: filePath.path)
            print("Removed old image")
        } catch let removeError {
            print("couldn't remove file at path", removeError)
        }
    }
    
}
