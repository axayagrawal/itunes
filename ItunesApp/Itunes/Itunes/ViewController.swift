//
//  ViewController.swift
//  Itunes
//
//  Created by Student on 02/04/19.
//  Copyright © 2019 axay. All rights reserved.
//

import UIKit
import AVFoundation
struct songInfo {
    var songArtwork: UIImage
    var songName: String
    var songArtist: String
}





class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var data:Data!
    var jsonResult:NSDictionary!
    var AudioPlayer:AVAudioPlayer!
    var playPause = false
    
    
    
    
  
    @IBOutlet weak var playPauseBtn: UIButton!
    
    
    @IBAction func playPauseAction(_ sender: Any) {
        
        if(playPause){
            AudioPlayer.pause()
            playPauseBtn.setTitle("Play", for: .normal)
        }else{
            AudioPlayer.play()
            playPauseBtn.setTitle("Pause", for: .normal)

        }
        playPause = !playPause
        
        
    }
    @IBOutlet weak var songCV: UICollectionView!
    
    
    
    func playSound(targetSound:String){
        let path = Bundle.main.path(forResource: targetSound , ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        do{
            AudioPlayer = try AVAudioPlayer(contentsOf: url)
            AudioPlayer.prepareToPlay()
        }
        catch let error as NSError{
            print(error.description)
        }
        AudioPlayer.play()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let songInfo = jsonResult["\(indexPath.row)"] as? [String]{
            playSound(targetSound: songInfo[1])
            playPauseBtn.isHidden = false
            
        }
    }

    
    func openJsonFile(){
        if let path:String = Bundle.main.path(forResource: "songsDB", ofType: "json") {
            do {
                data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? NSDictionary
                print(jsonResult)
            } catch {
                print("Error")
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jsonResult.count-1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SongCVC", for: indexPath) as! SongCVC
        if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let songInfo = jsonResult["\(indexPath.row)"] as? [String]{
            cell.songImg.image = UIImage(named: songInfo[0])
            cell.songNamelbl.text = songInfo[1]
            cell.songArtistlbl.text = songInfo[2]
         
            
            
        }
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        openJsonFile()
        
        
        let cellWidth = UIScreen.main.bounds.width / 2 - 25
        let cellHeight = cellWidth * 1.3125
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        collectionLayout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        songCV.collectionViewLayout = collectionLayout
        songCV.allowsMultipleSelection = false
        
        
        
        songCV.register(UINib(nibName: "SongCVC", bundle: nil), forCellWithReuseIdentifier: "SongCVC")
        
        playPauseBtn.isHidden = true
        // Do any additional setup after loading the view, typically from a nib.
    }


}

