//
//  LensDAL.swift
//  Lens reminder
//
//  Created by Nadir on 27/07/2019.
//  Copyright © 2019 Nadir. All rights reserved.
//

import CoreData

class RemoteLensDAL: NSObject {
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func get(id: String) -> RemoteLens? {
        let fr: NSFetchRequest<RemoteLens> = RemoteLens.fetchRequest()
        fr.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let lensList = try context.fetch(fr)
            return lensList.first
        } catch let error {
            print("Failed to fetch lens: \(error)")
            return nil
        }
    }
    
    func get(barcode: String) -> RemoteLens? {
        let fr: NSFetchRequest<RemoteLens> = RemoteLens.fetchRequest()
        fr.predicate = NSPredicate(format: "barcode == %@ AND barcode IS NOT NULL", barcode as CVarArg)
        do {
            let lensList = try context.fetch(fr)
            return lensList.first
        } catch let error {
            print("Failed to fetch lens: \(error)")
            return nil
        }
    }
    
    func getAll() -> [RemoteLens] {
        let fr: NSFetchRequest<RemoteLens> = RemoteLens.fetchRequest()
        let dateSort = NSSortDescriptor(key: #keyPath(Lens.createdAt), ascending: false)
        fr.sortDescriptors = [dateSort]
        do {
            let all = try context.fetch(fr)
            return all
        } catch let error {
            print("Failed to fetch lens: \(error)")
        }
        
        return [RemoteLens]()
    }
    
    func create(id: String, name: String, description: String, image: Data?, barcode: String?, recommendedHours: Int64, maximumHours: Int64) -> RemoteLens? {
        let lens = RemoteLens(context: context)
        
        lens.name = name
        lens.descr = description
        lens.image = image
        lens.recommendedDuration = recommendedHours
        lens.maximumDuration = maximumHours
        lens.id = id
        
        do {
            try context.save()
            return lens
        } catch {
            print("Failed to save the lens")
            return nil
        }
    }
    
    func search(by name: String) -> [RemoteLens] {
        let fr: NSFetchRequest<RemoteLens> = RemoteLens.fetchRequest()
        let dateSort = NSSortDescriptor(key: #keyPath(Lens.createdAt), ascending: false)
        fr.sortDescriptors = [dateSort]
        fr.predicate = NSPredicate(format: "name CONTAINS[cd] %@", name as CVarArg)
        do {
            let all = try context.fetch(fr)
            return all
        } catch let error {
            print("Failed to fetch lens: \(error)")
        }
        
        return [RemoteLens]()
    }
    
    func removeAll() {
        let lens = getAll()
        for item in lens {
            context.delete(item)
        }
        try? context.save()
    }
}
