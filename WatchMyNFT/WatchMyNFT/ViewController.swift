//
//  ViewController.swift
//  WatchMyNFT
//
//  Created by Hideyoshi Moriya on 2022/01/16.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    let DEFAULT_ADDRESS = "0x199012076Ea09f92D8C30C494E94738CFF449f57"
    let API_KEY = ""

    let wcProvider = WatchConnectivityProvider()
    var nfts:JSON = JSON()

    @IBOutlet weak var addressField: UITextField!
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nfts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let name = nfts[indexPath.row]["name"].stringValue
        cell.textLabel!.text = name
        
        let imageUrl = nfts[indexPath.row]["image_url"].stringValue
        let request = AF.request(imageUrl)
        request.responseData { responseData in
            guard let data = responseData.data else {return}
            guard let image = UIImage(data: data) else {return}
            cell.imageView?.image = image
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let imageUrl = nfts[indexPath.row]["image_url"].stringValue
        let request = AF.request(imageUrl)
        request.responseData { responseData in
            guard let data = responseData.data else {return}
            guard let image = UIImage(data: data) else {return}
            guard let resizedData = image.jpegData(compressionQuality: 0.3) else {return}
            self.wcProvider.send(data: resizedData)
        }
    }
     
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addressField.text = DEFAULT_ADDRESS
    }

    @IBAction func loadNFTsDidPush(_ sender: Any) {
        guard let address = addressField.text else {return}
        let request = AF.request("https://api-evhn3fdg4a-uw.a.run.app/assets?owner=\(address)&a=\(API_KEY)")
        request.responseJSON { response in
            do {
                guard let data = response.data else {return}
                let json = try JSON(data: data)
//                print(json["assets"][0])
                self.nfts = json["assets"]
                self.tableView.reloadData()
            } catch  {
            }


        }
    }
    //    @IBAction func sendImageToWatch(_ sender: Any) {
//        let image = UIImage(named: "opensea")
//        wcProvider.send(image: image)
//    }
    
}

