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
         
        //        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
//        let fileName = imageName + ".png"
//        let fileURL = documentsDirectory.appendingPathComponent(fileName)
//        guard let data = image.jpegData(compressionQuality: 1) else { return }
        guard let data = image.pngData(),
              let filePath = filePath(forKey: imageName) else { return }
// проверка на повтор имени
        //        if FileManager.default.fileExists(atPath: fileURL.path) {
//            do {
//                try FileManager.default.removeItem(atPath: fileURL.path)
//                print("Removed old image")
//            } catch let removeError {
//                print("couldn't remove file at path", removeError)
//            }
//        }
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
        
//        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
//        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
//        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
//        if let dirPath = paths.first {
//            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
//            let image = UIImage(contentsOfFile: imageUrl.path)
//            return image
//        }
        
        let image = UIImage(data: fileData)
        
        return image
    }
    
}
