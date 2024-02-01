//
//  MyChallengeFeedCollectionView.swift
//  beilsang
//
//  Created by 강희진 on 1/22/24.
//

import UIKit
class MyChallengeFeedCollectionViewCell: UICollectionViewCell{
    
    static let identifier = "myChallengeFeedCollectionViewCell"
    
    lazy var challengeFeed: UIButton = {
        let feedButton = UIButton()
        feedButton.setImage(UIImage(named: "Mask group"), for: .normal)
        feedButton.layer.borderWidth = 1
        feedButton.layer.borderColor = UIColor.beBorderDis.cgColor
        feedButton.layer.cornerRadius = 10
        feedButton.backgroundColor = .white
        feedButton.contentMode = .scaleAspectFill
        feedButton.clipsToBounds = true
        return feedButton
    }()
    override init(frame: CGRect){
        super.init(frame: frame)
        setupAttribute()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAttribute() {
        self.addSubview(challengeFeed)
    }
    private func setConstraint() {
        challengeFeed.translatesAutoresizingMaskIntoConstraints = false
        challengeFeed.snp.makeConstraints({ make in
            make.size.edges.equalToSuperview()
//            make.width.equalTo(173)
//            make.height.equalTo(140)
        })
    }
}
