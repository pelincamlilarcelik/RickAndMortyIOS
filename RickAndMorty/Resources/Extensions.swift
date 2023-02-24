//
//  Extensions.swift
//  RickAndMorty
//
//  Created by Onur Celik on 24.02.2023.
//

import UIKit
extension UIView{
    func addSubviews(_ views: UIView...){
        views.forEach({
            addSubview($0)
        })
    }
}
