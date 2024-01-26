//
//  ProfileDataService.swift
//  CryptoApp
//
//  Created by Muhammadjon Madaminov on 04/12/23.
//

import Foundation
import SwiftUI
import CoreData


class ProfileDataService {
    
    private let container: NSPersistentContainer
    private let containerName: String = "ProfileContainer"
    private let entityName: String = "ProfileEntity"
    
    @Published var entities: [ProfileEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading coredata: \(error.localizedDescription)")
            }
            self.getProfile()
        }
    }
    
    //MARK: Public
    
    
    func updateProfile(coin: CoinModel, amount: Double) {
        if let entity = entities.first(where: { $0.coinID == coin.id }) {
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                deleteEntity(entity: entity)
            }
        } else {
            if amount > 0 {
                add(coin: coin, amount: amount)
            }
        }
        applyChanges()
    }
    
    
    
    
    //MARK: Private
    
    private func getProfile() {
        let request = NSFetchRequest<ProfileEntity>(entityName: entityName)
        do {
            entities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching entity: \(error)")
        }
    }
    
    private func add(coin: CoinModel, amount: Double) {
        let entity = ProfileEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        applyChanges()
    }
    
    
    private func update(entity: ProfileEntity, amount: Double) {
        entity.amount = amount
        applyChanges()
    }
    
    
    private func deleteEntity(entity: ProfileEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error while saving: \(error.localizedDescription)")
        }
    }
    
    private func applyChanges() {
        save()
        getProfile()
    }
    
    
}



