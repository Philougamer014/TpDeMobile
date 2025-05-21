struct QuestAnnotationView: View {
    let quest: Quest
    let isTapped: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack {
                Image(systemName: isTapped ? "star.circle" : "star.circle.fill")
                    .font(.title)
                    .foregroundColor(isTapped ? .gray : .orange)
                    .scaleEffect(isTapped ? 1.3 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: isTapped)
                Text(quest.description)
                    .font(.caption)
            }
        }
    }
}
