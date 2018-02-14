//
//  FavoritesTableViewController.swift
//  MLBHighlights iPad
//
//  Created by Ramon Geronimo on 12/25/17.
//  Copyright © 2017 Ramon Geronimo. All rights reserved.
//

import UIKit
import AVKit
import CoreData

class FavoritesTableViewController: CoreDataTableViewController {
    
    var playerViewController = AVPlayerViewController()
    var thisHighlight : FavoritesHighlights!
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activity.isHidden = true
       
        // Get the stack
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
        // Create a fetchrequest
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoritesHighlights")
        fr.sortDescriptors = [NSSortDescriptor(key: "headline", ascending: true),
                              NSSortDescriptor(key: "player", ascending: false),  NSSortDescriptor(key: "url", ascending: false),  NSSortDescriptor(key: "team", ascending: false)]
        
        // Create the FetchedResultsController
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        activity.stopAnimating()
        activity.isHidden = true
    }

    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    // MARK: - Table view data source
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         // Find the right highlight for this indexpath
        let favoriteHighlight = fetchedResultsController!.object(at: indexPath) as! FavoritesHighlights
        // Create the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // Sync notebook -> cell
        if favoriteHighlight.player != "" {
            cell.textLabel?.text = favoriteHighlight.player
        } else if favoriteHighlight.team != "" {
            cell.textLabel?.text = favoriteHighlight.team
        } else {
            cell.textLabel?.text = "Highlight Headline"
        }
        
        if favoriteHighlight.team != "" {
            if favoriteHighlight.team == "Boston Red Sox" {
                cell.imageView?.image = UIImage(named: "red sox")
            } else if favoriteHighlight.team == "New York Yankees" {
                cell.imageView?.image = UIImage(named: "yankees")
            } else if favoriteHighlight.team == "Arizona Diamondbacks" {
                cell.imageView?.image = UIImage(named: "diamondbacks")
            } else if favoriteHighlight.team == "Atlanta Braves" {
                cell.imageView?.image = UIImage(named: "braves")
            } else if favoriteHighlight.team == "Baltimore Orioles" {
                cell.imageView?.image = UIImage(named: "orioles")
            } else if favoriteHighlight.team == "Chicago Cubs" {
                cell.imageView?.image = UIImage(named: "cubs")
            } else if favoriteHighlight.team == "Chicago White Sox" {
                cell.imageView?.image = UIImage(named: "white sox")
            } else if favoriteHighlight.team == "Cincinnati Reds" {
                cell.imageView?.image = UIImage(named: "reds")
            } else if favoriteHighlight.team == "Cleveland Indians" {
                cell.imageView?.image = UIImage(named: "indians")
            } else if favoriteHighlight.team == "Colorado Rockies" {
                cell.imageView?.image = UIImage(named: "rockies")
            } else if favoriteHighlight.team == "Detroit Tigers" {
                cell.imageView?.image = UIImage(named: "tigers")
            } else if favoriteHighlight.team == "Florida Marlins" {
                cell.imageView?.image = UIImage(named: "marlins")
            } else if favoriteHighlight.team == "Houston Astros" {
                cell.imageView?.image = UIImage(named: "astros")
            } else if favoriteHighlight.team == "Kansas City Royals" {
                cell.imageView?.image = UIImage(named: "royals")
            } else if favoriteHighlight.team == "Los Angeles Angels" {
                cell.imageView?.image = UIImage(named: "angels")
            } else if favoriteHighlight.team == "Los Angeles Dodgers" {
                cell.imageView?.image = UIImage(named: "dodgers")
            } else if favoriteHighlight.team == "Milwaukee Brewers" {
                cell.imageView?.image = UIImage(named: "brewers")
            } else if favoriteHighlight.team == "Minnesota Twins" {
                cell.imageView?.image = UIImage(named: "twins")
            } else if favoriteHighlight.team == "New York Mets" {
                cell.imageView?.image = UIImage(named: "mets")
            } else if favoriteHighlight.team == "Oakland Athletics" {
                cell.imageView?.image = UIImage(named: "athletics")
            } else if favoriteHighlight.team == "Philadelphia Phillies" {
                cell.imageView?.image = UIImage(named: "phillies")
            } else if favoriteHighlight.team == "Pittsburgh Pirates" {
                cell.imageView?.image = UIImage(named: "pirates")
            } else if favoriteHighlight.team == "San Diego Padres" {
                cell.imageView?.image = UIImage(named: "padres")
            } else if favoriteHighlight.team == "San Francisco Giants" {
                cell.imageView?.image = UIImage(named: "giants")
            } else if favoriteHighlight.team == "Seattle Mariners" {
                cell.imageView?.image = UIImage(named: "mariners")
            } else if favoriteHighlight.team == "St. Louis Cardinals" {
                cell.imageView?.image = UIImage(named: "cardinals")
            } else if favoriteHighlight.team == "Tampa Bay Rays" {
                cell.imageView?.image = UIImage(named: "rays")
            } else if favoriteHighlight.team == "Texas Rangers" {
                cell.imageView?.image = UIImage(named: "rangers")
            } else if favoriteHighlight.team == "Toronto Blue Jays" {
                cell.imageView?.image = UIImage(named: "blue jays")
            } else if favoriteHighlight.team == "Washington Nationals" {
                cell.imageView?.image = UIImage(named: "nationals")
            }
        } else {
            cell.imageView?.image = UIImage(named: "Background")
        }
        
        cell.detailTextLabel?.text = favoriteHighlight.headline

//         Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Find the right highlight for this indexpath
        let favoriteHighlight = fetchedResultsController!.object(at: indexPath) as! FavoritesHighlights
        let url = URL(string: (favoriteHighlight.url)!)
        performUIUpdatesOnMain {
            self.thisHighlight = favoriteHighlight
            self.activity.isHidden = false
            self.activity.startAnimating()
            let player = AVPlayer(url: url!)
            self.playerViewController.player = player
            self.present(self.playerViewController, animated: true) {
//                self.playerViewController.videoGravity = AVLayerVideoGravity.resizeAspectFill.rawValue
                self.playerViewController.player!.play()
                NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerViewController.player?.currentItem)
                
                NotificationCenter.default.addObserver(self, selector: #selector(self.alertToKeep), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerViewController.player?.currentItem)
            }
        }
        
    }
    
    @objc func alertToKeep() {
        let ac = UIAlertController(title: "Keep this Highlight", message: "Would you like to keep this Highlight in your favorites?", preferredStyle: .alert)
        
        // Configure the alert actions
        let delete = UIAlertAction(title: "Delete", style: .destructive, handler: {
            action in
            // Get the stack
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let stack = delegate.stack
            stack.context.delete(self.thisHighlight)
            do {
                try stack.context.save()
            } catch {
                print("Error saving highlight")
            }
            
            print("Highlight Delete")
        })
        
        let keep = UIAlertAction(title: "Keep", style: .default, handler: {
            action in
            print("Keeping Highlight")
            
        })
        
        // Add actions then present alert
        ac.addAction(delete)
        ac.addAction(keep)
        present(ac, animated: true, completion: nil)
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        self.playerViewController.dismiss(animated: true)
    }

}
