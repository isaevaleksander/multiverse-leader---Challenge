//
//  GroupView.swift
//  Multiverse
//
//  Created by Alex Isaev on 08.04.2021.
//

import SwiftUI

struct GroupView: View {
    
    @StateObject var viewModel: GroupViewModel = GroupViewModel()
    
    @StateObject var viewRouter: ViewRouter
    
    @State private var isPresentGroupDetailView = false
    @State private var currentGroup: Group?
    @State private var showAlert: Bool = false
    
    var body: some View {
        
        NavigationView {
            List(viewModel.groups, id: \.self) { group in
                Button(action: {
                    currentGroup = group
                    isPresentGroupDetailView = true
                }) {
                    HStack {
                        Text(group.title ?? "")
                        Spacer()
                        HStack {
                            Image(systemName: "person")
                            Text("\(group.users?.count ?? 0)")
                        }
                    }
                }
            }.listStyle(PlainListStyle())
            .navigationBarTitle(Text("Groups"))
            .navigationBarItems(trailing: Button(action: {
                self.showAlert = true
            }) {
                Image(systemName: "plus")
                    .resizable()
                    .padding(6)
                    .frame(width: 24, height: 24)
                    .background(Color.blue)
                    .clipShape(Circle())
                    .foregroundColor(.white)
            })
        }
        .alert(isPresented: $showAlert, TextAlert(title: "Create group!", action: {
            if let title = $0 {
                viewModel.createGroup(title: title)
            }
        }))
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Important message"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("Ok")))
        }
        .sheet(isPresented: $isPresentGroupDetailView, content: {
            GroupDetailView(currentGroup: $currentGroup)
        })
        .onAppear(perform: {
            viewModel.getAllGroups()
        })
        .onReceive(viewModel.$isCreatedGroup, perform: { isSuccess in
            if isSuccess {
                viewModel.createdGroup(completion: {
                    currentGroup = $0
                    isPresentGroupDetailView = true
                })
            }
        })
    }
}

struct GroupView_Previews: PreviewProvider {
    static var previews: some View {
        GroupView(viewRouter: ViewRouter())
    }
}
