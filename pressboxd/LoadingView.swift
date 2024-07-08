//
//  LoadingView.swift
//  pressboxd
//
//  Created by Jackson Moody on 6/24/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        Image("LoadingScreen").resizable().ignoresSafeArea().scaledToFill()
    }
}

#Preview {
    LoadingView()
}
