//
//  HomeVC.swift
//  SwiftTest
//
//  Created by Nguyen Duc Tam on 2017/02/18.
//  Copyright © 2017年 Nguyen Duc Tam. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleMobileAds

class HomeVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    lazy var adBannerView: GADBannerView = {
        let adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        adBannerView.adUnitID = AdmobDefine.AdUnitID
        adBannerView.delegate = self
        adBannerView.rootViewController = self
        
        return adBannerView
    }()
    var interstitial: GADInterstitial?
    var charactersList = [Character]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        adBannerView.load(GADRequest())
        tableView.register(UINib(nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "HomeCell")
        
        for _ in 0...4 {
            let characterItem = Character()
            
            characterItem.name = "名前のない男"
            
            characterItem.avatar =  "call"
            
            characterItem.callAudio = "call"
            characterItem.talk1Img = "talk1"
            characterItem.talk2Img = "talk2"
            characterItem.talk3Img = "talk3"
            characterItem.talk1Audio = "talk1"
            characterItem.talk2Audio = "talk2"
            characterItem.talk3Audio = "talk3"

            
            charactersList.append(characterItem)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK : UITableViewDataSource, UITableViewDelegate

extension HomeVC : UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return adBannerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return adBannerView.frame.height
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return charactersList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:HomeCell = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as! HomeCell
        let characterItem = charactersList[indexPath.row]
        cell.characterNameLbl.text = characterItem.name
        cell.avatarImg.image = UIImage(named: characterItem.avatar)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let characterItem = charactersList[indexPath.row]
        let callDetailVC = CallDetailVC()
        callDetailVC.characterContent = characterItem
        callDetailVC.delegate = self
        self.navigationController?.pushViewController(callDetailVC, animated: true)
    }
    
}

// MARK: - CallDetailVCDelegate
extension HomeVC: CallDetailVCDelegate {
    
    func view(view: CallDetailVC, needsPerformAction action: CallDetailVC.Action) {
        switch action {
        case .callBack:
            print("do something")
            interstitial = createAndLoadInterstitial()
        }
    }
}

// MARK: - GADBannerViewDelegate, GADInterstitialDelegate

extension HomeVC : GADBannerViewDelegate, GADInterstitialDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
        // Reposition the banner ad to create a slide down effect
        let translateTransform = CGAffineTransform(translationX: 0, y: -bannerView.bounds.size.height)
        bannerView.transform = translateTransform
        
        UIView.animate(withDuration: 0.5) {
            bannerView.transform = CGAffineTransform.identity
        }
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads")
        print(error)
    }
    
    func createAndLoadInterstitial() -> GADInterstitial? {
        interstitial = GADInterstitial(adUnitID: AdmobDefine.AdUnitID)
        
        guard let interstitial = interstitial else {
            return nil
        }
        
        let request = GADRequest()
        // Remove the following line before you upload the app
        request.testDevices = [ kGADSimulatorID ]
        interstitial.load(request)
        interstitial.delegate = self
        
        return interstitial
    }
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("Interstitial loaded successfully")
        ad.present(fromRootViewController: self)
    }
    
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        print("Fail to receive interstitial")
    }
    
    
}
