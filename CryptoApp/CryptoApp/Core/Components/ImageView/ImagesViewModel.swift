//
//  ImagesViewModel.swift
//  CryptoApp
//
//  Created by Muhammadjon Madaminov on 22/10/23.
//

import Foundation
import UIKit
import Combine
import SwiftUI



class ImagesViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading: Bool = false
    
    private let coin: CoinModel
    private let coinImageService: CoinImageService
    private var cancallables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coin = coin
        self.coinImageService = CoinImageService(coin: coin)
        self.addSubscribers()
        self.isLoading = true
    }
    
    private func addSubscribers() {
        coinImageService.$coinImage
            .sink { [weak self] _ in
                self?.isLoading = false
            } receiveValue: { [weak self] coinImage in
                self?.image = coinImage
                self?.isLoading = false
            }
            .store(in: &cancallables)

    }
    
}







/*
 private func downloadImage() {
isLoading = true
guard let imageUrl = URL(string: self.url) else {
    isLoading = false
    return
}

URLSession.shared.dataTaskPublisher(for: imageUrl)
    .subscribe(on: DispatchQueue.global(qos: .default))
    .tryMap({ try ImagesViewModel.httpsResponseHandler2(output: $0) })
    .receive(on: DispatchQueue.main)
    .sink { [weak self] (_) in
        self?.isLoading = false
    } receiveValue: { [weak self] image in
        guard let image2 = image else {
            return
        }
        self?.isLoading = false
        self?.image = image2
    }
    .store(in: &cancellable)


}

static func httpsResponseHandler2(output: URLSession.DataTaskPublisher.Output) throws -> UIImage? {
guard let response = output.response as? HTTPURLResponse,
      response.statusCode >=  200 && response.statusCode < 300 else {
    throw NetworkManager.NetworkingError.badURLResponse
}
return UIImage(data: output.data)
}*/
