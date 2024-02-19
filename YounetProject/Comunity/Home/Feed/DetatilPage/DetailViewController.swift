//
//  DetailViewController.swift
//  YounetProject
//
//  Created by 조혠 on 1/12/24.
//

import UIKit
import Alamofire

class DetailViewController: UIViewController {
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userName: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var storeButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    //API
    var detailData: [DetailModel] = []
    var commentData: [CommentModel] = []
    var postId: Int?
    var categoryId: Int?
    var date: String?
    var comunityProfileId: Int = 1 //로그인한 사용자의 ID
    var countryName: String?
    var commentId: Int?
    var body: String = "" //댓글
    
    //대댓글
    var t = true
    var num = 0
    var count = 0
    var i = 0
    var commentCount = 0
    
    @IBAction func sendComent(_ sender: Any) { 
        body = textField.text!
        textField.text = ""
        postComment()
    }
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
        
    }
    @IBAction func settingButton(_ sender: Any) {
        guard let postSetVC = storyboard?.instantiateViewController(identifier: "PostSetVC") as? PostSetViewController else{
            return
        }
        postSetVC.modalPresentationStyle = .fullScreen
        present(postSetVC, animated: true, completion: nil)
    }
    @IBAction func isHeart(_ sender: Any) {
        if heartButton.isSelected{
            heartButton.isSelected = false
            likeDelete()
        }else{
            heartButton.isSelected = true
            like()
        }
    }
    @IBAction func isStore(_ sender: Any) {
        if storeButton.isSelected{
            storeButton.isSelected = false
            storeDelete()
        }else{
            storeButton.isSelected = true
            store()
        }
    }
    override func viewDidLoad() {
        getData()
        registerXib()
        super.viewDidLoad()
    }
    //MARK: - API
    func getAPI(){
        if detailData.isEmpty && commentData.isEmpty {
            getData()
        } else {
            detailData.remove(at: 0)
            commentData.remove(at: 0)
            getData()
        }
    }
    func getData(){
        var finished1 = false
        var finished2 = false
        let url = "http://ec2-3-34-112-205.ap-northeast-2.compute.amazonaws.com:8080/post/\(postId!)"
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: DetailModel.self) { [self] response in
                switch response.result {
                case .success(let detail):
                    finished1 = true
                    self.detailData.append(detail)
                    self.collectionViewLoad()
                    if finished2{
                        self.loadData()
                    }
                case .failure(let error):
                    print("PostError: \(error)")
                }
            }
        let url2 = "http://ec2-3-34-112-205.ap-northeast-2.compute.amazonaws.com:8080/comment/post?postId=\(postId!)&pageNum=0&pageSize=5"
        AF.request(url2, method: .get)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: CommentModel.self) { [self] response in
                switch response.result {
                case .success(let comment):
                    finished2 = true
                    self.commentData.append(comment)
                    self.tableViewLoad()
                    if finished1{
                        self.loadData()                    }
                case .failure(let error):
                    print("CommentError: \(error)")
                }
            }
        
    }
    //댓글
    func postComment(){
        let url = "http://ec2-3-34-112-205.ap-northeast-2.compute.amazonaws.com:8080/comment"
        let parameters: [String: Any] = [
            "postId": postId!,
            "communityProfileId": comunityProfileId,
            "body": body
        ]
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success:                    
                    self.getAPI()
                case .failure(let error):
                    print("CommentFailed: \(error)")
                }
            }
    }
    //좋아요 추가
    func like(){
        let url = "http://ec2-3-34-112-205.ap-northeast-2.compute.amazonaws.com:8080/like/post"
        let parameters: [String: Any] = [
            "postId": postId!, // 좋아요를 누른 게시물의 ID
            "communityProfileId": 1 // 로그인한 사용자의 ID
        ]
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success:
                    self.getAPI()
                case .failure(let error):
                    print("likeFailed: \(error)")
                }
            }
    }
    //좋아요 취소
    func likeDelete(){
        let url = "http://ec2-3-34-112-205.ap-northeast-2.compute.amazonaws.com:8080/like/post"
        let parameters: [String: Any] = [
            "postId": postId!,
            "communityProfileId": 1
        ]
        AF.request(url, method: .delete, parameters: parameters, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success:
                    self.getAPI()
                case .failure(let error):
                    print("likeDeletFailed: \(error)")
                }
            }
    }
    //스크랩 등록
    func store(){
        let url = "http://ec2-3-34-112-205.ap-northeast-2.compute.amazonaws.com:8080/scrap/post"
        let parameters: [String: Any] = [
            "postId": postId!, // 스크랩 누른 게시물의 ID
            "communityProfileId": 1 // 로그인한 사용자의 ID
        ]
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success:
                    break
                case .failure(let error):
                    print("storeFailed: \(error)")
                }
            }
    }
    //스크랩 취소
    func storeDelete(){
        let url = "http://ec2-3-34-112-205.ap-northeast-2.compute.amazonaws.com:8080/scrap/post"
        let parameters: [String: Any] = [
            "postId": postId!,
            "communityProfileId": 1
        ]
        AF.request(url, method: .delete, parameters: parameters, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success:
                    break
                case .failure(let error):
                    print("storeDeletFailed: \(error)")
                }
            }
    }
    func loadData(){
        let detail = detailData[0]
        countryLabel.text = countryName
        titleLabel.text = detail.data.postTitle
        userName.setTitle(" \(detail.data.authorName)", for: .normal) //user image 필요
        if let firstComment = commentData.first,
            let content = firstComment.content,
            let firstContent = content.first,
            let replyList = firstContent.replyList {
            commentLabel.text = " \((content.count) + (replyList.count))"
        } else {
            commentLabel.text = "0"
        }

        likeLabel.text = " \(detail.data.likesCount)"
        textView.text = detail.data.sections.first?.body
        dateLabel.text = String(date?.prefix(10) ?? "")
        switch(categoryId!){
        case 1:
            categoryLabel.text = "유학생활"
            break
        case 2:
            categoryLabel.text = "유학준비"
            break
        case 3:
            categoryLabel.text = "중고거래"
            break
        case 4:
            categoryLabel.text = "여행"
            break
        default:
            categoryLabel.text = "기타"
            break
        }
    }
    //MARK: - view
    private func registerXib() {
        let nibName = UINib(nibName: "FeedDetailCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "FeedDetailCell")
        let nibName2 = UINib(nibName: "DetailImgCell", bundle: nil)
        collectionView.register(nibName2, forCellWithReuseIdentifier: "DetailImgCell")
        let nibName3 = UINib(nibName: "ReplyCell", bundle: nil)
        tableView.register(nibName3, forCellReuseIdentifier: "ReplyCell")
    }
    func tableViewLoad(){
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.reloadData()
    }
    func collectionViewLoad(){
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension DetailViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let firstComment = commentData.first else {
                return 0
            }

            let commentCount = firstComment.content?.count ?? 0
            let replyCount = firstComment.content?.first?.replyList?.count ?? 0

            return commentCount + replyCount
    }
    
    //셀 종류
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        commentCount = commentData[0].content!.count
            let comment = commentData[0].content![num]
            let replyCount = comment.replyList!.count
            if t{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedDetailCell", for: indexPath) as? FeedDetailCell else{return UITableViewCell()}
                cell.userName.setTitle(" \((comment.authorName)!)", for: .normal)
                cell.dateLabel.text = String(comment.createdAt?.prefix(10) ?? "")
                cell.commentLabel.text = comment.body
                count = replyCount
                i = 0
                if count != 0{
                    t = false
                }else if ((num+1) < commentData[0].content!.count + (commentData[0].content?.first?.replyList!.count)!) && (num+1) < commentCount{
                        num += 1
                }
                return cell
            }else{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReplyCell", for: indexPath) as? ReplyCell else{return UITableViewCell()}
                cell.userName.setTitle(" \((comment.replyList![i].authorName)!)", for: .normal)
                cell.dateLabel.text = comment.createdAt
                cell.commentLabel.text = comment.replyList![i].body
                count -= 1
                i += 1
                if count == 0{
                    t = true
                    if ((num+1) < commentData[0].content!.count + (commentData[0].content?.first?.replyList!.count)!) && (num+1) < commentCount{
                        num += 1
                    }
                }
                return cell
            }
         }
    //테이블뷰 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92
    }
}

extension DetailViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (detailData[0].data.sections.first?.images.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailImgCell", for: indexPath) as? DetailImgCell else{return UICollectionViewCell()}
        let detail = detailData[0]
        if let imageUrlString = detail.data.sections.first?.images[indexPath.item].imageUrl,
           let imageUrl = URL(string: imageUrlString) {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: imageUrl),
                   let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        cell.imageView.image = image
                    }
                }
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.height)
    }
}

