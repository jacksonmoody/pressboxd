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
    let following: [UUID]=[]
    let followers: [UUID]=[]
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case fullName = "full_name"
        case bio
        case profileURL = "profile_url"
        case onboarded
    }
}

struct Game: Encodable, Decodable, Hashable, Identifiable {
    let id: UUID
    let sport: String
    let league: String
    let timeZone: String
    let date: String
    let startTime: String
    let gameName: String
    let homeTeam: String
    let awayTeam: String
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

struct User: Encodable, Decodable, Hashable, Identifiable {
    let id: UUID
    let username: String?
    let fullName: String?
    let bio: String?
    let profileURL: String?
    let following: [UUID]=[]
    let followers: [UUID]=[]
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case fullName = "full_name"
        case bio
        case profileURL = "profile_url"
        case following
        case followers
    }
}

struct Review: Encodable, Decodable {
    let id: UUID
    let gameId: UUID
    
}
