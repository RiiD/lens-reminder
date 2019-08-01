//
//  LensDAL.swift
//  Lens reminder
//
//  Created by Nadir on 27/07/2019.
//  Copyright © 2019 Nadir. All rights reserved.
//

import CoreData

class LensDAL: NSObject {
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func get(id: UUID) -> Lens? {
        let fr: NSFetchRequest<Lens> = Lens.fetchRequest()
        fr.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let lensList = try context.fetch(fr)
            return lensList.first
        } catch let error {
            print("Failed to fetch lens: \(error)")
            return nil
        }
    }
    
    func get(barcode: String) -> Lens? {
        let fr: NSFetchRequest<Lens> = Lens.fetchRequest()
        fr.predicate = NSPredicate(format: "barcode == %@ AND barcode IS NOT NULL", barcode as CVarArg)
        do {
            let lensList = try context.fetch(fr)
            return lensList.first
        } catch let error {
            print("Failed to fetch lens: \(error)")
            return nil
        }
    }
    
    func getAll() -> [Lens] {
        let fr: NSFetchRequest<Lens> = Lens.fetchRequest()
        let dateSort = NSSortDescriptor(key: #keyPath(Lens.createdAt), ascending: false)
        fr.sortDescriptors = [dateSort]
        do {
            let all = try context.fetch(fr)
            return all
        } catch let error {
            print("Failed to fetch lens: \(error)")
        }
        
        return [Lens]()
    }
    
    func create(name: String, description: String, image: Data?, barcode: String?, recommendedHours: Int64, maximumHours: Int64) -> Lens? {
        let lens = Lens(context: context)
        
        lens.name = name
        lens.descr = description
        lens.image = image
        lens.recommendedDuration = recommendedHours
        lens.maximumDuration = maximumHours
        lens.createdAt = Date.init()
        lens.id = UUID()
        
        do {
            try context.save()
            return lens
        } catch {
            print("Failed to save the lens")
            return nil
        }
    }
}
