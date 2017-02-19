//
//  HomeVC.swift
//  SwiftTest
//
//  Created by Nguyen Duc Tam on 2017/02/18.
//  Copyright © 2017年 Nguyen Duc Tam. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    @IBOutlet weak var characterTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        characterTable.register(UINib(nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "HomeCell")
        characterTable.delegate = self
        characterTable.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


extension HomeVC : UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:HomeCell = characterTable.dequeueReusableCell(withIdentifier: "HomeCell") as! HomeCell
        cell.characterNameLbl.text = "鬼"
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
    }
    
}
