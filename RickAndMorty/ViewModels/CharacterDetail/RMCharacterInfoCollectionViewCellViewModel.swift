//
//  RMCharacterInfoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Onur Celik on 25.02.2023.
//

import UIKit
final class RMCharacterInfoCollectionViewCellViewModel{
    
    private let type: `Type`
    
    public var title: String{
        self.type.displayTitle
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ"
        return formatter
    }()
    
    static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    private let value: String
    
    public var displayValue: String{
        if value.isEmpty{
            return "None"
        }
        
        if type == .created,
            let date = Self.dateFormatter.date(from: value)
            {
            return Self.shortDateFormatter.string(from: date)
            
        }
        return value
    }
    public var iconImage: UIImage?{
        return type.iconImage
    }
    public var tintColor: UIColor{
        return type.tintColor
    }
    
    enum `Type`: String{
        case status
        case gender
        case type
        case species
        case origin
        case created
        case location
        case episodeCount
        
        var tintColor: UIColor{
            switch self{
                
            case .status:
                return .systemRed
            case .gender:
                return .systemOrange
            case .type:
                return .systemBlue
            case .species:
                return .systemMint
            case .origin:
                return .systemPurple
            case .created:
                return .systemGreen
            case .location:
                return .systemYellow
            case .episodeCount:
                return .systemTeal
            }
        }
        
        var iconImage: UIImage?{
            switch self{
                
            case .status:
                return UIImage(systemName: "bell")
            case .gender:
                return UIImage(systemName: "bell")
            case .type:
                return UIImage(systemName: "bell")
            case .species:
                return UIImage(systemName: "bell")
            case .origin:
                return UIImage(systemName: "bell")
            case .created:
                return UIImage(systemName: "bell")
            case .location:
                return UIImage(systemName: "bell")
            case .episodeCount:
                return UIImage(systemName: "bell")
            }
        }
        
        var displayTitle: String{
            switch self{
                
            case .status,
                    .gender,
                    .type,
                    .species,
                    .origin,
                    .created,
                    .location:
                return rawValue.uppercased()
            case .episodeCount:
                return "EPISODE COUNT"
            }
        }
        
    }
    
    
    init(type: `Type`,value: String){
        self.type = type
        self.value = value
    }
}
