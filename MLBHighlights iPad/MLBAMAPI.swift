//
//  MLBAMAPI.swift
//  MLBHighlights iPad
//
//  Created by Ramon Geronimo on 12/25/17.
//  Copyright © 2017 Ramon Geronimo. All rights reserved.
//

import Foundation
import UIKit
import AVKit


class MLBAMAPI: NSObject, XMLParserDelegate {
    // MARK: Properties
    var session = URLSession.shared
    
    

    // MARK: Initializers
    override init() {
        
        super.init()

    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> MLBAMAPI {
        
        struct Singleton {
            static var sharedInstance = MLBAMAPI()
        }
        
        return Singleton.sharedInstance
    }
    
    // MARK: Tasks
    func getHightlights(vc : ViewController!) -> URLSessionTask {
        
        var session = URLSession.shared
        
        
        
        /* 1. Set the parameters */
        var components = URLComponents()
        components.scheme = "http"
        components.host = "gd2.mlb.com"
        
        let yearURL = "/year_\(vc.year)"
        let monthURL = "/month_\(vc.month)"
        let dayURL = "/day_\(vc.day)"
        let media = "/media/highlights.xml"
        
        
        components.path = "/components/game/mlb" + yearURL + monthURL + dayURL + media
        
        
        print(components.url!)
        
        /* 2/3. Build the URL, Configure the request */
        let request = URLRequest(url:components.url!)
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            // if an error occurs, print it and re-enable the UI
            func displayError(_ error: String) {
                print(error)
                performUIUpdatesOnMain {
                    print("error")
                }
            }
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                vc.internetConnection()
                displayError("There was an error with your request: \(String(describing: error))")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                performUIUpdatesOnMain {
                    vc.activity.stopAnimating()
                    vc.activity.isHidden = true
                    performUIUpdatesOnMain {
                        vc.activity.stopAnimating()
                        vc.activity.isHidden = true
                    }
                }
                displayError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                displayError("No data was returned by the request!")
                return
            }
            
            /* 5. Parse the data */
            
            
            let parser =  XMLParser(data: data)
            parser.delegate = self as XMLParserDelegate
            parser.parse()
            
            /* 6. Use the data! */
            /* Display all the hightlights randomly on a especific day */
            
            let xml = SWXMLHash.parse(data)
            var temp = [String]()
            var tempFav = [XMLIndexer]()
            if !xml["games"]["highlights"].all.isEmpty {
                
                for highlight in xml["games"]["highlights"].all {
                    vc.highlights.append(highlight)
                    for media in highlight["media"].all {
                        vc.media.append(media)
                        for url in media["url"].all {
                            if let url = url.element?.text {
                                temp.append(url)
                                tempFav.append(media)
                                vc.mediaURLS = temp.flatMap {$0}
                                vc.favorites = tempFav.flatMap {$0}
                                
                            }
                            
                        }
                    }
                }
                //            print(temp.count)
                //            print(self.mediaURLS.count)
                let random = Int(arc4random_uniform(UInt32(vc.mediaURLS.count)))
                vc.randomURL = vc.mediaURLS[random]
                vc.tempFavorites = vc.favorites[random]
                //            print(self.randomURL)
                let url = URL(string: vc.randomURL)
                performUIUpdatesOnMain {
                    let player = AVPlayer(url: url!)
                    vc.playerViewController.player = player
                    vc.present(vc.playerViewController, animated: true) {
//                        vc.playerViewController.videoGravity = AVLayerVideoGravity.resizeAspectFill.rawValue
                        vc.playerViewController.player!.play()
                        
                    }
                    
                }
            } else {
                performUIUpdatesOnMain {
                    
                    vc.homeTeamRuns.isHidden = true
                    vc.awayTeamRuns.isHidden = true
                    vc.home.isHidden = false
                    vc.away.isHidden = false
                    vc.away.image = UIImage(named: "nogame")
                    vc.home.image = UIImage(named: "nogame")
                }
            }
            
            performUIUpdatesOnMain {
                vc.activity.stopAnimating()
                vc.activity.isHidden = true
            }
            
        }
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    func homeTeamHightlights(vc : ViewController!) -> URLSessionTask {
        
        var session = URLSession.shared
        
        /* 1. Set the parameters */
        var components = URLComponents()
        components.scheme = "http"
        components.host = "gd2.mlb.com"
        
        let yearURL = "/year_\(vc.year)"
        let monthURL = "/month_\(vc.month)"
        let dayURL = "/day_\(vc.day)"
        
        let teams = vc.homeTeamHighlights
        let media = "/media/instadium.xml"
        
        components.path = "/components/game/mlb" + yearURL + monthURL + dayURL + teams + media
        
        
        print(components.url!)
        
        /* 2/3. Build the URL, Configure the request */
        let request = URLRequest(url:components.url!)
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            // if an error occurs, print it and re-enable the UI
            func displayError(_ error: String) {
                print(error)
                performUIUpdatesOnMain {
                    print("error")
                }
            }
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                vc.internetConnection()
                displayError("There was an error with your request: \(String(describing: error))")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                performUIUpdatesOnMain {
                    vc.activity.stopAnimating()
                    vc.activity.isHidden = true
                    
                }
                displayError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                displayError("No data was returned by the request!")
                return
            }
            
