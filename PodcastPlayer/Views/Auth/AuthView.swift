//
//  AuthView.swift
//  PodcastPlayer
//
//  Created by Alex Yatsenko on 20.08.2021.
//

import Foundation
import SwiftUI

struct AuthView: View {
  
  @EnvironmentObject var authManager: AuthManager
  
  @State private var errorText: String?
  @State private var centerLogo = true
  
  var body: some View {
      VStack(spacing: 80) {
        if centerLogo { Spacer().layoutPriority(1) }
        Image("logo").resizable().frame(width: 100, height: 100).padding()
        if !centerLogo {
          Spacer().frame(height: 30)
          Button {
            authManager.login()
          } label: {
          Text("Войти ВКонтакте")
            .opacity(centerLogo ? 0 : 1)
            .foregroundColor(.white)
            .padding()
            .background(Color.accentColor)
            .transition(.move(edge: .bottom).combined(with: .opacity))
          }
        }
        if centerLogo { Spacer().layoutPriority(1) }
      }
      .onReceive(authManager.errorText) { value in
        errorText = value
      }
      .alert(isPresented: .constant(errorText != nil), content: {
        Alert(title: Text(errorText ?? ""),
              dismissButton: .default(Text("OK"), action: { errorText = nil })
        )
      })
      .onAppear(perform: {
        if centerLogo {
          withAnimation(.easeInOut) { centerLogo = false }
        }
      })
    
  }
  
}

struct AuthView_Previews: PreviewProvider {
  static var previews: some View {
    AuthView()
  }
}
