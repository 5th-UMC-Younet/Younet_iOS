//
//  PostViewController.swift
//  YounetProject
//
//  Created by 조혠 on 1/9/24.
//

import UIKit
import Alamofire
import BSImagePicker
import Photos

class PostViewController: UIViewController {
    @IBOutlet weak var category: UIButton!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var contentField: UITextView!
    
    let imagePicker = ImagePickerController()
    let textViewSample = "내용을 입력하세요"
    
    var categoryId: Int?
    var countryId: Int?
    var communityProfileId: Int?
    
    //이미지 등록
    var selectedImages: [UIImage] = []
    var selectedAssets: [PHAsset] = []
    var imageKeys: [String] = []
    
    override func viewDidLoad() {
        //카테고리 메뉴
        let life = UIAction(title: "유학생활", handler: { _ in self.categorySelect(data: 1) })
        let prepare = UIAction(title: "유학준비", handler: { _ in self.categorySelect(data: 2) })
        let trade = UIAction(title: "중고거래", handler: { _ in self.categorySelect(data: 3) })
        let travel = UIAction(title: "여행", handler: { _ in self.categorySelect(data: 4) })
        let etc = UIAction(title: "기타", handler: { _ in self.categorySelect(data: 5) })
        let buttonMenu = UIMenu(title: "", children: [life,prepare,trade,travel,etc])
        category.menu = buttonMenu
        
        setKeyboard()
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        contentField.text = ""
        titleField.text = ""
        setTextViewPlaceholder()
        contentField.delegate = self
        
        //이미지 등록
        selectedImages = []
        selectedAssets = []
        imageKeys = []
        
        //optional binding으로 userId 가져오기: From MyPageViewController
        let userIdInt: Int? = UserDefaults.standard.integer(forKey: "myUserId")
        if let userId = userIdInt {
            communityProfileId = userId
        } else {
            communityProfileId = 1
        }
        
        //optional binding으로 countryId 가져오기: From MenuSelectionVC
        let countryIdInt: Int? = UserDefaults.standard.integer(forKey: "countryId")
        if let contId = countryIdInt {
            countryId = contId
        } else {
            countryId = 0
        }
        
        tabBarController?.tabBar.isHidden = true
    }
    override func viewWillLayoutSubviews() {
        //제목 아래 밑줄
        titleField.borderStyle = .none
        let border = CALayer()
        border.frame = CGRect(x: 0, y: titleField.frame.size.height - 0.5, width: titleField.frame.width, height: 1)
        border.borderColor = UIColor.lightGray.cgColor
        border.borderWidth = 1.0 // 추가: 밑줄 두께
        titleField.layer.addSublayer(border)
        titleField.layer.masksToBounds = true
    }
    
    //카테고리
    func categorySelect(data: Int){
        switch data{
        case 1:
            category.setTitle("유학생활", for: .normal)
            categoryId = 1
            break
        case 2:
            category.setTitle("유학준비", for: .normal)
            categoryId = 2
            break
        case 3:
            category.setTitle("중고거래", for: .normal)
            categoryId = 3
            break
        case 4:
            category.setTitle("여행", for: .normal)
            categoryId = 4
            break
        case 5:
            category.setTitle("기타", for: .normal)
            categoryId = 5
            break
        default:
            break
        }
        
    }
    
    //취소
    @IBAction func backButton(_ sender: Any) {
        tabBarController?.selectedIndex = 3
        tabBarController?.tabBar.isHidden = false
    }
    //등록
    @IBAction func done(_ sender: Any) {
        guard let title = titleField.text, let categoryId = categoryId, let countryId = countryId, let communityProfileId = communityProfileId, let body = contentField.text else {
            // 필수 필드가 누락되었을 경우 에러 처리
            let alert = PopupViewController.present(parent: self)
            alert.labelText = "\n모든 필수 필드를 입력해주세요.\n"
            alert.buttonText = "확인"
            
            return
        }
        for _ in selectedImages {
            let imageName = UUID().uuidString + ".jpeg"
            imageKeys.append(imageName)
        }
        print(imageKeys)
        
        // 게시물 등록 요청 보내기
        let url = "http://ec2-3-34-112-205.ap-northeast-2.compute.amazonaws.com:8080/post/"
        let headers: HTTPHeaders = [
            "Content-Type": "multipart/form-data"
        ]
        let parameters: [String: Any] = [
            "title": title,
            "communityProfileId": communityProfileId,
            "countryId": countryId,
            "categoryId": categoryId,
            "sections": [
                [
                    "body": body,
                    "imageKeys": imageKeys
                ]
            ]
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: parameters)
                multipartFormData.append(jsonData, withName: "post", mimeType: "application/json")
                print(parameters)
            } catch {
                print("Error converting parameters to JSON: \(error)")
            }
            
