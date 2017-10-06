//
//  PlayerProfile+CoreDataClass.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/29/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//
//

import Foundation
import CoreData

@objc(PlayerProfile)
public class PlayerProfile: NSManagedObject {

    
    enum SavedGameSortCriteria{
        
        case DateSavedAscending
        case DateSavedDescending
        
        
        typealias SortingClosure = ((SavedGame, SavedGame) -> Bool)
        
        
        func getSortingClosureName() -> String{
            switch self {
            case .DateSavedAscending:
                return "Date Saved (From Earliest)"
            case .DateSavedDescending:
                return "Date Saved (From Most Recent)"
            default:
                break
                
            }
        }
        
        
        func getSortingClosure() -> SortingClosure{
            
            switch self {
            case .DateSavedAscending:
                return {
                    
                    g1, g2 in
                    
                    return (g1.date! as Date) < (g2.date! as Date)
                }
            case .DateSavedDescending:
                return {
                    g1, g2 in
                    
                    return (g1.date! as Date) > (g2.date! as Date)
                }
            }
        }
        
    }
    
    enum GameStatSortCriteria{
    
        case GameLevelsAscending
        case GameLevelsDescending
        case GameSessionDateAscending
        case GameSessionDateDescending
        case IncreasingTotalZombieKills
        case DecreasingTotalZombieKills
        case IncreasingTotalCollectibles
        case DecreasingTotalCollectibles
        case IncreasingCollectibleValue
        case DecreasingCollectibleValue
        case IncreasingMoney
        case DecreasingMoney
        
        static let AllSortingCriteria: [GameStatSortCriteria] = [
            .GameLevelsAscending,
            .GameLevelsDescending,
            .GameSessionDateAscending,
            .GameSessionDateDescending,
            .IncreasingTotalZombieKills,
            .DecreasingTotalZombieKills,
            .IncreasingTotalCollectibles,
            .DecreasingTotalCollectibles,
            .IncreasingCollectibleValue,
            .DecreasingCollectibleValue,
            .IncreasingMoney,
            .DecreasingMoney
        ]
        
        typealias SortingClosure = ((GameLevelStatReview, GameLevelStatReview) -> Bool)
        
        
        func getSortingClosureName() -> String{
            switch self {
            case .GameLevelsAscending:
                return "Game Level (Increasing)"
            case .GameLevelsDescending:
                return "Game Level (Decreasing)"
            case .GameSessionDateAscending:
                return "Date of Game Session (Starting from Oldest)"
            case .GameSessionDateDescending:
                return "Date of Game Session (Starting from Most Recent)"
            case .IncreasingTotalZombieKills:
                return "Total Zombie Kills (Increasing)"
            case .DecreasingTotalZombieKills:
                return "Total Zombie Kills (Decreasing)"
            case .IncreasingTotalCollectibles:
                return "Total Number of Collectibles (Increasing)"
            case .DecreasingTotalCollectibles:
                return "Total Number of Collectibles (Decreasing)"
            case .IncreasingCollectibleValue:
                return "Total Value of Collectibles (Increasing)"
            case .DecreasingCollectibleValue:
                return "Total Value of Collectibles (Decreasing)"
            case .IncreasingMoney:
                return "Total Money (Increasing)"
            case .DecreasingMoney:
                return "Total Money (Decreasing)"
            }
        }
        
        
        
        func getSortingClosure() -> SortingClosure{
            
            switch self {
            case .DecreasingTotalCollectibles:
                return {
                    
                    stat1, stat2 in
                    
                    return stat1.totalNumberOfCollectibles > stat2.totalNumberOfCollectibles
                }
            case .IncreasingTotalCollectibles:
                return {
                    stat1, stat2 in
                    
                    return stat1.totalNumberOfCollectibles < stat2.totalNumberOfCollectibles
                }
            case .IncreasingCollectibleValue:
                return {
                    stat1, stat2 in
                    
                    return stat1.totalValueOfCollectibles < stat2.totalValueOfCollectibles
                }
            case .DecreasingCollectibleValue:
                return {
                    stat1, stat2 in
                    
                    return stat1.totalValueOfCollectibles > stat2.totalValueOfCollectibles
                }
            case .IncreasingTotalZombieKills:
                return {
                    stat1, stat2 in
                    
                    return stat1.numberOfZombiesKilled < stat2.numberOfZombiesKilled
                }
            case .DecreasingTotalZombieKills:
                return {
                    stat1, stat2 in
                    
                    return stat1.numberOfZombiesKilled > stat2.numberOfZombiesKilled
                }
            case .GameLevelsAscending:
                return {
                    stat1, stat2 in
                    
                    return stat1.gameLevel < stat2.gameLevel
                }
            case .GameLevelsDescending:
                return {
                    stat1, stat2 in
                    
                    return stat1.gameLevel > stat2.gameLevel
                }
            case .GameSessionDateAscending:
                return {
                    stat1, stat2 in
                    
                    return (stat1.date! as Date) < (stat2.date! as Date)
                }
            case .GameSessionDateDescending:
                return {
                    stat1, stat2 in
                    
                    return (stat1.date! as Date) > (stat2.date! as Date)
                }
            case .IncreasingMoney:
                return {
                    stat1, stat2 in
                    
                    return stat1.totalMoney < stat2.totalMoney
                }
            case .DecreasingMoney:
                return {
                    stat1, stat2 in
                    
                    return stat1.totalMoney > stat2.totalMoney
                }
          
            }
        }
    
    }
    
