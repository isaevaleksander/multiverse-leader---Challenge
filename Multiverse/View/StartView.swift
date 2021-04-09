//
//  StartView.swift
//  Multiverse
//
//  Created by Alex Isaev on 09.04.2021.
//

import SwiftUI

struct StartView: View {
    
    @StateObject var viewRouter: ViewRouter
    
    var body: some View {
        switch viewRouter.currentPage {
        case .registerView:
            RegisterView(viewRouter: viewRouter)
        case .groupView:
            GroupView(viewRouter: viewRouter)
        }
    }
}
