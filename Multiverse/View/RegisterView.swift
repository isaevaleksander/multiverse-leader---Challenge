//
//  ContentView.swift
//  Multiverse
//
//  Created by Alex Isaev on 07.04.2021.
//

import SwiftUI

struct RegisterView: View {
    
    @StateObject var viewModel: RegisterViewModel = RegisterViewModel()
    
    @StateObject var viewRouter: ViewRouter
    
    var body: some View {
        
        NavigationView {
            VStack {
                WelcomeText()
                TextField("Email", text: $viewModel.email)
                    .padding()
                    .background(Color.lightGreyColor)
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .keyboardType(.emailAddress)
                SecureField("Password", text: $viewModel.password)
                    .padding()
                    .background(Color.lightGreyColor)
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                Button(action: {
                    viewModel.registerUser()
                }) {
                    RegisterButtonContent()
                }
            }
        }
        .padding()
        .alert(isPresented: $viewModel.showingAlert) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("Cancel")))
        }.onReceive(viewModel.$isLoggedin, perform: { value in
            if value {
                viewRouter.currentPage = .groupView
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(viewRouter: ViewRouter())
    }
}

struct WelcomeText: View {
    var body: some View {
        return Text("Welcome!")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
    }
}

struct RegisterButtonContent: View {
    var body: some View {
        return Text("Register")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 140, height: 50)
            .background(Color.blue)
            .cornerRadius(5.0)
    }
}
