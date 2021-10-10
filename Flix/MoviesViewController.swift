//
//  ViewController.swift
//  Flix
//
//  Created by Brian Ai on 10/7/21.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    
    var movies = [[String:Any]]()
    
    override func viewDidLoad() {
        
        tableView.dataSource = self
        tableView.delegate = self
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                 let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    
                 self.movies = dataDictionary["results"] as! [[String:Any]]
                 self.tableView.reloadData()
             }
            
         }
        
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        let movies = movies[indexPath.row]
        let title = movies["title"] as! String
        let synopsis = movies["overview"] as! String
        
        cell.titleLabel?.text = title
        cell.synopsisLabel?.text = synopsis
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath =  movies["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        cell.posterView.af.setImage(withURL: posterUrl!)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // find selected movie
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)! // ask tableView for the indexPath
        let movie = movies[indexPath.row]
        
        // pass selected movie details to viewController
        let detailsViewController = segue.destination as! MovieDetailsViewController // cast to specific view controller
        
        detailsViewController.movie = movie
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

