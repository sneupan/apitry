//
//  APICall.swift
//  apitry
//
//  Created by Saskriti Neupane  on 11/6/23.
//

import Foundation

struct ActivityData: Codable {
    let activityOffering: ActivityOffering
    let term: Term
    let scheduleNames: [String]
    let activitySeatCount: ActivitySeatCount
}

struct ActivityOffering: Codable {
    let name: String
    let instructors: [Instructor]
}

struct Instructor: Codable {
    let personName: String
}

struct Term: Codable {
    let name: String
}

struct ActivitySeatCount: Codable {
    let total: Int
    let used: Int
    let available: Int
}

func performAPICall() async throws -> [ActivityData] {
    guard let url = URL(string: "http://localhost:8080/waitlist/waitlistactivityofferings?personId=90000003&termId=kuali.atp.FA2023-2024") else {
        throw URLError(.badURL)
    }

    let (data, response) = try await URLSession.shared.data(from: url)
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw URLError(.badServerResponse)
    }

    let apiResponse = try JSONDecoder().decode([ActivityData].self, from: data)
    return apiResponse
}
