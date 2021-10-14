//
//  ViewController.swift
//  iOSActivityDemo
//
//  Created by uwei on 2018/8/6.
//  Copyright © 2018 TEG of Tencent. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    override func prepareForReuse() {
        // your cleanup code
    }
}



class ViewController: UIViewController, UITableViewDelegate {

    fileprivate var songList: [SongInfo] = []
    //存储搜索item的标识符
    private var searchSongIdentifier: Int?
    @IBOutlet weak var tableView: UITableView!
    fileprivate let CellIdentifier = "MyCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        songList.append(SongInfo(song: "Bob Dylan - Like a Rolling Stone", album: "Highway 61 Revisited (1965)", style: "Rock"))
        songList.append(SongInfo(song: "John Lennon - Imagine", album: "Imagine (1971)", style: "Rock, Pop"))
        songList.append(SongInfo(song: "Nirvana - Smells Like Teen Spirit", album: "Nevermind (1991)", style: "Rock"))

//        self.tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CellIdentifier)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: false)
        }
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func restoreUserActivityState(_ activity: NSUserActivity) {
        if let index = activity.userInfo?["index"] as? Int {
            searchSongIdentifier = index
            self.performSegue(withIdentifier: "detailSegue", sender: self)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var songId: Int?
        if let index = tableView.indexPathForSelectedRow?.row{
            songId = index
        }else{
            songId = searchSongIdentifier
        }
        //设置对应的歌曲信息和位置
        let controller = segue.destination as! SongDetailViewController
        controller.songInfo = songList[songId!]
        controller.songIndex = songId!

    }
}
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath) as! CustomTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier)
        cell!.textLabel!.text = songList[(indexPath as NSIndexPath).row].song
        return cell!
    }
}
