//
//  ProfileImage.swift
//  pressboxd
//
//  Created by Jackson Moody on 6/23/24.
//

import SwiftUI

struct ProfileImage: Transferable, Equatable {
  let image: Image
  let data: Data

  static var transferRepresentation: some TransferRepresentation {
    DataRepresentation(importedContentType: .image) { data in
      guard let image = ProfileImage(data: data) else {
        throw TransferError.importFailed
      }

      return image
    }
  }
}

extension ProfileImage {
  init?(data: Data) {
    guard let uiImage = UIImage(data: data) else {
      return nil
    }

    let image = Image(uiImage: uiImage)
    self.init(image: image, data: data)
  }
}

enum TransferError: Error {
  case importFailed
}
