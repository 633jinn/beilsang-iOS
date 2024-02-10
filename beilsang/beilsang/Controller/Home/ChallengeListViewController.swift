//
//  ChallengeListViewController.swift
//  beilsang
//
//  Created by 곽은채 on 1/26/24.
//

import SnapKit
import UIKit

// [홈] 챌린지 리스트
// 홈 메인 화면에서 카테고리를 누른 경우
class ChallengeListViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - properties
    // 전체 화면 scrollview
    let fullScrollView = UIScrollView()
    let fullContentView = UIView()
    
    // topview - navigation
    lazy var navigationButton: UIBarButtonItem = {
        let view = UIBarButtonItem(image: UIImage(named: "icon-navigation"), style: .plain, target: self, action: #selector(tabBarButtonTapped))
        view.tintColor = .beIconDef
        
        return view
    }()
    
    // topview - 레이블
    var categoryLabelText: String?
    lazy var categoryLabel: UILabel = {
        let view = UILabel()
        
        view.text = categoryLabelText
        view.font = UIFont(name: "NotoSansKR-Medium", size: 20)
        view.textColor = .beTextDef
        view.textAlignment = .center
        
        return view
    }()
    
    // 네비게이션 오른쪽 버튼 두 개
    lazy var topRightView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    // topview - plus
    lazy var plusButton: UIButton = {
        let view = UIButton()
        
        view.setImage(UIImage(named: "icon_plus"), for: .normal)
        view.addTarget(self, action: #selector(plusButtonClicked), for: .touchUpInside)
        view.tintColor = .beIconDef
        
        return view
    }()
    
    // topview - search
    lazy var searchButton: UIButton = {
        let view = UIButton()
        
        view.setImage(UIImage(named: "icon-search"), for: .normal)
        view.addTarget(self, action: #selector(searchButtonClicked), for: .touchUpInside)
        view.tintColor = .beIconDef
        
        return view
    }()
    
    // topview - border
    lazy var topViewBorder: UIView = {
        let view = UIView()
        
        view.backgroundColor = .beBorderDis
        
        return view
    }()
    
    // 챌린지 진행 view
    lazy var challengeProgress: UIView = {
        let view = UIView()
        
        view.backgroundColor = .beScPurple400
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.bePrPurple500.cgColor
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    // 챌린지 진행 view - label
    lazy var progressTitleLabel: UILabel = {
        let view = UILabel()
        
        view.text = "\(categoryLabelText ?? "전체") 챌린지는\n이렇게 진행돼요"
        view.numberOfLines = 2
        view.textAlignment = .left
        view.textColor = .beTextDef
        view.font = UIFont(name: "NotoSansKR-Medium", size: 14)
        
        return view
    }()
    
    // 챌린지 진행 view - image
    lazy var progressCharacterImage: UIImageView = {
        let view = UIImageView()
        
        view.image = UIImage(named: "bHalf")
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    // 챌린지 리스트 콜렉션 뷰
    lazy var challengeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupAttribute()
        setCollectionView()
    }
    
    // MARK: - actions
    // 네비게이션 아이템 누르면 뒤(홈 메인화면)으로 가기
    @objc func tabBarButtonTapped() {
        print("뒤로 가기")
        let homeVC = HomeMainViewController()
        navigationController?.pushViewController(homeVC, animated: true)
    }
    
    @objc func plusButtonClicked() {
        print("플러스 버튼")
        let registerChallengeVC = RegisterFirstViewController()
        navigationController?.pushViewController(registerChallengeVC, animated: true)
    }
    
    @objc func searchButtonClicked() {
        print("검색")
    }
}

// MARK: - Layout
extension ChallengeListViewController {
    
    func setupAttribute() {
        setFullScrollView()
        setAddViews()
        setLayout()
        setNavigationBar()
    }
    
    func setFullScrollView() {
        fullScrollView.showsVerticalScrollIndicator = true
        fullScrollView.delegate = self
    }
    
    func setNavigationBar() {
        let rightBarButtons = UIBarButtonItem(customView: topRightView)
        navigationItem.titleView = categoryLabel
        navigationItem.leftBarButtonItem = navigationButton
        navigationItem.rightBarButtonItem = rightBarButtons
    }
    
    func setAddViews() {
        [plusButton, searchButton].forEach { view in
            topRightView.addSubview(view)
        }
        
        view.addSubview(fullScrollView)
        
        fullScrollView.addSubview(fullContentView)
        
        [topViewBorder, challengeProgress, challengeCollectionView].forEach { view in
            fullContentView.addSubview(view)
        }
        
        [progressTitleLabel, progressCharacterImage].forEach { view in
            challengeProgress.addSubview(view)
        }
    }
    
    func setLayout() {
        topRightView.snp.makeConstraints { make in
            make.width.equalTo(64)
            make.height.equalTo(24)
        }
        
        plusButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        searchButton.snp.makeConstraints { make in
            make.leading.equalTo(plusButton.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        fullScrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.leading.trailing.equalToSuperview()
        }
        
        fullContentView.snp.makeConstraints { make in
            make.edges.equalTo(fullScrollView.contentLayoutGuide)
            make.width.equalTo(fullScrollView.frameLayoutGuide)
            make.height.equalTo(1000)
        }
        
        topViewBorder.snp.makeConstraints { make in
            make.top.equalTo(fullScrollView.snp.top)
            make.width.equalTo(fullScrollView.snp.width)
            make.height.equalTo(1)
        }
        
        challengeProgress.snp.makeConstraints { make in
            make.top.equalTo(topViewBorder.snp.bottom).offset(17)
            make.leading.equalTo(fullScrollView.snp.leading).offset(16)
            make.trailing.equalTo(fullScrollView.snp.trailing).offset(-16)
            make.height.equalTo(100)
        }
        
        challengeCollectionView.snp.makeConstraints { make in
            make.top.equalTo(challengeProgress.snp.bottom).offset(24)
            make.leading.equalTo(fullScrollView.snp.leading)
            make.trailing.equalTo(fullScrollView.snp.trailing)
            make.bottom.equalTo(fullScrollView.snp.bottom)
        }
        
        progressTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(challengeProgress.snp.top).offset(12)
            make.leading.equalTo(challengeProgress.snp.leading).offset(16)
        }
        
        progressCharacterImage.snp.makeConstraints { make in
            make.top.equalTo(challengeProgress.snp.top).offset(28)
            make.trailing.equalTo(challengeProgress.snp.trailing).offset(-17)
        }
    }
}

// MARK: - collectionView setting(챌린지 리스트)
extension ChallengeListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // 콜렉션뷰 세팅
    func setCollectionView() {
        challengeCollectionView.delegate = self
        challengeCollectionView.dataSource = self
        challengeCollectionView.register(ChallengeListCollectionViewCell.self, forCellWithReuseIdentifier: ChallengeListCollectionViewCell.identifier)
    }
    
    // 셀 개수 설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    // 셀 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChallengeListCollectionViewCell.identifier, for: indexPath) as?
                ChallengeListCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        return cell
    }
    
    // 셀 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width - 32
        
        return CGSize(width: width , height: 140)
    }
}
