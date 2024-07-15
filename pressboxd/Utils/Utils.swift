//
//  Utils.swift
//  pressboxd
//
//  Created by Jackson Moody on 6/24/24.
//

import Foundation
import Storage

func uploadImage(profileImage:CustomImage?) async throws -> String? {
    
    guard let data = profileImage?.data else { return nil }
    
    let filePath = "\(UUID().uuidString).jpeg"
    
    try await supabase.storage
        .from("photos")
        .upload(
            path: filePath,
            file: data,
            options: FileOptions(contentType: "image/jpeg")
        )
    
    return filePath
}

func downloadImage(path: String, database:String) async throws -> CustomImage? {
    let data = try await supabase.storage.from(database).download(path: path)
    let customImage = CustomImage(data: data)
    return customImage
}

