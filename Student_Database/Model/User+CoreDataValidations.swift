//
//  User+CoreDataValidations.swift
//  Student_Database
//
//  Created by Tong Yi on 6/13/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

//import CoreData
//
//extension Student
//{
//    var errorDomain: String {
//        return "UserErrorDomain"
//    }
//
//    enum StudentErrorType: Int
//    {
//        case InvalidStudentMajor
//        case InvalidStudentNameOrMajor
//    }
//
//    public override func validateForInsert() throws
//    {
//        try super.validateForInsert()
//        guard let name = name else { throw NSError(domain: errorDomain, code: StudentErrorType.InvalidStudentNameOrMajor.rawValue, userInfo: [NSLocalizedDescriptionKey: "The Student Name or Major can not be Nil!"])}
//
//        guard let major = major else { throw NSError(domain: errorDomain, code: StudentErrorType.InvalidStudentNameOrMajor.rawValue, userInfo: [NSLocalizedDescriptionKey: "The Student Name or Major can not be Nil!"])}
//
//        if name.count > 20 || major.count > 20
//        {
//            throw NSError(domain: errorDomain, code: StudentErrorType.InvalidStudentNameOrMajor.rawValue, userInfo: [NSLocalizedDescriptionKey: "The Student Name or Major can not be Greater than 20 Characters!"])
//        }
//    }
//
//    public override func validateForUpdate() throws
//    {
//        try super.validateForUpdate()
//    }
//
//    public override func validateValue(_ value: AutoreleasingUnsafeMutablePointer<AnyObject?>, forKey key: String) throws
//    {
//        if key == "major"
//        {
//            var error: NSError? = nil
//            if let first = value.pointee as? String
//            {
//                if first == ""
//                {
//                    let errorType = StudentErrorType.InvalidStudentMajor
//                    error = NSError(domain: errorDomain, code: errorType.rawValue, userInfo: [NSLocalizedDescriptionKey: "The Student Major can not be Empty!"])
//                }
//                else if first.count > 20
//                {
//                    let errorType = StudentErrorType.InvalidStudentMajor
//                    error = NSError(domain: errorDomain, code: errorType.rawValue, userInfo: [NSLocalizedDescriptionKey: "The Student Major can not be Greater than 20 Characters!"])
//                }
//            }
//            else
//            {
//                let errorType = StudentErrorType.InvalidStudentMajor
//                error = NSError(domain: errorDomain, code: errorType.rawValue, userInfo: [NSLocalizedDescriptionKey: "The Student Major can not be nil!"])
//            }
//
//            if let error = error
//            {
//                throw error
//            }
//        }
//    }
//}


