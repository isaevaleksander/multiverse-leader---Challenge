//
//  GroupDetailView.swift
//  Multiverse
//
//  Created by Alex Isaev on 08.04.2021.
//

import SwiftUI

struct GroupDetailView: View {
    
    @StateObject var viewModel: GroupDetailViewModel = GroupDetailViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var currentGroup: Group?
    
    var body: some View {
        NavigationView {
        ZStack {
            if viewModel.showLoadingIndicator {
                VStack(spacing: 20) {
                    ActivityIndicatorView(isAnimating: $viewModel.showLoadingIndicator)
                    Text("Loading music")
                }
            }
            VStack {
                if viewModel.chechUserAdmin() {
                    VStack(spacing: 40) {
                        Text("You are the group administrator")
                        HStack(spacing: 20) {
                            Button {
                                viewModel.pauseMusic()
                            } label: {
                                Image(systemName: "pause")
                            }.frame(width: 40, height: 40)
                            Button {
                                viewModel.playMusic()
                            } label: {
                                Image(systemName: "play")
                            }.frame(width: 40, height: 40)
                            Button {
                                viewModel.stopMusic()
                            } label: {
                                Image(systemName: "stop")
                            }.frame(width: 40, height: 40)
                        }
                        HStack {
                            Image(systemName: "person")
                            Text("\(viewModel.currentGroup?.users?.count ?? 0)")
                        }
                    }
                } else {
                    VStack(spacing: 40) {
                        Text("You do not have permission to control music")
                        HStack(spacing: 20) {
                            
                            Image(systemName: "pause")
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: "play")
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: "stop")
                                .frame(width: 40, height: 40)
                        }
                        HStack {
                            Image(systemName: "person")
                            Text("\(viewModel.currentGroup?.users?.count ?? 0)")
                        }
                    }
                }
            }.navigationTitle("\(viewModel.currentGroup?.title ?? "")")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .blur(radius: viewModel.showLoadingIndicator ? 3.0 : 0.0)
        }
        }
        .onAppear(perform: {
            viewModel.addedUserForGroup(group: currentGroup)
            viewModel.setPlayer()
        })
        .onDisappear(perform: {
            viewModel.removeUserForGroup(documentID: currentGroup?.documentID)
        })
    }
}
