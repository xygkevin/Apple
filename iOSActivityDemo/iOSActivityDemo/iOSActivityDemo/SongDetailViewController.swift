//
//  SongDetailViewController.swift
//  iOSActivityDemo
//
//  Created by uwei on 2018/8/6.
//  Copyright © 2018 TEG of Tencent. All rights reserved.
//

import UIKit

class SongDetailViewController: UIViewController, NSUserActivityDelegate {

    var songInfo: SongInfo!
    var songIndex: Int?
    
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var styleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        songLabel.text = songInfo.song
        albumLabel.text = songInfo.album
        styleLabel.text = songInfo.style

        
        
        let songActivity = NSUserActivity(activityType: "com.tencent.teg.iOSActivityDemo")
        
        //        Set up title that will be displayed in Spotlight search results
        songActivity.title = songInfo.song
        
        // to improve search conditions you can set additional keywords
        var keywords = songInfo.song.split(separator: " ").map{ String($0) }
        keywords.append(songInfo.album)
        keywords.append(songInfo.style)
        songActivity.keywords = Set(keywords)
        
        songActivity.isEligibleForHandoff = true
        songActivity.isEligibleForSearch = true
        songActivity.isEligibleForPublicIndexing =  true
        
        songActivity.delegate = self
        songActivity.needsSave = true
        
        userActivity = songActivity
        userActivity?.becomeCurrent()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func userActivityWillSave(_ userActivity: NSUserActivity) {
        print("\(#function)")
        userActivity.userInfo = ["index" : songIndex!]
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
