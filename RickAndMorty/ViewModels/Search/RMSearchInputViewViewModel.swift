//
//  RMSearchInputViewViewModel.swift
//  RickAndMorty
//
//  Created by Onur Celik on 2.03.2023.
//

import Foundation
final class RMSearchInputViewViewModel{
    private let type: RMSearchViewController.Config.`Type`
    
    enum DynamicType:String{
        case status = "Status"
        case gender = "Gender"
        case locationType = "Location Type"
        
        var queryArgument: String{
            switch self{
                
            case .status:
                return "status"
            case .gender:
                return "gender"
            case .locationType:
                return "type"
            }
        }
        
        var choices: [String] {
            switch self{
                
            case .status:
                return ["alive","dead","unknown"]
            case .gender:
                return ["male","female","genderless","unknown"]
            case .locationType:
                return ["cluster","planet","microverse"]
            }
        }
    }
    
    init(type: RMSearchViewController.Config.`Type`) {
        self.type = type
    }
     
    
    public var hasDynamicOptions: Bool{
        switch type{
            
        case .character,.location:
            return true
        case .episode:
            return false
        
        }
    }
    public var options: [DynamicType]{
        switch type{
            
        case .character:
            return [.status,.gender]
        case .episode:
            return []
        case .location:
            return [.locationType]
        }
    }
    public var searchPlaceholder: String{
        switch type{
            
        case .character:
            return "Character Name"
        case .episode:
            return "Episode Title"
        case .location:
            return "Location Name"
        }
    }
}
