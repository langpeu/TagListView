//
//  ViewController.swift
//  taglistview
//
//  Created by Langpeu on 1/6/25.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = TagListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // TagListView 생성 및 추가
        let tagListView = TagListView(viewModel: viewModel)
        view.addSubview(tagListView)
        tagListView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.height.equalTo(50)
        }
        
        // ViewModel에 데이터 설정
        viewModel.tags.accept(["Swift", "RxSwift", "MVVM", "SnapKit", "Dynamic UI", "Reusable Component"])
        
        // 태그 클릭 이벤트 처리
        viewModel.tagTapped
            .subscribe(onNext: { index, label in
                print("Tapped tag index: \(index), text: \(label.text ?? "")")
                label.backgroundColor = .systemGreen // 클릭 시 배경색 변경
            })
            .disposed(by: disposeBag)
    }
}

