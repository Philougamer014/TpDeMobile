import SwiftUI
import CoreLocation

struct QuestAnnotationView: View {
    let quest: Quest
    let userLocation: CLLocationCoordinate2D
    @Binding var tappedQuestId: Int?
    @ObservedObject var questViewModel: QuestViewModel
    @ObservedObject var friendViewModel: FriendViewModel

    @State private var showFriendBox = false

    var body: some View {
        ZStack {
            Button(action: {
                tappedQuestId = quest.id

                Task {
                    await questViewModel.attemptQuestCompletion(quest: quest, userLocation: userLocation)
                    print("tentative de compléter une quête")

                    showFriendBox = true
                }
            }) {
                VStack {
                    Image(systemName: tappedQuestId == quest.id ? "star.circle" : "star.circle.fill")
                        .font(.title)
                        .foregroundColor(tappedQuestId == quest.id ? .gray : .orange)
                        .scaleEffect(tappedQuestId == quest.id ? 1.3 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: tappedQuestId == quest.id)
                    Text(quest.description)
                        .font(.caption)
                }
            }

            if showFriendBox {
                VStack(spacing: 16) {
                    Text("Do you want to be friends with")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.orange)
                    Text(quest.creatorName ?? "Unknown")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.orange)

                    HStack {
                        Button("Yes") {
                            Task {
                                if let creatorId = quest.creatorName {
                                    let friend = Friend(id: creatorId, firstName: creatorId, lastName: "", username: creatorId)
                                    await friendViewModel.addFriend(friend)
                                    print("Friend added:", creatorId)
                                }
                                showFriendBox = false
                                tappedQuestId = nil
                            }
                        }
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)

                        Button("No") {
                            showFriendBox = false
                            tappedQuestId = nil
                        }
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .padding(40)
            }
        }
    }
}
