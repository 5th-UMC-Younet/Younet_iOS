//
//  SelectNationPopup.swift
//  YounetProject
//
//  Created by 김제훈 on 1/22/24.
//

import UIKit

class SelectNationPopup: UIViewController {
    
    
    @IBOutlet var closeButton: UIButton!
    
    @IBOutlet var inputTextField: UITextField!
    
    @IBOutlet var searchResultTableView: UITableView!
    
    
    var onDismissed : (() -> Void)? = nil
    
    
    var searchResultArr: [String] = ["Hanyang", "Erika", "Seoul"]
    
    var tempSearchResultArr : [String] = []
    
    //
    var previousSearchWork : DispatchWorkItem? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    private func config()
    {
        closeButton.addTarget(self, action: #selector(closeBtnClicked), for: .touchUpInside)
        
        if let myImage = UIImage(systemName: "magnifyingglass"){
            inputTextField.withImage(direction: .Right, image: myImage, colorSeparator: UIColor.clear, colorBorder: UIColor.clear)
        }
        
        inputTextField.addTarget(self, action: #selector(userInputHandling(_:)), for: .editingChanged)
        
        let nib = UINib(nibName: "SearchResultTableViewCell", bundle: nil)
        searchResultTableView.register(nib, forCellReuseIdentifier: "SearchResultTableViewCell")
        
        searchResultTableView.dataSource = self
        searchResultTableView.delegate = self
        
        
    }
    
    @objc
    private func userInputHandling(_ sender: UITextField) 
    {
        
        // cancel previous work
        self.previousSearchWork?.cancel()
        
        let searchWork = DispatchWorkItem(block: {
            DispatchQueue.global(qos: .userInteractive).async {
                DispatchQueue.main.async { [weak self] in
//                    guard let self = self else { return }
                    guard let self else { return }
                    let userInput = sender.text ?? ""
                    self.apiCall(searchTerm: userInput, completion: { apiResult in
                        self.tempSearchResultArr = apiResult
                        self.searchResultTableView.reloadData()
                    })
                }
            }
        })
        
        self.previousSearchWork = searchWork
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: searchWork)
        
        print(#fileID, #function, #line, "- \(tempSearchResultArr)")
    }
    
    // example api heavyWork
    private func apiCall(searchTerm: String, completion: @escaping ([String]) -> Void) {
        print(#fileID, #function, #line, "- searchTerm: \(searchTerm)")
        // api example call
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { [weak self] in
            guard let self else { return }
            let filtered = self.searchResultArr.filter({ $0.contains(searchTerm)})
            print(#fileID, #function, #line, "- searchTerm: \(searchTerm)")
            completion(filtered)
        })
    }
    
    @objc
    private func closeBtnClicked(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: onDismissed)
    }
    
    @discardableResult
    class func present(parent: UIViewController) -> SelectNationPopup {
        let storyboard = UIStoryboard(name: "SelectNationPopup", bundle: .main)
        let vc = storyboard.instantiateInitialViewController() as! SelectNationPopup
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        parent.present(vc, animated: true)
        return vc
    }
}

extension SelectNationPopup: UITableViewDelegate 
{
    
}

extension SelectNationPopup: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempSearchResultArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath) as? SearchResultTableViewCell {
            cell.nationTitleLabel.text = tempSearchResultArr[indexPath.row]
            return cell
        }
        
        
        return UITableViewCell()
    }
    
    
}
