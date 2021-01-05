//
//  ViewModelType.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/04.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}
