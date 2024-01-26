//
//  CoinImageService.swift
//  CryptoApp
//
//  Created by Muhammadjon Madaminov on 24/10/23.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService {
    
    @Published var coinImage: UIImage? = nil
    private var imageSubscription: AnyCancellable?
    private let coinFileManager = LocalFileManager.instance
    private let folder = "coin_images"
    private let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        getImage(coin: coin)
    }
    
    private func getImage(coin: CoinModel) {
        if let savedImage = coinFileManager.getImage(imageName: coin.id, folderName: folder) {
            self.coinImage = savedImage
            print("Image got from file manager")
        } else {
            downloadImage(urlString: coin.image)
            print("Downloading")
        }
    }
    
    
    private func downloadImage(urlString: String) {
        
        guard let urlMain = URL(string: urlString) else {
            print("Error with url")
            return
        }
        
        
        imageSubscription = NetworkManager.downloadData(url: urlMain)
            .tryMap({ data -> UIImage?  in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkManager.sinkHandler, receiveValue: { [weak self] image1 in
                guard let self = self,
                      let downloadedImage = image1 else { return }
                self.coinImage = image1
                self.imageSubscription?.cancel()
                self.coinFileManager.saveImage(image: downloadedImage, imageName: self.coin.id, folderName: self.folder) 
            })
        
    }
    
}
