//
//  RMAPICacheManager.swift
//  RickAndMorty
//
//  Created by Onur Celik on 27.02.2023.
//

import Foundation
final class RMAPICacheManager{
    
    private var cache = NSCache<NSString,NSData>()
    
    private var cacheDictionary: [RMEndpoint:NSCache<NSString,NSData> ] = [:]
    
    init(){
        setUpCache()
    }
   // MARK: Public
    public func cachedResponse(for endpoint:RMEndpoint,url: URL?)->Data?{
        guard let targetData = cacheDictionary[endpoint],let url = url else {
            return nil
        }
        let key = url.absoluteString as NSString
        return targetData.object(forKey: key) as? Data
    }
    
    public func setCache(for endpoint: RMEndpoint,url:URL?,data: Data){
        guard let targetCache = cacheDictionary[endpoint],let url = url else{
            return
        }
        let data = data as NSData
        let key = url.absoluteString as NSString
        targetCache.setObject(data, forKey: key)
    }
    
    
    // MARK: Private
    private func setUpCache(){
        RMEndpoint.allCases.forEach { endpoint in
           cacheDictionary[endpoint] = NSCache<NSString,NSData>()
        }
    }
}
