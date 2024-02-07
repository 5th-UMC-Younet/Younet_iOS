//
//  ReportViewController.swift
//  YounetProject
//
//  Created by 김세아 on 2/6/24.
//

import UIKit

class ReportViewController: UIViewController {

    @IBOutlet weak var firstReportButton: UIButton!
    @IBOutlet weak var secondReportButton: UIButton!
    @IBOutlet weak var thirdReportButton: UIButton!
    @IBOutlet weak var fourthReportButton: UIButton!
    @IBOutlet weak var fifthReportButton: UIButton!
        
    @IBOutlet weak var fileNameButton: UIButton!
    
    var BtnArray = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designSet()
    }
    
    private func designSet() {
        BtnArray.append(firstReportButton)
        BtnArray.append(secondReportButton)
        BtnArray.append(thirdReportButton)
        BtnArray.append(fourthReportButton)
        BtnArray.append(fifthReportButton)
        
        fileNameButton.isHidden = true
    }
    
    @IBAction func reportButtonDidtap(_ sender: UIButton) {
        for Btn in BtnArray {
            if Btn == sender {
                // 만약 현재 버튼이 이 함수를 호출한 버튼이라면
                Btn.isSelected = true
            } else {
                // 이 함수를 호출한 버튼이 아니라면
                Btn.isSelected = false
            }
        }
    }
    
    @IBAction func fileSendButtonDidtap(_ sender: UIButton) {
        // 전송에 성공했을 때
        // 받아온 파일명으로 title 설정
        //fileNameButton.setTitle("", for: .normal)
        fileNameButton.isHidden = false
    }
    
    @IBAction func backButtonDidtap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
    


