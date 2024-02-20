//
//  NationSelectionVC.swift
//  YounetProject
//
//  Created by 김제훈 on 1/31/24.
//

import UIKit

import UIKit

/// 사용 예시 코드
/// let nationSelectionVC = NationSelectionVC.present(parent: self)
/// nationSelectionVC.onDismissed = { //비동기로 처리하는 부분
///     print(#fileID, #function, #line, "- DISMISSED")
///     print(#fileID, #function, #line, "- \(nationSelectionVC.selectedCountry)")
/// }
/// nationSelectionVC 안에 selectedCountry 맴버가 있고 선택된 국가의 정보를 담고있습니다. 이를 활용하여 onDismissed 클로저를 커스텀 하셔서 팝업이 dismiss될때 알맞은 곳에 선택한 국가 정보를 사용하시면 됩니다.
class NationSelectionVC: UIViewController
{
    @IBOutlet var closeBtn: UIButton!
    @IBOutlet var nationSelectionTableView: UITableView!
    @IBOutlet var selectionBtn: UIButton!
    
    var previousSelectedIndexPath : IndexPath? = nil
    
    // 국가 리스트
    let countryList: [CountryDTO] = [CountryDTO(engName: "denmark", korName: "덴마크")
                                        , CountryDTO(engName: "germany", korName: "독일")
                                        , CountryDTO(engName: "usa", korName: "미국")
                                        , CountryDTO(engName: "belgium", korName: "벨기에")
                                        , CountryDTO(engName: "brazil", korName: "브라질")
                                        , CountryDTO(engName: "sweden", korName: "스웨덴")
                                        , CountryDTO(engName: "switzerland", korName: "스위스")
                                        , CountryDTO(engName: "spain", korName: "스페인")
                                        , CountryDTO(engName: "austria", korName: "오스트리아")
                                        , CountryDTO(engName: "italy", korName: "이탈리아")
                                        , CountryDTO(engName: "japan", korName: "일본")
                                        , CountryDTO(engName: "china", korName: "중국")
                                        , CountryDTO(engName: "canada", korName: "캐나다")
                                        , CountryDTO(engName: "france", korName: "프랑스")
                                        , CountryDTO(engName: "finland", korName: "핀란드")
                                        , CountryDTO(engName: "australia", korName: "호주")
                                        , CountryDTO(engName: "mexico", korName: "멕시코")
                                        , CountryDTO(engName: "netherlands", korName: "네덜란드")]
    var onDismissed : (() -> Void)? = nil
    var selectedCountry: CountryDTO? = nil
    
    override func viewDidLoad()
    {
        print(#fileID, #function, #line, "- \(selectedCountry?.engName)")
        super.viewDidLoad()
        config()
    }

    private func config()
    {
        closeBtn.addTarget(self, action: #selector(onDismissed(_:)), for: .touchUpInside)
        selectionBtn.addTarget(self, action: #selector(onDismissed(_:)), for: .touchUpInside)
        
        nationSelectionTableView.dataSource = self
        nationSelectionTableView.delegate = self
        let nib = UINib(nibName: "NationSelectionCell", bundle: nil)
        nationSelectionTableView.register(nib, forCellReuseIdentifier: "NationSelectionCell")
        nationSelectionTableView.separatorStyle = .none
        
        
        
        if let foundIndex = countryList.firstIndex(where: {
            $0.engName == self.selectedCountry?.engName ?? ""
        }) {
            let initialPreviousIndex = IndexPath(row: foundIndex, section: 0)
            self.previousSelectedIndexPath = initialPreviousIndex
        }
        
        nationSelectionTableView.reloadData()
    }
    
    @objc
    private func onDismissed(_ sender: UIButton)
    {
        
        self.dismiss(animated: true, completion: onDismissed)
    }
    
    @discardableResult
    class func present(parent: UIViewController) -> NationSelectionVC {
        let storyboard = UIStoryboard(name: "NationSelectionVC", bundle: .main)
        print(#fileID, #function, #line, "- \(storyboard)")
        let vc = storyboard.instantiateInitialViewController() as! NationSelectionVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        parent.present(vc, animated: true)
        return vc
    }
    
    @discardableResult
    class func present(parent: UIViewController, selectedCountry: CountryDTO? = nil) -> NationSelectionVC {
        let storyboard = UIStoryboard(name: "NationSelectionVC", bundle: .main)
        print(#fileID, #function, #line, "- \(storyboard)")
        let vc = storyboard.instantiateInitialViewController() as! NationSelectionVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        
        vc.selectedCountry = selectedCountry
        
        parent.present(vc, animated: true)
        return vc
    }
}


//MARK: - TableViewDataSource
extension NationSelectionVC: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NationSelectionCell", for: indexPath) as? NationSelectionCell else { return UITableViewCell() }
        
        cell.configCell(countryList[indexPath.row], selected: selectedCountry)

//        if (countryList[indexPath.row].engName == selectedCountry?.engName ?? "")
//        {
//            
//            cell.isSelectedBefore = true
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedCountry = countryList[indexPath.row]
        
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var reloadIndexes : [IndexPath] = []
                
        reloadIndexes.append(indexPath)
        
        if let previous = previousSelectedIndexPath {
            reloadIndexes.append(previous)
        }
        
        tableView.reloadRows(at: reloadIndexes, with: .automatic)
        
        self.previousSelectedIndexPath = indexPath
        
//        tableView.reloadData()
    }
    
}
//MARK: - TableViewDelegate
extension NationSelectionVC: UITableViewDelegate
{
   
}