    func getFormattedDateString() -> String{
        
        guard let date = self.dateCreated as Date? else {
            return "No Date Recorded"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .medium
        
        return dateFormatter.string(from: date)
    }
    
    
    //MARK: SavedGame Helper Functions

    /** Helper functions for Saved Games - aggregation operations **/

    func getSavedGames(sortedBy sortingCriterion: SavedGameSortCriteria = .DateSavedAscending) -> [SavedGame]?{
        
        guard let savedGames = self.savedGames else { return nil }
        
        guard let savedGamesArray = savedGames.allObjects as? [SavedGame] else { return nil }

        
        return savedGamesArray.sorted(by:sortingCriterion.getSortingClosure())
    }
    
    
    //MARK: GameLevelStatReview Helper Functions
    
    
    func hasCompletedGameLevel(gameLevel: GameLevel) -> Bool{
        
        var completedGameLevels = Set<GameLevel>()
        
        guard let gameStats = getPlayerProfileGameStats(sortedBy: .GameLevelsAscending) else { return false }
        
        
        print("Checking completed game levels for player...")

        for gameLevel in gameStats{
            print("The player has completed Level \(Int(gameLevel.gameLevel))")
            
            let completedGameLevel = GameLevel(rawValue: Int(gameLevel.gameLevel))!
            completedGameLevels.insert(completedGameLevel)
            
        }
        
        return completedGameLevels.contains(gameLevel)
        
    }
    
    func getPlayerProfileGameStats(sortedBy sortingCriterion: GameStatSortCriteria) -> [GameLevelStatReview]?{
        
        guard let gameStats = self.gameSessions else { return nil }
        
        guard let gameStatsArray = gameStats.allObjects as? [GameLevelStatReview] else { return nil }
        
        
        return gameStatsArray.sorted(by: sortingCriterion.getSortingClosure())
        
    }
    
    
    /** Helper functions for Game Session Statistics  - aggregation operations **/
    
    func getTotalZombieKillsForAllGameSessions() -> Int{
        
        guard let gameLevelStatReviews = getPlayerProfileGameStats(sortedBy: .IncreasingTotalZombieKills) else { return 0 }
        
        return gameLevelStatReviews.map({ return Int($0.numberOfZombiesKilled) }).reduce(0, { $0 + $1})
    }
    
    func getTotalNumberOfCollectiblesForAllGameSessions() -> Int{
        
        guard let gameLevelStatReviews = getPlayerProfileGameStats(sortedBy: .IncreasingTotalZombieKills) else { return 0 }
        
        return gameLevelStatReviews.map({Int($0.totalNumberOfCollectibles)}).reduce(0){$0 + $1}
    }
    
    func getTotalValueOfAllCollectiblesForAllGameSessions() -> Double{
        
        guard let gameLevelStatReviews = getPlayerProfileGameStats(sortedBy: .IncreasingTotalZombieKills) else { return 0 }
        
        return gameLevelStatReviews.map({Double($0.totalValueOfCollectibles)}).reduce(0){$0 + $1}
    }
    
    func getTotalValueOfMoneyForAllGameSessions() -> Double{
        
        guard let gameLevelStatReviews = getPlayerProfileGameStats(sortedBy: .IncreasingTotalZombieKills) else { return 0 }
        
        return gameLevelStatReviews.map({Double($0.totalMoney)}).reduce(0){$0 + $1}
    }
    
    
}
