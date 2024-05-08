
//  EditActivityView.swift
//  CPM_Graphic
//
//  Created by 김형관 on 4/2/24.
//
import SwiftData
import SwiftUI
struct EditActivityView: View {
    @Binding var navigationPath: NavigationPath
    @Bindable var activity: Activity
    @State private var selectedPredecessorId: Int?
    @State private var selectedSuccessorId: Int?
    @Query var activities: [Activity]
    
    var body: some View {
        Form {
            Section(header: Text("General Information")) {
                HStack {
                    Text("ID:")
                    Spacer()
                    TextField("ID", value: $activity.id, formatter: NumberFormatter())
                }
                
                HStack {
                    Text("Name:")
                    Spacer()
                    TextField("Name", text: $activity.name)
                }
                HStack {
                    Text("Duration:")
                    Spacer()
                    TextField("Duration", value: $activity.duration, formatter: NumberFormatter())
                }
            }
            
            Section(header: Text("Predecessors")) {
                // Display a list of existing predecessors, sorted by id
                if activity.predecessors.isEmpty {
                    Text("No predecessors")
                } else {
                    ForEach(activity.predecessors.sorted(by: { $0.id < $1.id }), id: \.id) { predecessor in
                        Text(predecessor.name) // Display by name or another identifier
                    }
                    .onDelete(perform: removePredecessor)
                }
                
                // Input for adding a new predecessor
                Picker("Select New Predecessor", selection: $selectedPredecessorId) {
                    Text("None").tag(nil as Int?)
                    ForEach(activities.filter { $0.id != activity.id }, id: \.id) { activity in
                        Text("\(activity.name) (\(activity.id))").tag(activity.id as Int?)
                    }
                }
                .onChange(of: selectedPredecessorId) {
                    addPredecessor()
                }
            }

            Section(header: Text("Successors")) {
                // Display a list of existing successors, sorted by id, if any
                // Display a list of existing successors, sorted by id
                if activity.successors.isEmpty {
                    Text("No successors") // Displayed if there are no successors
                } else {
                    ForEach(activity.successors.sorted(by: { $0.id < $1.id }), id: \.id) { successor in
                        Text(successor.name) // Assuming you want to display the successor's name or use another identifier
                    }
                    .onDelete(perform: removeSuccessor)
                }

                
                Picker("Select New Successor", selection: $selectedSuccessorId) {
                    Text("None").tag(nil as Int?)
                    ForEach(activities.filter { $0.id != activity.id }, id: \.id) { activity in
                        Text("\(activity.name) (\(activity.id))").tag(activity.id as Int?)
                    }
                }
                .onChange(of: selectedSuccessorId) {
                    addSuccessor()
                }
            }


        }
        .navigationTitle("Edit Activity")
        .navigationBarItems(trailing: EditButton())
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func addPredecessor() {
        guard let newId = selectedPredecessorId,
              let newPredecessor = activities.first(where: { $0.id == newId }),
              !activity.predecessors.contains(where: { $0.id == newId })
        else { return }
        
        activity.predecessors.append(newPredecessor)
        selectedPredecessorId = nil // Reset selection
    }


    private func removePredecessor(at offsets: IndexSet) {
        activity.predecessors.remove(atOffsets: offsets)
    }


    private func addSuccessor() {
        guard let newId = selectedSuccessorId,
              let newSuccessor = activities.first(where: { $0.id == newId }),
              !activity.successors.contains(where: { $0.id == newId })
        else { return }
        
        activity.successors.append(newSuccessor)
        selectedSuccessorId = nil // Reset selection
    }

    private func removeSuccessor(at offsets: IndexSet) {
        activity.successors.remove(atOffsets: offsets)
    }

}

