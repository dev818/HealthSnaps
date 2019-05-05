//
//  NewChatViewController.swift
//  HealthSnaps
//
//  Created by Admin on 21/11/2017.
//  Copyright © 2017 getHealthSnaps. All rights reserved.
//

import UIKit

class NewChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var naviBar: UINavigationBar!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var patientListTable: UITableView!
    
    var patientAry: [[String : Any]] = []
    var firstSpellAry: [String] = []
    var buttons = [UIButton]()
    var spellText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStatusBarBackgroundColor(color: "white")
        setNavigationBar()
        setSearchBar()
        setupSearchButtons()
        
        patientListTable.delegate = self
        patientListTable.dataSource = self
        
        // get List from server
        getPatientList()
    }

    
    //naviBar customize
    @objc func setNavigationBar() {
        
        naviBar.topItem?.title = "NewChat"
        let attrs = [
            NSAttributedStringKey.foregroundColor: UIColor.cyan,
            NSAttributedStringKey.font: UIFont(name: "Thonburi-Bold", size: 23)!
        ]
        naviBar.titleTextAttributes = attrs
        
    }
    
    //searchBar Customize
    @objc func setSearchBar() {
        
        searchBar.placeholder = "Search"
        searchBar.barTintColor = UIColor.white
        searchBar.delegate = self
        
    }
    
    //setup *-# buttons
    func setupSearchButtons() {
        
        spellText = ""
        var i = 0
        
        for spell in spells1 {
            let button = UIButton(type: .system)
            button.frame = CGRect(x: Int(self.view.bounds.width - 23), y: 126 + i * 17, width: 15, height: 15)
            button.setTitle(spell, for: [])
            button.setTitleColor(UIColor.black, for: UIControlState.normal)
            button.tag = i
            //button.addTarget(self, action: #selector(spellButtonTapped), for: .touchUpInside)
            self.view.addSubview(button)
            buttons.append(button)
            i += 1
        }
    }
    
    // MARK: - search bar delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        spellText = ""
        if searchText.isEmpty {
            patientAry = sortedPatientAryAll
            patientListTable.reloadData()
        } else {
            filterTableView(text: searchText)
        }
    }
    
    //*-A-Z-# buttons tapped
    @objc func spellButtonTapped(_sender: UIButton!) {
        
        spellText = spellText + spells[_sender.tag]
        filterTableView(text: spellText)
        //print(spellText)
    }
    
    func filterTableView(text: String) {
        
        patientAry = sortedPatientAryAll.filter({ (mod) -> Bool in
            
            return (mod["name"] as! String).lowercased().contains(text.lowercased())
            
        })
        patientListTable.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return patientAry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "patientCell") as! NewChatTableViewCell
        
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        let patient = patientAry[indexPath.row]
        
        cell.patientName.text = patient["name"] as? String
        cell.noteLabel.text = firstSpellAry[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80.0
    }
    
    @IBAction func closeBtnTapped(_ sender: UIButton) {
        
        performSegue(withIdentifier: "MessageViewFromNewChatView", sender: self)
    }
    
    
    //get Patient List from server API
    func getPatientList() {
        
        //when start app, did login?
        if (loginPatientList) {
            self.patientAry = sortedPatientAryAll
            print("Already login PatientList!")
            
            var compare: String = ""
            for patient in patientAry {
                let firstname = patient["firstName"] as! String
                let index = firstname.index(firstname.startIndex, offsetBy: 0)
                let firstSpell = String(firstname[index]) // returns String
                
                if compare == firstSpell {
                    firstSpellAry.append("")
                } else {
                    firstSpellAry.append(firstSpell)
                    compare = firstSpell
                }
            }
        }
        
    }
    
}
