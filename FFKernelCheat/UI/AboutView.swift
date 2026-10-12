import SwiftUI

struct AboutView: View {
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(colors: [.black, .indigo.opacity(0.4)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                VStack(spacing: 16) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.cyan)
                    Text("ELITE CLIENT")
                        .font(.title.bold())
                        .foregroundColor(.white)
                    Text("Dinh Duc Nam")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Text("0395109314 - 0332011756")
                        .foregroundColor(.gray)
                    Spacer()
                    Text("ELITE CLIENT")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
            }
            .navigationTitle("About")
        }
    }
}
