//
//  ViewController.swift
//  MLBHighlights iPad
//
//  Created by Ramon Geronimo on 12/25/17.
//  Copyright © 2017 Ramon Geronimo. All rights reserved.
//

import UIKit
import AVKit
import CoreData

class ViewController: UIViewController, XMLParserDelegate {
    
    let MLB = MLBAMAPI.sharedInstance()
    
   
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var awayTeamRuns: UILabel!
    @IBOutlet weak var homeTeamRuns: UILabel!
    @IBOutlet weak var away: UIImageView!
    @IBOutlet weak var home: UIImageView!
    
    @IBOutlet weak var americanLeague: UISegmentedControl!
    @IBOutlet weak var nationalLeague: UISegmentedControl!
    
    @IBOutlet weak var play_highlights: UIButton!
    
    var playerViewController = AVPlayerViewController()

    var highlights = [Any]()
    var media = [Any]()
    var mediaURLS = [String]()
    var favorites = [XMLIndexer]()
    var tempFavorites : XMLIndexer!
    var allMyFavorites = [XMLIndexer]()
    var randomURL = ""
    var homeTeamURL = [String]()
    var awayTeamURL = [String]()
    var year = "2010"
    var month = "04"
    var day = "01"
    var teamCode = "all"
    var homeTeamHighlights = ""
    var firstView = false
    var whatLeague = "al"
    var temp = false
    var duplicate = false

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activity.isHidden = true
        
        
        // Do any additional setup after loading the view, typically from a nib.
        home.isHidden = true
        away.isHidden = true
        homeTeamRuns.isHidden = true
        awayTeamRuns.isHidden = true
        firstView = true
        nationalLeague.isHidden = true
        
        
        

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if !firstView {
        
            home.isHidden = false
            away.isHidden = false
            homeTeamRuns.isHidden = false
            awayTeamRuns.isHidden = false
            
        }
        
