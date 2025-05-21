import SwiftUI
import MapKit
import CoreLocation

struct MapKitView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var questViewModel = QuestViewModel()
    @StateObject private var friendViewModel = FriendViewModel()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 45.5017, longitude: -73.5673),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @State private var tappedQuestId: Int? = nil

    var body: some View {
        NavigationView {
            ZStack {
                Map(coordinateRegion: $region, annotationItems: questViewModel.quests) { quest in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: quest.latitude, longitude: quest.longitude)) {
                        QuestAnnotationView(
                            quest: quest,
                            userLocation: locationManager.location,
                            tappedQuestId: $tappedQuestId,
                            questViewModel: questViewModel,
                            friendViewModel: friendViewModel
                        )
                    }
                }
                .ignoresSafeArea()

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink(destination: CreateQuestView(currentLocation: locationManager.location)) {
                            Image(systemName: "plus")
                                .padding()
                                .background(Color.blue)
                                .clipShape(Circle())
                                .foregroundColor(.white)
                                .shadow(radius: 4)
                        }
                        .padding()
                    }
                }
            }
            .onChange(of: locationManager.location) { newLocation in
                region.center = newLocation
            }
            .onAppear {
                Task { await questViewModel.loadQuests() }
            }
            .navigationBarTitle("Mapventure", displayMode: .inline)
        }
    }
}
