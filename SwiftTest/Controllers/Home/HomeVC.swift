//
//  HomeVC.swift
//  SwiftTest
//
//  Created by Nguyen Duc Tam on 2017/02/18.
//  Copyright © 2017年 Nguyen Duc Tam. All rights reserved.
//

import UIKit
import GoogleMobileAds

class HomeVC: UIViewController,GADBannerViewDelegate, GADInterstitialDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var fuck: UILabel!
    
    lazy var adBannerView: GADBannerView = {
        let adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        adBannerView.adUnitID = "ca-app-pub-1113266670590505/6809190871"
        adBannerView.delegate = self
        adBannerView.rootViewController = self
        
        return adBannerView
    }()
    var interstitial: GADInterstitial?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        adBannerView.load(GADRequest())
        tableView.register(UINib(nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "HomeCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        interstitial = createAndLoadInterstitial()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
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
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-8501671653071605/2568258533")
        
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
        return 20
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:HomeCell = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as! HomeCell
        cell.characterNameLbl.text = "鬼"
        cell.avatarImg.image = UIImage(named: "oni_avt")
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let callDetailVC = CallDetailVC()
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
