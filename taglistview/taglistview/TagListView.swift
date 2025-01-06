import UIKit
import SnapKit
import RxSwift
import RxCocoa

// MARK: - TagListView
class TagListView: UIView {
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let disposeBag = DisposeBag()
    
    let viewModel: TagListViewModel
    
    init(viewModel: TagListViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupScrollView()
        setupStackView()
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupScrollView() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupStackView() {
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        // ViewModel의 tags 배열을 구독하여 UI 업데이트
        viewModel.tags
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] tags in
                self?.updateTags(tags)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateTags(_ tags: [String]) {
        // 기존 태그 제거
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // 새로운 태그 추가
        for (index, tag) in tags.enumerated() {
            let label = createTagLabel(with: tag, index: index)
            stackView.addArrangedSubview(label)
        }
    }
    
    private func createTagLabel(with text: String, index: Int) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.backgroundColor = .systemBlue
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        label.isUserInteractionEnabled = true // 터치 가능하도록 설정
        
        let padding: CGFloat = 16 // 태그 양쪽 패딩
        let width = label.intrinsicContentSize.width + padding
        let height: CGFloat = 32 // 태그 높이
        
        label.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(height)
        }
        
        // 터치 이벤트 처리
        let tapGesture = UITapGestureRecognizer()
        label.addGestureRecognizer(tapGesture)
        tapGesture.rx.event
            .map { _ in (index: index, label: label) } // 인덱스와 레이블 객체 방출
            .bind(to: viewModel.tagTappedRelay)
            .disposed(by: disposeBag)
        
        return label
    }
}
