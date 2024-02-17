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
    @IBOutlet weak var contentField: UITextField!
    
    let imagePicker = ImagePickerController()
    
    var categoryId: Int?
    var countryId: Int?
    var communityProfileId: Int?
    
    //이미지 등록
    var selectedImages: [UIImage] = []
    var selectedAssets: [PHAsset] = []
    var imageKeys: [String] = []
    
    override func viewDidLoad() {
        //임시
        communityProfileId = 1
        countryId = 1
        if let image = UIImage(named: "test.jpg") {
            // selectedImages 배열에 이미지 추가
            selectedImages.append(image)
        } else {
            print("이미지를 찾을 수 없습니다.")
        }
        
        //카테고리 메뉴
        category.setTitle("Category", for: .normal)
        let life = UIAction(title: "유학생활", handler: { _ in self.categorySelect(data: 1) })
        let prepare = UIAction(title: "유학준비", handler: { _ in self.categorySelect(data: 2) })
        let trade = UIAction(title: "중고거래", handler: { _ in self.categorySelect(data: 3) })
        let travel = UIAction(title: "여행", handler: { _ in self.categorySelect(data: 4) })
        let etc = UIAction(title: "기타", handler: { _ in self.categorySelect(data: 5) })
        let buttonMenu = UIMenu(title: "", children: [life,prepare,trade,travel,etc])
        category.menu = buttonMenu
        
        //제목
        titleField.borderStyle = .none
        let border = CALayer()
        border.frame = CGRect(x: 0, y: titleField.frame.size.height - 1, width: titleField.frame.width, height: 1)
        border.borderColor = UIColor.darkGray.cgColor
        border.borderWidth = 1.0 // 추가: 밑줄 두께
        titleField.layer.addSublayer(border)
        titleField.layer.masksToBounds = true
        
        tabBarController?.tabBar.isHidden = true
        super.viewDidLoad()
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
        guard let back = storyboard?.instantiateViewController(identifier: "tabC") as? TabBarController else{
            return
        }
        back.modalTransitionStyle = .crossDissolve
        back.modalPresentationStyle = .fullScreen
        present(back, animated: true, completion: nil)
    }
    //등록
    @IBAction func done(_ sender: Any) {
        guard let title = titleField.text, let categoryId = categoryId, let countryId = countryId, let communityProfileId = communityProfileId, let body = contentField.text else {
            // 필수 필드가 누락되었을 경우 에러 처리
            let alert = UIAlertController(title: "", message: "모든 필수 필드를 입력해주세요.", preferredStyle: UIAlertController.Style.alert)
            let confirm = UIAlertAction(title: "확인", style: .default, handler: nil)
            confirm.setValue(UIColor.black, forKey: "titleTextColor")
            alert.addAction(confirm)
            present(alert, animated: true, completion: nil)
            return
        }
        for image in selectedImages {
            let imageName = UUID().uuidString + ".jpg"
            imageKeys.append(imageName)
        }
        if imageKeys.last == "," {
            imageKeys.removeLast()
        }
        print(imageKeys)
        
        // 게시물 등록 요청 보내기
        let url = "http://ec2-3-34-112-205.ap-northeast-2.compute.amazonaws.com:8080/post/"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        let parameters: [String: Any] = [
            "title":title,
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
                multipartFormData.append(jsonData, withName: "post")
            } catch {
                print("Error converting parameters to JSON: \(error)")
            }
            
            if let imageKeys = parameters["sections"] as? [[String: Any]] {
                for section in imageKeys {
                    if let imageNames = section["imageKeys"] as? [String] {
                        for imageName in imageNames {
                            if let image = UIImage(named: imageName) {
                                if let imageData = image.jpegData(compressionQuality: 0.1) {
                                    multipartFormData.append(imageData, withName: "files", fileName: imageName, mimeType: "image/jpeg")
                                }
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
                let alert = UIAlertController(title: "", message: "게시글이 등록되었습니다.", preferredStyle: UIAlertController.Style.alert)
                let confirm = UIAlertAction(title: "확인", style: .default, handler: nil)
                confirm.setValue(UIColor.black, forKey: "titleTextColor")
                alert.addAction(confirm)
                self.present(alert, animated: true, completion: nil)
            case .failure(let error):
                // 실패한 경우 에러 메시지 표시
                let alert = UIAlertController(title: "", message: "게시글 등록에 실패했습니다. \(error.localizedDescription)", preferredStyle: UIAlertController.Style.alert)
                let confirm = UIAlertAction(title: "확인", style: .default, handler: nil)
                confirm.setValue(UIColor.black, forKey: "titleTextColor")
                alert.addAction(confirm)
                self.present(alert, animated: true, completion: nil)
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
                                              targetSize: CGSize(width: 200, height: 200),
                                              contentMode: .aspectFit,
                                              options: option) { (result, info) in
                        thumbnail = result!
                    }
                    
                    let data = thumbnail.jpegData(compressionQuality: 0.7)
                    let newImage = UIImage(data: data!)
                    
                    self.selectedImages.append(newImage! as UIImage)
                }
                print(self.selectedImages,self.selectedImages.count)
            }
        })
    }
    //MARK: - Post
    func post(){
        
    }
}
