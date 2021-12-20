import SwiftUI

struct PostView: View {
    let post: Post

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                AsyncImage(url: post.iconURL) { image in
                    image
                        .resizable()
                        .clipShape(Circle())
                } placeholder: {
                    Image(systemName: "applelogo")
                        .resizable()
                        .clipShape(Circle())
                        .redacted(reason: .placeholder)
                }
                .frame(width: 44, height: 44)
                VStack(alignment: .leading) {
                    Text(post.userName)
                        .font(.headline)
                    Text("just now")
                        .font(.subheadline)
                }
            }
            Text(post.content)
                .font(.body)
                .padding(.top, 8)
            HStack() {
                Image(systemName: "bubble.right")
                Spacer()
                Image(systemName: "square.and.arrow.up")
                Spacer()
                Image(systemName: "ellipsis")
            }
            .padding(.top, 8)
        }
        .padding(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.clear, lineWidth: 2)
        )
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.gray, radius: 10, x: 0, y: 0)
        )
    }
}
