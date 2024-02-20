//
//  IdentificationVC.swift
//  YounetProject
//
//  Created by 김제훈 on 2/14/24.
//

import UIKit
import Photos
import PhotosUI

class IdentificationVC: UIViewController
{
    // 본교
    @IBOutlet var mainSchoolCustomTextField: DefaultUnderlineTextField!
    
    // 파견 국가 검색
    @IBOutlet var dispatchNationSearchBtn: UIButton!
    @IBOutlet var dispatchSearchIconImage: UIImageView!
    @IBOutlet var dispatchResultView: UIView!
    @IBOutlet var dispatchResultTitleImage: UIImageView!
    @IBOutlet var dispatchResultTitleLabel: UILabel!
    
    // 파견교
    @IBOutlet var dispatchSchoolCustomTextField: DefaultUnderlineTextField!
    
    // 인증 서류 제출
    @IBOutlet var certificationDocsSubmitBtn: UIButton!
    @IBOutlet var docsResultView: UIView!
    @IBOutlet var docsResultTitleLabel: UILabel!
    
    //
    @IBOutlet var registerBtn: UIButton!
    
    // 선택된 국가
    var countryInfo: CountryDTO? = nil
    
    var mainSchoolIsValid: Bool = false
    var dispatchNationIsValid: Bool = false
    var dispatchSchoolIsValid: Bool = false
    var docsIsValid: Bool = false
    
