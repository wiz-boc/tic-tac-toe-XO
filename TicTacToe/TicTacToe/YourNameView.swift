//
//  YourNameView.swift
//  TicTacToe
//
//  Created by wizz on 1/4/24.
//

import SwiftUI

struct YourNameView: View {
    @AppStorage("yourName") var yourName = ""
    @State private var userName = ""
    var body: some View {
        VStack{
            Text("This is the name that will be associated with this device.")
            TextField("Your Name", text: $userName)
                .textFieldStyle(.roundedBorder)
            
            Button("Set") {
                yourName = userName
            }
            .buttonStyle(.borderedProminent)
            .disabled(userName.isEmpty)
            
            Image("LaunchScreen")
            Spacer()
        }
        .padding()
        .navigationTitle("Xs And Os")
        .inNavigationStack()
    }
}

#Preview {
    YourNameView()
}
