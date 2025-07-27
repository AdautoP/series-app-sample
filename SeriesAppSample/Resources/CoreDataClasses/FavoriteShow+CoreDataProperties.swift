//
//  FavoriteShow+CoreDataProperties.swift
//  SeriesAppSample
//
//  Created by Adauto Pinheiro on 27/07/25.
//
//

import Foundation
import CoreData


extension FavoriteShow {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteShow> {
        return NSFetchRequest<FavoriteShow>(entityName: "FavoriteShow")
    }

    @NSManaged public var id: Int64

}

extension FavoriteShow: Identifiable {
    static func toggle(id: Int, context: NSManagedObjectContext) {
        let request = fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        request.fetchLimit = 1

        if let result = try? context.fetch(request), let existing = result.first {
            context.delete(existing)
        } else {
            let favorite = FavoriteShow(context: context)
            favorite.id = Int64(id)
        }

        try? context.save()
    }

    static func isFavorite(id: Int, context: NSManagedObjectContext) -> Bool {
        let request = fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        request.fetchLimit = 1

        let count = (try? context.count(for: request)) ?? 0
        return count > 0
    }
}