    let enableColor = UIColor(named: "MainThemeColor")
    let notEnableColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1)
    
    var selectedImageInfo : (name: String, image: UIImage)? = nil {
        didSet {
            print(#fileID, #function, #line, "- selectedImageInfo: \(selectedImageInfo?.name), \(selectedImageInfo?.image)")
            
            
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.docsResultTitleLabel.text = self.selectedImageInfo?.name ?? ""
                if self.docsResultView.isHidden {
                    self.docsResultView.isHidden = false
                    self.docsIsValid = true
                    self.checkRegisterIsAvailable()
                }
            }
            
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.config()
        setKeyboard()
    }
    
    private func config()
    {
        // leftBarBtn
        let leftBtn = UIButton(frame: CGRectMake(0, 0, 15, 22))
        leftBtn.setImage(UIImage(named: "vector-left"), for: .normal)
        leftBtn.addTarget(self, action: #selector(leftBarBtnClicked(_:)), for: .touchUpInside)
        
        let leftBarBtnItem: UIBarButtonItem = UIBarButtonItem(customView: leftBtn)
        self.navigationItem.setLeftBarButton(leftBarBtnItem, animated: true)
        
        self.registerBtn.backgroundColor = notEnableColor
        
        self.mainSchoolCustomTextField.setAction(self, action: #selector(mainSchoolTextFieldChanged(_:)), for: .editingChanged)
        self.dispatchNationSearchBtn.addTarget(self, action: #selector(dispatchNationSearchBtnClicked(_:)), for: .touchUpInside)
        self.dispatchSchoolCustomTextField.setAction(self, action: #selector(dispatchSchoolTextFieldChanged(_:)), for: .editingChanged)
        self.certificationDocsSubmitBtn.addTarget(self, action: #selector(certificationDocsSubmitBtnClicked(_:)), for: .touchUpInside)
        self.registerBtn.addTarget(self, action: #selector(registerBtnClicked(_:)), for: .touchUpInside)
    }
    
    private func getRegisterInfo() -> RegisterInfo? {
        
        
        
        guard let mainSchool = mainSchoolCustomTextField.inputTextField.text,
              let hostCountry = countryInfo?.korName,
              let hostSchool = dispatchSchoolCustomTextField.inputTextField.text,
              let file = selectedImageInfo?.image
        else { return nil}
        
        let resizedImg = file.scalePreservingAspectRatio(targetSize: CGSize(width: 50, height: 50))
        
        return RegisterInfo(mainSchool: mainSchool, hostCountry: hostCountry, hostSchool: hostSchool, file: resizedImg)
    }
    private func checkRegisterIsAvailable()
    {
        let isAvailable = self.mainSchoolIsValid && self.dispatchNationIsValid && self.dispatchSchoolIsValid && self.docsIsValid
        
        if (isAvailable)
        {
            self.registerBtn.backgroundColor = enableColor
        }
        else
        {
            self.registerBtn.backgroundColor = notEnableColor
        }
        self.registerBtn.isEnabled = isAvailable
    }
    
    @objc private func leftBarBtnClicked(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func mainSchoolTextFieldChanged(_ sender: UITextField)
    {
        mainSchoolIsValid = mainSchoolCustomTextField.getCount() > 0
        checkRegisterIsAvailable()
    }
    
    @objc private func dispatchNationSearchBtnClicked(_ sender: UIButton)
    {
        let nationSelectionVC = NationSelectionVC.present(parent: self, selectedCountry: countryInfo)
        nationSelectionVC.onDismissed = { [weak self] () in
            if let countryInfo = nationSelectionVC.selectedCountry
            {
                self?.countryInfo = countryInfo
                
                if (self?.dispatchResultView.isHidden == true)
                {
                    self?.dispatchResultView.isHidden = false
                    self?.dispatchSearchIconImage.isHidden = true
                }
                
                self?.dispatchResultTitleImage.image = UIImage(named: countryInfo.engName)
                self?.dispatchResultTitleLabel.text = countryInfo.korName
                self?.dispatchNationIsValid = true
            }
            else
            {
                self?.dispatchNationIsValid = false
            }
            self?.checkRegisterIsAvailable()
        }
    }
    
    @objc private func dispatchSchoolTextFieldChanged(_ sender: UITextField)
    {
        dispatchSchoolIsValid = dispatchSchoolCustomTextField.getCount() > 0
        checkRegisterIsAvailable()
    }
    
    @objc private func certificationDocsSubmitBtnClicked(_ sender: UIButton)
    {
        // 파일 추가하는 방법
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        
        // Set the filter type according to the user’s selection.
        configuration.filter = .images
        // Set the mode to avoid transcoding, if possible, if your app supports arbitrary image/video encodings.
        configuration.preferredAssetRepresentationMode = .current
        // Set the selection behavior to respect the user’s selection order.
        configuration.selection = .ordered
        // Set the selection limit to enable multiselection.
        configuration.selectionLimit = 1
        // Set the preselected asset identifiers with the identifiers that the app tracks.
        //        configuration.preselectedAssetIdentifiers = selectedAssetIdentifiers
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc private func registerBtnClicked(_ sender: UIButton)
    {
        let defaultPopup = DefaultPopup.present(parent: self, contentStr: "파일이 정상적으로 제출되었습니다.\n인증 확인까지\n최대 24시간이 소요될 수 있습니다.", btnTitleStr: "확인")
        defaultPopup.onDismissed = { [weak self] () in
            //            self?.navigationController?.popViewController(animated: true)
        }
        
        guard let info = getRegisterInfo() else { return }
        
        APIService.shared.sendIdentificationInfo(registerInfo: info, completion: { response in
            
            //            self?.navigationController?.popViewController(animated: true)
        })
    }
}

extension IdentificationVC : PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        print(#fileID, #function, #line, "- results: \(results)")
        
        
        
        guard let phPickerResult = results.first else { return }
        
        //        phPickerResult.assetIdentifier
        
        let itemProvider = phPickerResult.itemProvider
        
        let progress: Progress?
        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            progress = itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { [weak self] object, err in
                guard let self = self else { return }
                
                guard let img : UIImage = object as? UIImage else {
                    return
                }
                
                let imgName = itemProvider.suggestedName ?? ""
                
                self.selectedImageInfo = (name: imgName, image: img)
                DispatchQueue.main.async { [weak self] in
                    picker.dismiss(animated: true)
                }
            })
        }
        
    }
}

struct RegisterInfo {
    var mainSchool: String
    var hostCountry: String
    var hostSchool: String
    var file: UIImage
}

extension UIImage {
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )
        
        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )
        
        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        return scaledImage
    }
}
