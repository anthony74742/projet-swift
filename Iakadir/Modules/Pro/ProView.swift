import SwiftUI

enum SubscriptionType {
    case weekly
    case annual
}

struct ProView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedSubscription: SubscriptionType = .weekly
    
    var body: some View {
        ZStack {
            // Background
            Color.black.edgesIgnoringSafeArea(.all)
            
            // Content
            VStack(spacing: 0) {
                // Top bar
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Text("Déjà abonné ?")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(16)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                Spacer()
                
                // Logo and Title
                VStack(spacing: 16) {
                    Image("robot") // Make sure to add your robot image to assets
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .shadow(color: Color.greenBackground.opacity(0.5), radius: 20)
                    
                    Text("Iakadir ")
                        .font(.system(size: 32, weight: .bold)) +
                    Text("PRO")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.greenBackground)
                }
                .padding(.bottom, 40)
                
                // Features
                VStack(alignment: .leading, spacing: 20) {
                    FeatureRow(icon: "sparkles", text: "Access to all features")
                    FeatureRow(icon: "cpu", text: "Powered by ChatGPT-4")
                    FeatureRow(icon: "bubble.left.and.bubble.right.fill", text: "Unlimited message chat")
                    FeatureRow(icon: "doc.text.fill", text: "More details answers")
                }
                .padding(.bottom, 40)
                
                // Pricing Options
                VStack(spacing: 16) {
                    // Weekly Option
                    SubscriptionOptionView(
                        isSelected: selectedSubscription == .weekly,
                        onTap: { selectedSubscription = .weekly },
                        title: "3 jours gratuits, puis",
                        price: "$5,99 / semaine, annulable facilement"
                    )
                    
                    // Annual Option
                    SubscriptionOptionView(
                        isSelected: selectedSubscription == .annual,
                        onTap: { selectedSubscription = .annual },
                        title: "Annuel",
                        price: "$39,99 / an",
                        discount: "Économise 89%"
                    )
                }
                .padding(.bottom, 40)
                
                // Continue Button
                Button(action: {
                    print("Selected subscription: \(selectedSubscription)")
                }) {
                    Text("Continuer")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 24)
                        .background(Color.greenBackground)
                        .cornerRadius(24)
                }
                
                Spacer()
                
                // Footer
                HStack(spacing: 16) {
                    Button(action: {}) {
                        Text("Confidentialité")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    Text("|")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    
                    Button(action: {}) {
                        Text("Conditions d'utilisation")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.bottom, 20)
            }
            .padding(.horizontal)
        }
        .foregroundColor(.white)
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.greenBackground)
            
            Text(text)
                .font(.system(size: 16))
        }
    }
}

struct ProView_Previews: PreviewProvider {
    static var previews: some View {
        ProView()
    }
}

struct SubscriptionOptionView: View {
    let isSelected: Bool
    let onTap: () -> Void
    let title: String
    let price: String
    var discount: String? = nil
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    Text(price)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                if let discount = discount {
                    Text(discount)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.greenBackground)
                        .cornerRadius(12)
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(isSelected ? Color.greenBackground.opacity(0.1) : Color.white.opacity(0.05))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.greenBackground : Color.clear, lineWidth: 1)
            )
        }
    }
}

