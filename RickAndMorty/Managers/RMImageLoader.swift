//
//  ImageLoader.swift
//  RickAndMorty
//
//  Created by Onur Celik on 24.02.2023.
//

import Foundation
final class RMImageLoader{
    static let shared = RMImageLoader()
    private init(){}
    
    private var imageDataCache = NSCache<NSString,NSData>()
    
    public func downloadImage(url:URL,completion: @escaping (Result<Data,Error>)->Void){
        let key = url.absoluteString as NSString
        if let data = imageDataCache.object(forKey: key){
            completion(.success(data as Data))
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) {[weak self] data, _, error in
            guard let data = data, error == nil else{
                completion( .failure(error ?? URLError(.badServerResponse)))
                return
            }
            
            let value = data as NSData
            self?.imageDataCache.setObject(value, forKey: key)
            completion(.success(data))
        }
        task.resume()
    }
    
}
