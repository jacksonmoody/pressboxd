//
//  Models.swift
//  pressboxd
//
//  Created by Jackson Moody on 6/22/24.
//

import Foundation

struct Profile: Encodable, Decodable {
    let id: UUID
    let username: String?
    let fullName: String?
    let bio: String?
    let profileURL: String?
    let onboarded: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case fullName = "full_name"
        case bio
        case profileURL = "profile_url"
        case onboarded
    }
}

struct Team: Encodable, Decodable, Hashable, Identifiable {
    let id: UUID
    let sport: String?
    let league: String?
    let teamName: String
    let location: String?
    let arenaStadium: String?
    let coach: String?
    let generalManager: String?
    let descriptiveText: String?
    let logo: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case sport
        case league
        case teamName = "team_name"
        case location
        case arenaStadium = "arena_stadium"
        case coach
        case generalManager = "general_manager"
        case descriptiveText = "descriptive_text"
        case logo
    }
}

struct Game: Encodable, Decodable, Hashable, Identifiable {
    let id: UUID
    let sport: String?
    let league: String?
    let timeZone: String?
    let date: String?
    let startTime: String?
    let gameName: String?
    let homeTeam: Team?
    let awayTeam: Team?
    let featureTag: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case sport
        case league
        case timeZone = "time_zone"
        case date
        case startTime = "start_time"
        case gameName = "game_name"
        case homeTeam = "home_team"
        case awayTeam = "away_team"
        case featureTag = "feature_tag"
    }
}

struct Review: Encodable, Decodable {
    let id: UUID
    let userId: UUID?
    let game: UUID?
    let rating: Int
    let liked: Bool?
    let review: String?
    let rootingFor: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case game
        case rating
        case liked
        case review
        case rootingFor = "rooting_for"
    }
}
