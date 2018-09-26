//
//  LocalDataBase.swift
//  PicPay
//
//  Created by Breno Torquato on 18/09/2018.
//  Copyright © 2018 Breno Torquato. All rights reserved.
//

import CoreData
import UIKit

class LocalDataBase {
    
    //MARK: Attributes
    var entityName: String!
    
    var appDelegate:AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var context:NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
    
    //MARK: init
    init(entityName: String) {
        self.entityName = entityName
    }
    
    //MARK: list
    func list() -> [NSManagedObject] {
        var retorno: [NSManagedObject] = []
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if result.count != 0 {
                retorno = result as! [NSManagedObject]
                return retorno
            }
        } catch {
            print("Failed")
        }
        return retorno
    }
    
    //MARK: save
    func save(_ params:[String:Any]) {
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        let newCard = NSManagedObject(entity: entity!, insertInto: context)
        for param in params {
            newCard.setValue(param.value, forKey: param.key)
        }
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
        
    }
    
    //MARK: find
    func find(_ params:[String:Any]) -> NSManagedObject! {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Card")
        for param in params {
            request.predicate = NSPredicate(format: "\(param.key) = %@", param.value as! CVarArg)
        }
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if result.count != 0 {
                return result[0] as? NSManagedObject
            }
        } catch {
            print("Failed")
        }
        return nil
        
    }
    
    //MARK: delete
    func delete(_ params:[String:Any]){
        guard let cardDelete = find(params) else { return }
        do {
            context.delete(cardDelete)
            try context.save()
        } catch {
            print("Failed")
        }
    }
    
}
