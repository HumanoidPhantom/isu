//
//  DataRequest.swift
//  isu
//
//  Created by Phantom on 27/07/15.
//  Copyright (c) 2015 Phantom. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// TODO Results and Attendence

class DataRequest {
    
    let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    
    var request: String?
    var user = [NSManagedObject]()
    
    let requestFormatted = ""
    
    init(){}
    
    func getDataFromServer(first_name:String, second_name:String, parent_name:String, auth_number:String, success: () -> Void, failure: (message: String) -> Void) -> Void {
        
        self.request = "first_name=\(first_name)&second_name=\(second_name)&parent_name=\(parent_name)&auth_number=\(auth_number)"
        
        let encodedUrl = CFURLCreateStringByAddingPercentEscapes(nil, self.request!, nil, nil, CFStringBuiltInEncodings.UTF8.rawValue)
        let url = NSURL(string: "http://itbrat.net/app/?\(encodedUrl)")!
        let request = NSURLRequest(URL: url)
        self.session.dataTaskWithRequest(request, completionHandler: {
            data, response, error in
            if error != nil {
                
                failure(message: "Ошибка загрузки. Проверьте наличие подключения к интернету")
            } else {
                // TODO проверить, что данные получены
                do {
                    if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                        success()
                        
                        if json.count != 0 {
                            let faculty = json["faculty"] as? String
                            let profession = json["profession"] as? String
                            let fillial = json["fillial"] as? String
                            
                            let book_number = Int(auth_number)!
                            
                            self.saveUserData(first_name, surname: second_name, patronymic: parent_name, book_number: book_number, profession: profession!, faculty: faculty!, fillial: fillial!)
                            
                            
                            var semesterNumber = 0
                            var typeResult = ""
                            var name = ""
                            var value = ""
                            var section = ""
                            
                            if let courses = json["course"] as? NSArray {
                                for course in courses {
                                    if let semesters = course as? NSDictionary {
                                        
                                        for semester in semesters {
                                            semesterNumber += 1
                                            
                                            if let semest = semester.value as? NSDictionary {
                                                
                                                for discipline in semest {
                                                    
                                                    if let disciplineKey = discipline.key as? String {
                                                        
                                                        if disciplineKey == "totalMissGoodReason" {
                                                            section = "attendance"
                                                            typeResult = "good"
                                                            value = discipline.value as! String
                                                        } else {
                                                            
                                                            if let dataTypeDictionary = discipline.value as? NSDictionary {
                                                                for dataType in dataTypeDictionary {
                                                                    if let dataTypeKey = dataType.key as? String {
                                                                        if dataTypeKey == "name" {
                                                                            name = dataType.value as! String
                                                                        } else if dataTypeKey == "totalRate" {
                                                                            typeResult = dataTypeKey
                                                                            section = "discipline"
                                                                        } else {
                                                                            if dataTypeKey.hasPrefix("module_miss") {
                                                                                section = "attendance"
                                                                                typeResult = "\(dataTypeKey[dataTypeKey.endIndex.predecessor()])"
                                                                                
                                                                            } else {
                                                                                section = "discipline"
                                                                                
                                                                                switch dataTypeKey {
                                                                                case "module_kurs":
                                                                                    typeResult = "kurs"
                                                                                    break
                                                                                case "module_zachet":
                                                                                    typeResult = "zachet"
                                                                                    break
                                                                                case "module_exam":
                                                                                    typeResult = "exam"
                                                                                    break
                                                                                default:
                                                                                    typeResult = "\(dataTypeKey[dataTypeKey.endIndex.predecessor()])"
                                                                                    break
                                                                                    
                                                                                }
                                                                                
                                                                            }
                                                                            
                                                                            value = dataType.value as! String
                                                                            
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                            
                                                        }
                                                        self.saveUserData(name, value: value, semester: "\(semesterNumber)", section: section, type: typeResult)
                                                        
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                        }
                    } else {
                        failure(message: "Ошибка. Проверьте правильность введенных данных")
                        
                    }
                }
                catch {
                    print("error")
                }
                
            }
        }).resume()
    }
    
    func saveUserData(name: String, value: String, semester: String, section: String = "", type: String = "") {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext!
        var entity: NSEntityDescription?
        
        if section != "" {
            entity = NSEntityDescription.entityForName("Discipline", inManagedObjectContext: context)
        } else {
            entity = NSEntityDescription.entityForName("Results", inManagedObjectContext: context)
        }
        
        let discipline = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: context)

        discipline.setValue(name, forKey: "name")
        discipline.setValue(value, forKey: "value")
        discipline.setValue(semester, forKey: "semester")
        
        if section != "" {
            discipline.setValue(section, forKey: "section")
            discipline.setValue(type, forKey: "type")
        }
        
        do {
            try context.save()
        }
        catch {
            print("Could not save")
        }
        
        self.user.append(discipline)
    }
    
    func saveUserData(name:String, surname: String, patronymic:String, book_number: Int, profession: String, faculty: String, fillial: String) {
        guard let appDel: AppDelegate = UIApplication.sharedApplication().delegate as? AppDelegate else {
            print("error")
            return
        }
        let context: NSManagedObjectContext = appDel.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("UserInfo", inManagedObjectContext: context)
        let result = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: context)
        
        result.setValue(name, forKey: "name")
        result.setValue(surname, forKey: "surname")
        result.setValue(patronymic, forKey: "patronymic")
        result.setValue(book_number, forKey: "book_number")
        result.setValue(profession, forKey: "profession")
        result.setValue(faculty, forKey: "faculty")
        result.setValue(fillial, forKey: "fillial")
        
        do {
            try context.save()
        }
        catch {
            print("Could not save")
        }
        
        self.user.append(result)
    }
    
    func fetchUserData() -> [String : String] {
        var infoDictionary = [String : String]()

        self.getDataFromTheDB("UserInfo")
        
        if self.user.count != 0 {
            for res in self.user {
                infoDictionary["name"] = res.valueForKey("name") as? String
                infoDictionary["surname"] = res.valueForKey("surname") as? String
                infoDictionary["patronymic"] = res.valueForKey("patronymic") as? String
                infoDictionary["faculty"] = res.valueForKey("faculty") as? String
                infoDictionary["profession"] = res.valueForKey("profession") as? String
                infoDictionary["fillial"] = res.valueForKey("fillial") as? String
            }
            
        }
        
        return infoDictionary
    }
    
    func fetchCoreData(type: String, semester: Int = -1) -> [String] {
        var infoDictionary = [String]()
        self.getDataFromTheDB(type, semester: semester)

        if self.user.count != 0 {
            switch type {
            case "Discipline" :
                for (_, res) in self.user.enumerate() {
                    infoDictionary.append((res.valueForKey("name") as? String)!)
                }
                break
            case "Results" :
                //                for res in self.user {
                //                    infoArray.append(res.valueForKey("name") as NSString)
                //                }
                break
            default :
                break
            }
            
        }
        
        return infoDictionary
    }
    
    func fetchCurrentSemester() -> Int? {
        var semester: Int?
        
        getDataFromTheDB("Discipline", semester: -1)

        if self.user.count != 0 {
            let element = self.user[0]

            let data = element.valueForKey("semester") as? NSString
            semester = Int(data! as String)
        }
        return semester
    }
    
    func deleteAllFromCoreData() {
        let appDel = UIApplication.sharedApplication().delegate as? AppDelegate
        let context = appDel!.managedObjectContext!
        
        do {
            var fetchRequest = NSFetchRequest(entityName: "Discipline")
            fetchRequest.returnsObjectsAsFaults = false
            
            var fetchedResults = try context.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            if let res = fetchedResults {
                for result in res {
                    context.deleteObject(result as NSManagedObject)
                }
                
                do {
                    try context.save()
                }
                catch {
                    print("Could not save")
                }
            }
            
            fetchRequest = NSFetchRequest(entityName: "Results")
            fetchRequest.returnsObjectsAsFaults = false
            
            fetchedResults = try context.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            if let res = fetchedResults {
                for result in res {
                    context.deleteObject(result as NSManagedObject)
                }
                
                do {
                    try context.save()
                }
                catch {
                    print("Could not save")
                }
            }
            
            fetchRequest = NSFetchRequest(entityName: "UserInfo")
            fetchRequest.returnsObjectsAsFaults = false
            
            fetchedResults = try context.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            if let res = fetchedResults {
                for result in res {
                    context.deleteObject(result as NSManagedObject)
                }
                
                do {
                    try context.save()
                }
                catch {
                    print("error")
                }
                
            }
        }
        catch {
            print("error")
        }
        
    }
    
    func coreDataHasData() -> Bool {
        let appDel = UIApplication.sharedApplication().delegate as? AppDelegate
        let context = appDel!.managedObjectContext!
    
        let fetchRequest = NSFetchRequest(entityName: "UserInfo")
        do {
            let fetchedResults = try context.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResults {
                if results.count > 0 {
                    return true
                } else {
                    return false
                }
            }
        }
        catch {
            print("error")
        }
        
        return false
    }
    
    // if semester is -1 - should find current semester
    // if nil - should get all from the entity
    // if >-1 - should get disciplines from that semester
    
    func getDataFromTheDB(entityName: String, semester: Int? = nil) {
        let appDel = UIApplication.sharedApplication().delegate as? AppDelegate
        let context = appDel!.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: entityName)
        
        if let seted_semester = semester {
            if seted_semester != -1 {
                fetchRequest.predicate = NSPredicate(format: "semester = %@", "\(seted_semester)")
            } else {
                fetchRequest.fetchLimit = 1;
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "semester", ascending: false)]
            }
        }
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            
            if let res = try context.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
                self.user = res
            } else {
                print("Could not fetch")
            }
        }
        catch {
            print("error")
        }
        
        
    }
    
}