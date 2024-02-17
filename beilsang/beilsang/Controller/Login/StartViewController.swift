//
//  StartViewController.swift
//  beilsang
//
//  Created by Seyoung on 1/23/24.
//

import UIKit
import SnapKit

class StartViewController: UIViewController {
    
    //MARK: - Properties
    
    var attributedStr: NSMutableAttributedString!
    
    lazy var characterImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "welcomeImage")
        view.sizeToFit()
        view.layer.shadowColor = UIColor.beTextDef.cgColor
        view.layer.masksToBounds = false
        
        return view
    }()
    
    lazy var startLabel: UILabel = {
        let view = UILabel()
        view.text = "당신의 친환경 활동이\nBe 일상이 되도록 응원할게요!"
        view.font = UIFont(name: "NotoSansKR-SemiBold", size: 20)
        view.numberOfLines = 2
        view.textColor = .beTextDef
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .center
        
        return view
    }()
    
    lazy var bubbleLabel: UILabel = {
        let view = UILabel()
        view.text = "🌱 가입 축하 +1000P 받고 시작하기!"
        view.font = UIFont(name: "NotoSansKR-Medium", size: 12)
        view.numberOfLines = 0
        view.textColor = .beTextDef
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .left
        
        return view
    }()
    
    lazy var bubbleView : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "bubble")
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.16
        view.layer.shadowRadius = 4
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowPath = nil
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var nextButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .beScPurple600
        view.setTitle("비일상 시작하기", for: .normal)
        view.setTitleColor(.beTextWhite, for: .normal)
        view.titleLabel?.font = UIFont(name: "NotoSansKR-Medium", size: 16)
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(nextAction), for: .touchDown)
        return view
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAttributedStr()
        setupUI()
        setupLayout()
        
    }
    
    //MARK: - UI Setup
    
    private func setupUI() {
        navigationBarHidden()
        view.backgroundColor = .beBgDef
        view.addSubview(characterImage)
        view.addSubview(startLabel)
        view.addSubview(bubbleView)
        view.addSubview(nextButton)
        
        bubbleView.addSubview(bubbleLabel)
    }
    
    private func setupLayout() {
        characterImage.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(140)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        startLabel.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(characterImage.snp.bottom).offset(24)
        }
        
        bubbleView.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(nextButton.snp.top).offset(-12)
            make.height.equalTo(44)
        }
        
        bubbleLabel.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints{ make in
            make.bottom.equalToSuperview().offset(-100)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(56)
        }
    }
    
    // MARK: - Navigation Bar
    
    private func navigationBarHidden() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    //MARK: - setupAttributeStr
    
    func setupAttributedStr() {
        attributedStr = NSMutableAttributedString(string: bubbleLabel.text!)
        
        attributedStr.addAttribute(.foregroundColor, value: UIColor.beCta , range: (bubbleLabel.text! as NSString).range(of: "1000P"))
        
        bubbleLabel.attributedText = attributedStr
    }
    
    // MARK: - Actions
    
    
    @objc func nextAction
    (_ sender: UIButton) {
        SignUpToServer()
    }
}

extension StartViewController {
    func SignUpToServer() {
        // SignUpService를 사용하여 서버에 Post
        let accessToken = UserDefaults.standard.string(forKey: UserDefaultsKey.serverToken)
        let refreshToken = UserDefaults.standard.string(forKey: UserDefaultsKey.refreshToken)
        
        SignUpService.shared.signUp(accessToken: accessToken! , gender: SignUpData.shared.gender, nickName: SignUpData.shared.nickName, birth: SignUpData.shared.birth, address: SignUpData.shared.address, keyword: SignUpData.shared.keyword, discoveredPath: SignUpData.shared.discoveredPath, resolution: SignUpData.shared.resolution, recommendNickname: SignUpData.shared.recommendNickname){ result in
            switch result {
            case .success(let data):
                // 서버에서 받은 데이터 처리
                guard let data = data as? SignUpResponse else { return }
                print("signup to server success with data: \(data)")
                UserDefaults.standard.set(true, forKey: UserDefaultsKey.existMember)
                
                let homeVC = HomeMainViewController()
                if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                    sceneDelegate.changeRootViewController(homeVC)
                }
            case .tokenExpired :
                TokenManager.shared.refreshToken(accessToken: accessToken!, refreshToken: refreshToken!) { _ in }
            case .networkFail:
                // 서버 통신 실패 처리
                print("네트워크 페일")
            case .requestErr(let error):
                print("요청 페일 \(error)")
            case .pathErr:
                print("경로 오류")
            case .serverErr:
                print("서버 오류")
            }
        }
    }
}
