//
//  ContentView.swift
//  apitry
//
//  Created by Saskriti Neupane  on 11/6/23.
//

import SwiftUI

struct ContentView: View {
    @State private var activities: [ActivityData] = []
    @State private var showingAlert = false
    @State private var errorMessage = ""

    var body: some View {
        NavigationView {
            List(activities, id: \.activityOffering.name) { activity in
                Section(header: Text(activity.activityOffering.name)) {
                    ForEach(activity.scheduleNames, id: \.self) { schedule in
                        Text(schedule)
                    }
                }
                Section(header: Text("Instructors:")) {
                    ForEach(activity.activityOffering.instructors, id: \.personName) { instructor in
                        Text(instructor.personName)
                    }
                }
            }
            .navigationTitle("Class Schedules")
        }
        .onAppear {
            fetchData()
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }

    func fetchData() {
        Task {
            do {
                let activitiesData = try await performAPICall()
                self.activities = activitiesData
            } catch {
                self.errorMessage = error.localizedDescription
                self.showingAlert = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