            if let imageKeys = parameters["sections"] as? [[String: Any]] {
                for section in imageKeys {
                    if let imageNames = section["imageKeys"] as? [String] {
                        for index in 0..<imageNames.count {
                            let imageName = imageNames[index]
                            let image = self.selectedImages[index]
                            
                            if let imageData = image.jpegData(compressionQuality: 1.0) {
                                multipartFormData.append(imageData, withName: "files", fileName: imageName, mimeType: "image/jpeg")
                            }
                        }
                    }
                }
            }
        }, to: url, method: .post, headers: headers)
        .response { response in
            debugPrint(response)
            switch response.result {
            case .success:
                // 성공적으로 등록되었을 경우 알림 표시
                let alert = PopupViewController.present(parent: self)
                alert.labelText = "\n게시글이 등록되었습니다.\n"
                alert.buttonText = "확인"
                alert.onDismissed = {
                    self.tabBarController?.selectedIndex = 0
                    self.tabBarController?.tabBar.isHidden = false
                }
            case .failure(let error):
                // 실패한 경우 에러 메시지 표시
                print("PostError: \(error)")
                let alert = PopupViewController.present(parent: self)
                alert.labelText = "\n게시글 등록에 실패했습니다.\n"
                alert.buttonText = "확인"
                alert.onDismissed = {}
                
            }
        }
    }
    
    //사진
    @IBAction func goAlbum(_ sender: Any) {
        selectedAssets = []
        
        //사진 등록 추가
        let imagePicker = ImagePickerController()
        imagePicker.settings.selection.max = 5
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
        
        
        self.presentImagePicker(imagePicker, select: { (asset) in
            if !self.selectedAssets.contains(asset) {
                self.selectedAssets.append(asset)
                // User selected an asset. Do something with it. Perhaps begin processing/upload?
            }
            
            // User selected an asset. Do something with it. Perhaps begin processing/upload?
            
        }, deselect: { (asset) in
            if let index = self.selectedAssets.firstIndex(of: asset) {
                self.selectedAssets.remove(at: index)
            }
            // User deselected an asset. Cancel whatever you did when asset was selected.
            
        }, cancel: { (assets) in
            // User canceled selection.
            
        }, finish: { (assets) in
            // User finished selection assets.
            if self.selectedAssets.count != 0 {
                
                for i in 0..<self.selectedAssets.count {
                    
                    let imageManager = PHImageManager.default()
                    let option = PHImageRequestOptions()
                    option.isSynchronous = true
                    var thumbnail = UIImage()
                    
                    imageManager.requestImage(for: self.selectedAssets[i],
                                              targetSize: CGSize(width: 500, height: 500),
                                              contentMode: .aspectFit,
                                              options: option) { (result, info) in
                        thumbnail = result!
                    }
                    
                    let data = thumbnail.jpegData(compressionQuality: 1)
                    let newImage = UIImage(data: data!)
                    
                    self.selectedImages.append(newImage! as UIImage)
                    print(self.selectedImages)
                }
                print(self.selectedImages,self.selectedImages.count)
            }
        })
    }
    //MARK: - Post
    func post(){
        
    }
    
    // textView PlaceHolder
    private func setTextViewPlaceholder() {
        if contentField.text == "" {
            contentField.text = textViewSample
            contentField.textColor = #colorLiteral(red: 0.7725487351, green: 0.7725491524, blue: 0.7803917527, alpha: 1)
        } else if contentField.text == textViewSample {
            contentField.text = ""
            contentField.textColor = UIColor.black
        }
    }
}

extension UIApplication {
    /*function will return reference to tabbarcontroller */
    func tabbarController() -> UIViewController? {
        guard let vcs = self.keyWindow?.rootViewController?.children else { return nil }
        for vc in vcs {
            if  let _ = vc as? CustomTabBarViewController {
                return vc
            }
        }
        return nil
    }
}

extension PostViewController : UITextViewDelegate{
    // textView 편집 시작
    func textViewDidBeginEditing(_ textView: UITextView) {
        setTextViewPlaceholder()
    }
    // textView 편집 끝
    func textViewDidEndEditing(_ textView: UITextView) {
        setTextViewPlaceholder()
    }
}
