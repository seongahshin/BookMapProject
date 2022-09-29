//
//  SettingViewController.swift
//  BookMapProject
//
//  Created by 신승아 on 2022/09/20.
//

import UIKit
import MessageUI

import SnapKit

class SettingViewController: UIViewController {
    
    let settingcellTitle: [String] = ["문의하기 및 피드백 보내기", "독립서점 제보하기"]
    
    var tableView: UITableView = {
        let view = UITableView()
        view.isScrollEnabled = false
        return view
    }()
    
    
    override func viewDidLoad() {
        view.backgroundColor = backgroundColor
        self.navigationItem.title = "설정"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        configureUI()
    }
    
    func configureUI() {
        [tableView].forEach {
            view.addSubview($0)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as! SettingTableViewCell
        print(settingcellTitle)
        cell.titleLabel.text = settingcellTitle[indexPath.row]
        cell.titleLabel.font = UIFont(name: FontManager.GangWonBold, size: 14)
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            let title = "[북트립] 문의하기 및 피드백"
            let content = ""
            checkEmail(mailTitle: title, mailContent: content)
        
        case 1:
            let title = "[북트립] 독립서점 제보하기 - (제보하는 독립서점 or 지역명을 괄호 안에 적어주세요)"
            let content = """
            
            북트립에 추가되었으면 하는 독립서점이나 나만 알기 아까운 독립서점이 있다면 제보해주세요!
            추가되었으면 하는 지역에 대한 제보도 환영합니다:) 제보는 추후에 있을 업데이트에 반영하도록 하겠습니다 🥰
            
            < 양식 >
            1. 추가되었으면 하는 지역 (선택) :
            2. 추천하고 싶은 독립서점의 이름:
            3. 해당 독립서점의 상세 주소:
            4. 해당 독립서점을 추천하는 이유: (간단히 적어주셔도 됩니다 🥰)
            """
            checkEmail(mailTitle: title, mailContent: content)
        default:
            print(1)
        }
    }
    
    
}

extension SettingViewController: MFMailComposeViewControllerDelegate {
    
    func checkEmail(mailTitle: String, mailContent: String) {
        if MFMailComposeViewController.canSendMail() {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            
            composeVC.setToRecipients(["booktrip09@gmail.com"])
            composeVC.setSubject(mailTitle)
            composeVC.setMessageBody(mailContent, isHTML: false)
            self.present(composeVC, animated: true)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "메일을 전송 실패", message: "아이폰 이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) {
            (action) in
            print("확인")
        }
        sendMailErrorAlert.addAction(confirmAction)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
