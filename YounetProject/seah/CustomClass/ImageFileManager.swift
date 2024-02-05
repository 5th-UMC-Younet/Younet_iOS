//
//  ImageFileManager.swift
//  YounetProject
//
//  Created by 김세아 on 2/3/24.
//

import Foundation
import UIKit

class ImageFileManager : FileManager {
    static let shared: ImageFileManager = ImageFileManager()
    // Save Image
    // name: ImageName
    func saveImage(image: UIImage, name: String,
                   onSuccess: @escaping ((Bool) -> Void)) {
        guard let data: Data
                = image.jpegData(compressionQuality: 1)
                ?? image.pngData() else { return }
        if let directory: NSURL =
            try? FileManager.default.url(for: .documentDirectory,
                                         in: .userDomainMask,
                                         appropriateFor: nil,
                                         create: false) as NSURL {
            do {
                try data.write(to: directory.appendingPathComponent(name)!)
                onSuccess(true)
            } catch let error as NSError {
                print("Could not saveImage: \(error), \(error.userInfo)")
                onSuccess(false)
            }
        }
    }
    
    // named: 저장할 때 지정했던 uniqueFileName
    func getSavedImage(named: String) -> UIImage? {
        if let dir: URL
            = try? FileManager.default.url(for: .documentDirectory,
                                           in: .userDomainMask,
                                           appropriateFor: nil,
                                           create: false) {
            let path: String
            = URL(fileURLWithPath: dir.absoluteString)
                .appendingPathComponent(named).path
            let image: UIImage? = UIImage(contentsOfFile: path)
            
            return image
        }
        return nil
    }
    
    func deleteImage(named: String,
                     onSuccess: @escaping ((Bool) -> Void)) {
        guard let directory =
                try? FileManager.default.url(for: .documentDirectory,
                                             in: .userDomainMask,
                                             appropriateFor: nil,
                                             create: false) as NSURL
        else { return }
        do {
            if let docuPath = directory.path {
                let fileNames = try
                FileManager.default.contentsOfDirectory(atPath: docuPath)
                for fileName in fileNames {
                    if fileName == named {
                        let filePathName = "\(docuPath)/\(fileName)"
                        try FileManager.default.removeItem(atPath: filePathName)
                        onSuccess(true)
                        return
                    }
                }
            }
        } catch let error as NSError {
            print("Could not deleteImage: \(error), \(error.userInfo)")
            onSuccess(false)
        }
    }
}