            /* 5. Parse the data */
            
            
            let parser =  XMLParser(data: data)
            parser.delegate = self as XMLParserDelegate
            parser.parse()
            
            /* 6. Use the data! */
            /* Display all the hightlights of home team randomly on a especific day */
            
            let xml = SWXMLHash.parse(data)
            var temp = [String]()
            var tempFav = [XMLIndexer]()
            for highlights in xml["highlights"].all {
                for media in highlights["media"].all {
                    for url in media["url"].all {
                        if let url = url.element?.text {
                            temp.append(url)
                            tempFav.append(media)
                            vc.homeTeamURL = temp.flatMap {$0}
                            vc.favorites = tempFav.flatMap {$0}
                        }
                    }
                }
            }
            
            
            let random = Int(arc4random_uniform(UInt32(vc.homeTeamURL.count)))
            vc.randomURL = vc.homeTeamURL[random]
            
            vc.tempFavorites = vc.favorites[random]
            
            
            let url = URL(string: vc.randomURL)
            performUIUpdatesOnMain {
                let player = AVPlayer(url: url!)
                vc.playerViewController.player = player
                vc.present(vc.playerViewController, animated: true) {
//                    vc.playerViewController.videoGravity = AVLayerVideoGravity.resizeAspectFill.rawValue
                    vc.playerViewController.player!.play()
                    
                }
                
                
            }
            performUIUpdatesOnMain {
                vc.activity.stopAnimating()
                vc.activity.isHidden = true
            }
            
            
            
            
            
        }
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    func getScore(year: String, month: String, day: String, teamCode: String, vc : ViewController!) -> URLSessionTask {
        
        var session = URLSession.shared
        
        
        /* 1. Set the parameters */
        var components = URLComponents()
        components.scheme = "http"
        components.host = "gd2.mlb.com"
        
        let yearURL = "/year_\(year)"
        let monthURL = "/month_\(month)"
        let dayURL = "/day_\(day)"
        let scoreboard = "/miniscoreboard.json"
        
        
        components.path = "/components/game/mlb" + yearURL + monthURL + dayURL + scoreboard
        
        
        print(components.url!)
        
        /* 2/3. Build the URL, Configure the request */
        let request = URLRequest(url:components.url!)
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            // if an error occurs, print it and re-enable the UI
            func displayError(_ error: String) {
                print(error)
                performUIUpdatesOnMain {
                    print("error")
                }
            }
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                vc.internetConnection()
                displayError("There was an error with your request: \(String(describing: error))")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                performUIUpdatesOnMain {
                    vc.activity.stopAnimating()
                    vc.activity.isHidden = true
                   
                    vc.home.isHidden = false
                    vc.away.isHidden = false
                    vc.home.image = UIImage(named: "nogame")
                    vc.away.image = UIImage(named: "nogame")

                }
                displayError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                displayError("No data was returned by the request!")
                return
            }
            
            /* 5. Parse the data */
            let parsedResult: [String:AnyObject]!
            var availableGames = [[String:Any]]()
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                let data = parsedResult["data"] as! [String:Any]
                let games = data["games"] as! [String:Any]
                if games["game"] != nil {
                    let game = games["game"]!
                    
                    if game is [String:Any] {
                        let game = games["game"] as! [String:Any]
                        
                        let obj = [
                            "homeTeam" : game["home_team_name"]!,
                            "homeAbbrev": game["home_name_abbrev"]!,
                            "homeTeamRuns": game["home_team_runs"]!,
                            "homeCode": game["home_code"]!,
                            "awayTeam" : game["away_team_name"]!,
                            "awayAbbrev": game["away_name_abbrev"]!,
                            "awayTeamRuns": game["away_team_runs"]!,
                            "awayCode": game["away_code"]!,
                            ]
                        
                        availableGames.append(obj)
                    } else if game is [[String:Any]] {
                        let game = games["game"] as! [[String:Any]]
                        var obj = [String:Any]()
                        for i in game {
                            
                            if i["home_team_runs"] != nil {
                                obj = [
                                    "homeTeam" : i["home_team_name"]!,
                                    "homeAbbrev": i["home_name_abbrev"]!,
                                    "homeTeamRuns": i["home_team_runs"]!,
                                    "homeCode": i["home_code"]!,
                                    "awayTeam" : i["away_team_name"]!,
                                    "awayAbbrev": i["away_name_abbrev"]!,
                                    "awayTeamRuns": i["away_team_runs"]!,
                                    "awayCode": i["away_code"]!,
                                ]
                            } else {
                                obj = [
                                    "homeTeam" : i["home_team_name"]!,
                                    "homeAbbrev": i["home_name_abbrev"]!,
                                    "homeTeamRuns": i["status"]!,
                                    "awayTeam" : i["away_team_name"]!,
                                    "awayAbbrev": i["away_name_abbrev"]!,
                                    "awayTeamRuns": i["status"]!,
                                    
                                ]
                            }
                            
                            
                            availableGames.append(obj)
                        }
                        
                    }
                }
                
            } catch {
                displayError("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            /* 6. Use the data! */
            var awayImageName = ""
            var homeImageName = ""
            for games in availableGames {
                
                /* I need this to build the url componets for the teams highlights */
                
                if games["homeCode"] != nil {
                    if games["homeCode"]! as! String == teamCode {
                        
                        vc.homeTeamHighlights = "/gid_\(year)_\(month)_\(day)_\(games["awayCode"]!)mlb_\(teamCode)mlb_1"
                        
                        performUIUpdatesOnMain {
                            
                            awayImageName = games["awayTeam"]! as! String
                            homeImageName = games["homeTeam"]! as! String
                            vc.homeTeamRuns.text? = "Runs: \(games["homeTeamRuns"]!)"
                            vc.awayTeamRuns.text? = "Runs: \(games["awayTeamRuns"]!)"
                            vc.away.image = UIImage(named: awayImageName.lowercased())
                            vc.home.image = UIImage(named: homeImageName.lowercased())
                            
                            // checks if team played with a minor league team and add MiLB logo
                            if vc.home.image == nil  {
                                vc.home.image = UIImage(named: "milb")
                            } else if vc.away.image == nil {
                                vc.away.image = UIImage(named: "milb")
                            }
                            
                            vc.temp = true
                        }
                        print("=============> home")
                        print("=============> \(vc.homeTeamHighlights)")
                    } else if games["awayCode"]! as! String == teamCode {
                        
                        vc.homeTeamHighlights = "/gid_\(year)_\(month)_\(day)_\(teamCode)mlb_\(games["homeCode"]!)mlb_1"
                        
                        performUIUpdatesOnMain {
                            
                            awayImageName = games["awayTeam"]! as! String
                            homeImageName = games["homeTeam"]! as! String
                            vc.homeTeamRuns.text? = "Runs: \(games["homeTeamRuns"]!)"
                            vc.awayTeamRuns.text? = "Runs: \(games["awayTeamRuns"]!)"
                            vc.away.image = UIImage(named: awayImageName.lowercased())
                            vc.home.image = UIImage(named: homeImageName.lowercased())
                            
                            // checks if team played with a minor league team and add MiLB logo
                            if vc.home.image == nil  {
                                vc.home.image = UIImage(named: "milb")
                            } else if vc.away.image == nil {
                                vc.away.image = UIImage(named: "milb")
                            }
                            
                            vc.temp = true
                        }
                        print("=============> away")
                        print("=============> \(vc.homeTeamHighlights)")
                    }
                }
            }
            
            if teamCode == "all" {
                print("working 1")
                performUIUpdatesOnMain {
                    if !vc.temp {
                        
                        self.getHightlights(vc: vc)
                        vc.home.isHidden = true
                        vc.away.isHidden = true
                        vc.homeTeamRuns.isHidden = true
                        vc.awayTeamRuns.isHidden = true
                        
                    } else {
                        
                        vc.homeTeamRuns.isHidden = true
                        vc.awayTeamRuns.isHidden = true
                        vc.home.isHidden = false
                        vc.away.isHidden = false
                        vc.away.image = UIImage(named: "nogame")
                        vc.home.image = UIImage(named: "nogame")
                    }
                    
                }
            } else if teamCode == "fav" {
                performUIUpdatesOnMain {
                    vc.performSegue(withIdentifier: "fav", sender: self)
                }
                
            } else {
                
                performUIUpdatesOnMain {
                    if vc.temp {
                        self.homeTeamHightlights(vc: vc)
                        
                        vc.home.isHidden = false
                        vc.away.isHidden = false
                        vc.homeTeamRuns.isHidden = false
                        vc.awayTeamRuns.isHidden = false
                        vc.temp = false
                    } else {
                        
                        vc.homeTeamRuns.isHidden = true
                        vc.awayTeamRuns.isHidden = true
                        vc.home.isHidden = false
                        vc.away.isHidden = false
                        vc.away.image = UIImage(named: "nogame")
                        vc.home.image = UIImage(named: "nogame")
                    }
                    
                }
            }
            
            
        }
        /* 7. Start the request */
        task.resume()
        
        return task
    }

    
}
