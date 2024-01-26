//
//  LocalFileManager.swift
//  CryptoApp
//
//  Created by Muhammadjon Madaminov on 25/10/23.
//

import Foundation
import SwiftUI


class LocalFileManager {
    
    static let instance = LocalFileManager()
    
    private init() {
        
    }
    
    func saveImage(image: UIImage, imageName: String, folderName: String) {
        
        createFolder(folderName: folderName)
        
        guard let image = image.pngData(),
            let url = getImageURL(name: imageName, folderName: folderName)
        else { return }
        
        
        do {
            try image.write(to: url)
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    func getImage(imageName: String, folderName: String) -> UIImage? {
        guard
            let url = getImageURL(name: imageName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        return UIImage(contentsOfFile: url.path)
    }
    
    
    
    private func getURLForFolder(folderName: String) -> URL? {
        
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appending(path: folderName, directoryHint: .isDirectory)
    }
    
    private func createFolder(folderName: String) {
        guard let url = getURLForFolder(folderName: folderName) else { return }
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(atPath: url.path, withIntermediateDirectories: true)
            } catch let error {
                print("Error while creating folder: \(error.localizedDescription)")
            }
        }
    }
    
    
    private func getImageURL(name: String, folderName: String) -> URL? {
        guard let imageURL = getURLForFolder(folderName: folderName) else {
            return nil
        }
        return imageURL.appendingPathComponent(name, conformingTo: .png)
    }
}
