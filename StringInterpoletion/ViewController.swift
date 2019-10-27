//
//  ViewController.swift
//  StringInterpoletion
//
//  Created by shiga on 26/10/19.
//  Copyright © 2019 Shigas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 1,2
        let aged = 79
        print(" I am \(aged) \(Date())")


        // 3
        let age = 19
        print("Driving Result: \(if: age > 18, "You can drive the car")")
        
        //4
        print("Values: \(["A","B"], default: "Empty Array")")
        
        //5
        let name:String? = nil
        print("\(name, defaultValue: "empty")")
        
        
        //6
        let message: ConsoleMessage = "\(.todo, message: "It should be fixed")"
        let waningMessage:ConsoleMessage = "\(assignedTo: "Arjun", type: .warning, message: "Please look into this. It shouldn't come")"
        
        print(message)
        print(waningMessage)
    }


}

// 1

extension String.StringInterpolation {
    mutating func appendInterpolation(_ value: Int) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        guard let spelledValue = formatter.string(from: value as NSNumber) else { return  }
        appendLiteral(spelledValue)
    }
}

//2

extension String.StringInterpolation {
    mutating func appendInterpolation(_ date: Date){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .full
        let formattedDate = formatter.string(from: date)
        appendLiteral(formattedDate)
    }
}

//3

extension String.StringInterpolation {
    mutating func appendInterpolation(if condition: @autoclosure () -> Bool, _ literal: StringLiteralType) {
        guard condition()  else { return }
        appendLiteral(literal)
    }
}


// 4

extension String.StringInterpolation {
    mutating func appendInterpolation(_ values: [String], default: @autoclosure () -> String) {
        if !values.isEmpty {
           // appendLiteral(values.joined(separator: "->"))
            appendLiteral(values.joined(separator: "->"))
        } else {
        appendLiteral(`default`())
        }
    }
}


// 5

extension String.StringInterpolation {
    
    mutating func appendInterpolation(_ value:String?, defaultValue: String) {
        if let wrapped = value {
            appendLiteral(wrapped)
        } else {
            appendLiteral(defaultValue)
        }
    }
}

//6

struct ConsoleMessage: ExpressibleByStringInterpolation {
    struct StringInterpolation: StringInterpolationProtocol{
        
        enum MessageType {
            case warning
            case general
            case error
            case todo
            case fixme
            
            func value() -> String {
                switch self {
                case .warning:
                    return "warning"
                case .general:
                    return "General"
                case .error:
                    return "ERROR"
                case .todo:
                    return "TODO"
                case .fixme:
                    return "FIXME"
                }
            }
        }
        
        var formattedMessage:String = String()
        
        init(literalCapacity: Int, interpolationCount: Int) {}
        
        mutating func appendLiteral(_ literal: String) {
            formattedMessage.append(literal)
        }
        
        mutating func appendInterpolation(_ type: MessageType, message: String) {
            formattedMessage.append("\(type.value()): \(message)")
        }
        
        mutating func appendInterpolation(if condition: @autoclosure () ->Bool, message: String) {
            guard condition() else {return}
            formattedMessage.append(message)
        }
        
        mutating func appendInterpolation(assignedTo name: String, type:MessageType, message: String) {
            formattedMessage.append("This is a \(type) message for \(name) :-> \(message)")
        }
    }
    
    let message: String
    
    init(stringLiteral value:String) {
        self.message = value
    }
    
    init(stringInterpolation: Self.StringInterpolation) {
        self.message = stringInterpolation.formattedMessage
    }
    
}


extension ConsoleMessage: CustomStringConvertible {
    var description: String {
        return message
    }
}


