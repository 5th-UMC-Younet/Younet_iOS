//
//  HomeViewController.swift
//  YounetProject
//
//  Created by 조혠 on 1/9/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortButton: UIButton! //정렬버튼
    //카테고리
    @IBOutlet var category: [UIButton]!
    var index: Int?
    //국가 선택
    @IBOutlet weak var countryName: UIButton!
    @IBOutlet weak var engCountryName: UILabel!
    @IBOutlet weak var countryImg: UIImageView!
    
    
    let countries: [Country] = [
        Country(name: "네덜란드", engName: "NETHERLANDS", img: "🇳🇱"),
        Country(name: "덴마크", engName: "DENMARK", img: "🇩🇰"),
        Country(name: "독일", engName: "GERMANY", img: "🇩🇪"),
        Country(name: "멕시코", engName: "MEXICO", img: "🇲🇽"),
        Country(name: "미국", engName: "UNITED STATES", img: "🇺🇸"),
        Country(name: "벨기에", engName: "BELGIUM", img: "🇧🇪"),
        Country(name: "브라질", engName: "BRAZIL", img: "🇧🇷"),
        Country(name: "스웨덴", engName: "SWEDEN", img: "🇸🇪"),
        Country(name: "스위스", engName: "SWITZERLAND", img: "🇨🇭"),
        Country(name: "스페인", engName: "SPAIN", img: "🇪🇸"),
        Country(name: "영국", engName: "UNITED KINGDOM", img: "🇬🇧"),
        Country(name: "오스트리아", engName: "AUSTRIA", img: "🇦🇹"),
        Country(name: "이탈리아", engName: "ITALY", img: "🇮🇹"),
        Country(name: "일본", engName: "JAPAN", img: "🇯🇵"),
        Country(name: "중국", engName: "CHINA", img: "🇨🇳"),
        Country(name: "캐나다", engName: "CANADA", img: "🇨🇦"),
        Country(name: "프랑스", engName: "FRANCE", img: "🇫🇷"),
        Country(name: "핀란드", engName: "FINLAND", img: "🇫🇮"),
        Country(name: "호주", engName: "AUSTRALIA", img: "🇦🇺")
    ]
    
    
    
    override func viewDidLoad() {
        //카테고리 초기값
        category[0].isSelected = true
        index = 0
        
        //정렬버튼
        let new = UIAction(title: "최신순", handler: { _ in self.sortByDate() })
        let like = UIAction(title: "좋아요순", handler: { _ in self.sortByLike() })
        let buttonMenu = UIMenu(title: "", children: [new, like])
        sortButton.menu = buttonMenu
        
        //셀등록
        registerXib()
        tableView.delegate = self
        tableView.dataSource = self
        
        super.viewDidLoad()
    }
    //알림
    @IBAction func alarm(_ sender: Any) {
        guard let alarmVC = storyboard?.instantiateViewController(identifier: "AlarmVC") as? AlarmViewController else{
            return
        }
        alarmVC.modalPresentationStyle = .fullScreen
        present(alarmVC, animated: true, completion: nil)
    }
    //검색
    @IBAction func search(_ sender: Any) {
        guard let searchVC = storyboard?.instantiateViewController(identifier: "SearchVC") as? SearchViewController else{
            return
        }
        searchVC.modalPresentationStyle = .fullScreen
        present(searchVC, animated: true, completion: nil)
    }
    //정렬
    func sortByDate(){
        sortButton.setTitle("최신순", for: .normal)
        //코드추가 필요
    }
    func sortByLike(){
        sortButton.setTitle("좋아요순", for: .normal)
    }
    
    //카테고리
    @IBAction func touchButton(_ sender: UIButton) {
        if index != nil {
            if !sender.isSelected{
                for index in category.indices {
                    category[index].isSelected = false
                }
                sender.isSelected = true
                index = category.firstIndex(of: sender)
            }
        }else{
            sender.isSelected = true
            index = category.firstIndex(of: sender)
        }
    }
    //카테고리 선택시 데이터 reload
    @IBAction func life(_ sender: Any) {
        //tableView.reloadData()
        reloadTableView(data: "life")
    }
    @IBAction func prepare(_ sender: Any) {
        reloadTableView(data: "prepare")
    }
    @IBAction func trade(_ sender: Any) {
        reloadTableView(data: "trade")
    }
    @IBAction func travel(_ sender: Any) {
        reloadTableView(data: "travel")
    }
    @IBAction func etc(_ sender: Any) {
        reloadTableView(data: "etc")
    }
    func reloadTableView(data: String){
        switch data{
        case "life":
            //코드 추가 필요
            break
        case "prepare":
            break
        case "trade":
            break
        case "travel":
            break
        case "etc":
            break
        default:
            break
        }
        tableView.reloadData()
    }
    
    //셀 등록
    private func registerXib() {
        let nibName = UINib(nibName: "FeedCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "FeedCell")
    }
    //국가선택
    @IBAction func CountrySelection(_ sender: Any) {
        let nationSelectionVC = NationSelectionVC.present(parent: self)
                nationSelectionVC.onDismissed = { [weak self] () in
                    let countryInfo = nationSelectionVC.selectedCountry
                    var engName: String = ""

                    for i in  0..<(self?.countries.count ?? 0)  {
                        if self?.countries[i].name == countryInfo?.korName {
                            engName = self?.countries[i].engName ?? ""
                        }
                    }

                    self?.countryName.setTitle(countryInfo?.korName, for: .normal)

                    self?.engCountryName.text = engName
                    self?.countryImg.image = UIImage(named: countryInfo?.engName ?? "")
    }
        
    }
    
}
extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    //셀 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    //셀 종류
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as? FeedCell else{return UITableViewCell()}
        return cell
    }
    //테이블뷰 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    //데이터 전달
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        performSegue(withIdentifier: "DetailVC", sender: indexPath.row)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailVC"{
            let vc = segue.destination as? DetailViewController
            if let index = sender as? Int{
                vc?.num = index
            }
            vc?.modalPresentationStyle = .fullScreen
        }
    }
}

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255.0,
            green: CGFloat((hex >> 8) & 0xFF) / 255.0,
            blue: CGFloat(hex & 0xFF) / 255.0,
            alpha: alpha
        )
    }
}
