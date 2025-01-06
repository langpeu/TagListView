//
//  TagListViewModel.swift
//  taglistview
//
//  Created by Langpeu on 1/6/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

// MARK: - ViewModel
struct TagListViewModel {
    let tags: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    let tagTappedRelay = PublishRelay<(index: Int, label: UILabel)>()
    
    var tagTapped: Observable<(index: Int, label: UILabel)> {
        tagTappedRelay.asObservable()
    }
}
