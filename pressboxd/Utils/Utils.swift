//
//  Utils.swift
//  pressboxd
//
//  Created by Jackson Moody on 6/24/24.
//

import Foundation
import Storage

func uploadImage(profileImage:ProfileImage?) async throws -> String? {
    
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

func downloadImage(path: String) async throws -> ProfileImage? {
    let data = try await supabase.storage.from("photos").download(path: path)
    let profileImage = ProfileImage(data: data)
    return profileImage
}
