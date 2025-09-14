
import SwiftUI

struct BottomToastView: View {
    
    let message: String
    
    init(message: String) {
        self.message = message
    }
    
    var body: some View {
        HStack() {
            Text(message)
                .font(.subheadline)
                .multilineTextAlignment(.leading)
                .foregroundColor(.black)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.30), radius: 6, y: 2)
        )
        .transition(
            .asymmetric(
                insertion: .move(edge: .bottom).combined(with: .opacity),
                removal: .move(edge: .bottom).combined(with: .opacity)
            )
        )
    }
}


#Preview {
    @Previewable @State var showToast = false
    
    Spacer()
    ZStack(alignment: .bottom) {
        BottomToastView(message: "Take a break pet the dog")
            .padding(.bottom, 20)
            .ignoresSafeArea()
            .opacity(showToast ? 1.0 : 0.0)
            .scaleEffect(showToast ? 1.0 : 0.5) 
            .onAppear {
                showToast = true
            }
    }.padding(.bottom, 5)
    
    
    
}