        activity.stopAnimating()
        activity.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerViewController.player?.currentItem)
        NotificationCenter.default.addObserver(self, selector: #selector(self.alertToAdd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerViewController.player?.currentItem)
        
    }

   
    @IBAction func play(_ sender: Any) {
//        print(teamCode)
        activity.isHidden = false
        activity.startAnimating()
        self.addTarget()
        MLB.getScore(year: year, month: month, day: day, teamCode: teamCode, vc: self)

    }
   
    
    @IBAction func year(_ sender: UISegmentedControl) {
        let selected_year = sender.selectedSegmentIndex
        switch selected_year {
        case 0:
            year = "2010"
        case 1:
            year = "2011"
        case 2:
            year = "2012"
        case 3:
            year = "2013"
        case 4:
            year = "2014"
        case 5:
            year = "2015"
        case 6:
            year = "2016"
        case 7:
            year = "2017"
        default:
            year = "2017"
        }
    }
    @IBAction func month(_ sender: UISegmentedControl) {
        let selected_month = sender.selectedSegmentIndex
        switch selected_month {
        case 0:
            month = "04"
        case 1:
            month = "05"
        case 2:
            month = "06"
        case 3:
            month = "07"
        case 4:
            month = "08"
        case 5:
            month = "09"
        case 6:
            month = "10"
        case 7:
            month = "11"
        default:
            month = "11"
        }
    }
    @IBAction func day(_ sender: UISegmentedControl) {
        let selected_day = sender.selectedSegmentIndex
        switch selected_day {
        case 0:
            day = "01"
        case 1:
            day = "02"
        case 2:
            day = "03"
        case 3:
            day = "04"
        case 4:
            day = "05"
        case 5:
            day = "06"
        case 6:
            day = "07"
        case 7:
            day = "08"
        case 8:
            day = "09"
        case 9:
            day = "10"
        case 10:
            day = "11"
        case 11:
            day = "12"
        case 12:
            day = "13"
        case 13:
            day = "14"
        case 14:
            day = "15"
        case 15:
            day = "16"
        case 16:
            day = "17"
        case 17:
            day = "18"
        case 18:
            day = "19"
        case 19:
            day = "20"
        case 20:
            day = "21"
        case 21:
            day = "22"
        case 22:
            day = "23"
        case 23:
            day = "24"
        case 24:
            day = "25"
        case 25:
            day = "26"
        case 26:
            day = "27"
        case 27:
            day = "28"
        case 28:
            day = "29"
        case 29:
            day = "30"
        case 30:
            day = "31"
        default:
            day = "1"
        }
    }
    
    @IBAction func league(_ sender: UISegmentedControl) {
        let selected_league = sender.selectedSegmentIndex
        switch selected_league {
        case 0:
            whatLeague = "al"
            americanLeague.isHidden = false
            nationalLeague.isHidden = true
        case 1:
            whatLeague = "nl"
            americanLeague.isHidden = true
            nationalLeague.isHidden = false
        case 2:
            teamCode = "all"
            americanLeague.isHidden = true
            nationalLeague.isHidden = true
        case 3:
            teamCode = "fav"
            americanLeague.isHidden = true
            nationalLeague.isHidden = true
        default:
            break
        }
        
    }
    
    @IBAction func team(_ sender: UISegmentedControl) {
        let selected_team = sender.selectedSegmentIndex
        switch selected_team {
        case 0:
            teamCode = "all"
        case 1:
            teamCode = "oak"
        case 2:
            teamCode = "hou"
        case 3:
            teamCode = "ana"
        case 4:
            teamCode = "sea"
        case 5:
            teamCode = "tex"
        case 6:
            teamCode = "cha"
        case 7:
            teamCode = "cle"
        case 8:
            teamCode = "det"
        case 9:
            teamCode = "kca"
        case 10:
            teamCode = "min"
        case 11:
            teamCode = "bal"
        case 12:
            teamCode = "bos"
        case 13:
            teamCode = "nya"
        case 14:
            teamCode = "tba"
        case 15:
            teamCode = "tor"
        default:
            teamCode = "all"
        }
    }
    
    @IBAction func teamsSecondRow(_ sender: UISegmentedControl) {
        let selected_teamSecondRow = sender.selectedSegmentIndex
        switch selected_teamSecondRow {
        case 0:
            teamCode = "all"
        case 1:
            teamCode = "ari"
        case 2:
            teamCode = "col"
        case 3:
            teamCode = "lan"
        case 4:
            teamCode = "sdn"
        case 5:
            teamCode = "sfn"
        case 6:
            teamCode = "chn"
        case 7:
            teamCode = "cin"
        case 8:
            teamCode = "mil"
        case 9:
            teamCode = "pit"
        case 10:
            teamCode = "sln"
        case 11:
            teamCode = "atl"
        case 12:
            teamCode = "mia"
        case 13:
            teamCode = "nyn"
        case 14:
            teamCode = "phi"
        case 15:
            teamCode = "was"
        default:
            teamCode = "all"
        }
        
    }
    
    
    
    
    func addTarget () {
        if whatLeague == "al" {
            americanLeague.addTarget(self, action: #selector((ViewController.team)), for: .valueChanged)
        } else if whatLeague == "nl" {
            nationalLeague.addTarget(self, action: #selector((ViewController.teamsSecondRow)), for: .valueChanged)
        }
    }

    @objc func playerDidFinishPlaying(note: NSNotification) {
        self.playerViewController.dismiss(animated: true)
    }
    
    
    
    //Core Data Stack
    
    func getCoreDataStack() -> CoreDataStack {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.stack
    }
    
    //Fetch Results
    
    func getFetchedResultsController() -> NSFetchedResultsController<NSFetchRequestResult> {
        // Get the stack
        let stack = getCoreDataStack()
        
        // Create a fetchrequest
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoritesHighlights")
        fr.sortDescriptors = [NSSortDescriptor(key: "headline", ascending: true),
                              NSSortDescriptor(key: "player", ascending: false),  NSSortDescriptor(key: "url", ascending: false),  NSSortDescriptor(key: "team", ascending: false)]
        
        return NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        
    }
    
    @objc func alertToAdd() {
        let ac = UIAlertController(title: "Add this Highlight", message: "Would you like to add this Highlight to your favorites?", preferredStyle: .alert)
        
        // Configure the alert actions
        let no = UIAlertAction(title: "Don't Add", style: .destructive, handler: {
            action in
            self.duplicate = false
            print("Highlight not save")
        })
        
        let add = UIAlertAction(title: "Add", style: .default, handler: {
            action in
            // Get the stack
            let stack = self.getCoreDataStack()
            var player = ""
            var team = ""
            
            do {
                
                
                if let highlightPlayer = self.tempFavorites["player"].element?.text, let highlightTeam = self.tempFavorites["team"].element?.text {
                    player = highlightPlayer
                    team = highlightTeam
                }
                
                let fetchedResultsController = self.getFetchedResultsController()
                try fetchedResultsController.performFetch()
                let favoriteHighlight = FavoritesHighlights(headline: (self.tempFavorites["headline"].element?.text)!, player: player, url: (self.tempFavorites["url"][0].element?.text)!, team: team, context: fetchedResultsController.managedObjectContext)
                
                for element in fetchedResultsController.fetchedObjects! {
                    let check = element as! FavoritesHighlights
                    
                    // check if already exist highlight by headline.
                    if check.headline!.contains(favoriteHighlight.headline!) {
                        
                        self.alreadyExist()
                        self.duplicate = true
                        // this line is deleting just the object on the stack so it doesn't
                        // show twice if the user goes to their favorites.
                        stack.context.delete(favoriteHighlight)
                        break
                    }
                }
                // if it is not a duplicate
                if !self.duplicate {
                    do {
                        try stack.saveContext()
                    } catch {
                        print("Error Saving Highlight")
                    }
                    print("Adding Highlight")
                    print(favoriteHighlight)
                }
                
            } catch {
                print("Error Fetching Highlight")
            }
            
           
            
        })
        
        // Add actions then present alert
        ac.addAction(no)
        ac.addAction(add)
        present(ac, animated: true, completion: nil)
    }
    
    @objc func alreadyExist() {
        let ac = UIAlertController(title: "Already in Favorites", message: "This Highlight is already in your favorites!", preferredStyle: .alert)
        
        // Configure the alert actions
        let dismiss = UIAlertAction(title: "Dismiss", style: .default, handler: {
            action in
            self.duplicate = false
            print("Highlight exist already in favorites")
        })
      
        
        // Add actions then present alert
        ac.addAction(dismiss)
        present(ac, animated: true, completion: nil)
    }
    
    @objc func internetConnection() {
        let ac = UIAlertController(title: "Check Internet Connection", message: "The Internet connection appears to be offline.", preferredStyle: .alert)
        
        // Configure the alert actions
        let dismiss = UIAlertAction(title: "Dismiss", style: .default, handler: {
            action in
            self.activity.stopAnimating()
            self.activity.isHidden = true
            self.duplicate = false
            print("The Internet connection appears to be offline.")
        })
        
        
        // Add actions then present alert
        ac.addAction(dismiss)
        present(ac, animated: true, completion: nil)
    }
    
}

