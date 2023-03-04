//
//  HomeViewController.swift
//  DesignApp
//
//  Created by Mac on 04/03/23.
//

import UIKit
import MapKit
import CoreLocation

class HomeViewController: UIViewController {

    @IBOutlet weak var currentLocationMap: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    var populations = [Population]()
    var users: [Users] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        collectionView.dataSource = self
        
        let nibName = UINib(nibName: "TableViewCell", bundle: nil)
        self.tableView.register(nibName, forCellReuseIdentifier: "TableViewCell")
        
        let nibName1 = UINib(nibName: "CollectionViewCell", bundle: nil)
        self.collectionView.register(nibName1, forCellWithReuseIdentifier: "CollectionViewCell")
        
        fetchingData {
            self.tableView.reloadData()
        }
        
        let urlString = "https://gorest.co.in/public/v2/users"
        guard let url = URL(string: urlString) else { return }
        
        //create request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // session
        let session = URLSession(configuration: .default)
        // data task
        let datatask = session.dataTask(with: request){ data, respons, error in  print("the data is \(data)")
            print("the error is \(error)")
            print(data)
            print(respons)
            guard let data = data else{
                print("No data found")
                return
            }
            guard let getJSONObject = try? JSONSerialization.jsonObject(with: data) as? [[String : Any]] else {
                print("json object not found")
                return
            }
            for dictionary in getJSONObject{
                let eachDictionary = dictionary as [String : Any]
                let uId = eachDictionary["id"] as! Int
                let uName = eachDictionary["name"] as! String
                let uGender = eachDictionary["gender"] as! String
                
                let newUsers = Users(id: uId, name: uName, gender: uGender)
                self.users.append(newUsers)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
        datatask.resume()
       
    }
    func fetchingData(completed : @escaping() -> ()) {
        let urlString = "https://datausa.io/api/data?drilldowns=Nation&measures=Population"
        let url = URL(string: urlString)!
        
        URLSession.shared.dataTask(with: url) { data,response,error in
            if(error == nil){
                do{
                    let jsonDecoder = JSONDecoder()
                    self.populations = try jsonDecoder.decode([Population].self, from: data!)
                    
                    DispatchQueue.main.async {
                        completed()
                    }
                }catch{print("error")}
            }
        }.resume()
    }
}




extension HomeViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return populations.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.populationLabel.text = String(populations[indexPath.row].population)
        cell.yearLabel.text = populations[indexPath.row].year
        return cell
    }
}
extension HomeViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      60
    }
}

extension HomeViewController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        collectionCell.idLabel.text = String(users[indexPath.row].id)
        collectionCell.nameLabel.text = users[indexPath.row].name
        collectionCell.genderLabel.text = users[indexPath.row].gender
        collectionCell.layer.cornerRadius = 10
        return collectionCell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width/2
        return CGSize(width: width, height: width)
    }
    
}
