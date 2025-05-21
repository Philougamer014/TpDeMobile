//
//  MapKitView.swift
//  Tp3
//
//  Created by Philippe Léonard on 2025-05-21.
//


import SwiftUI
import MapKit
import CoreLocation

struct MapKitView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var questViewModel = QuestViewModel()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 45.5017, longitude: -73.5673),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )

    var body: some View {
        NavigationView {
            ZStack {
                Map(coordinateRegion: $region, annotationItems: questViewModel.quests) { quest in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: quest.latitude, longitude: quest.longitude)) {
                        Button(action: {
                            Task {
                                await questViewModel.attemptQuestCompletion(quest: quest, userLocation: locationManager.location)
                                print("tentative de compléter un quête")
                            }
                        }) {
                            VStack {
                                Image(systemName: "star.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.orange)
                                Text(quest.description)
                                    .font(.caption)
                            }
                        }
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
            .onReceive(locationManager.$location) { newLocation in
                region.center = newLocation
            }
            .onAppear {
                Task { await questViewModel.loadQuests() }
            }
            .navigationBarTitle("Mapventure", displayMode: .inline)
        }
    }
}

