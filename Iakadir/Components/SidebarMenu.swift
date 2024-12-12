import SwiftUI

struct SidebarMenu: View {
    @Binding var isShowing: Bool
    var onLogout: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Semi-transparent background
//                if isShowing {
//                    Color.black.opacity(0.3)
//                        .onTapGesture {
//                            isShowing = false
//                        }
//                }
                
                // Sidebar content
                HStack {
                    VStack(alignment: .leading, spacing: 20) {
                        Button(action: {
                            isShowing = false
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                                .font(.title2)
                        }
                        .padding(.top, 40)
                        
                        Spacer()
                        
                        Button(action: onLogout) {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                Text("Déconnexion")
                            }
                            .foregroundColor(.white)
                            .font(.headline)
                        }
                        
                        Spacer()
                    }
                    .frame(width: 250)
                    .padding(.horizontal)
                    .background(Color.black)
                    .offset(x: isShowing ? 0 : -260)
                    
                    Spacer()
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .offset(x: isShowing ? 0 : -geometry.size.width)
        }
        .animation(.easeInOut, value: isShowing)
    }
}

