//
//  ContentView.swift
//  apple_lab12_pract03_SwiftData
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Teacher.lastName) private var teachers: [Teacher]

    @State private var searchText = ""
    @State private var showingAddForm = false
    @State private var teacherToEdit: Teacher?

    // Lista filtrada según lo que se escribe en el buscador
    private var filteredTeachers: [Teacher] {
        let query = searchText.trimmingCharacters(in: .whitespaces)
        guard !query.isEmpty else { return teachers }
        return teachers.filter {
            $0.firstName.localizedCaseInsensitiveContains(query) ||
            $0.lastName.localizedCaseInsensitiveContains(query) ||
            $0.email.localizedCaseInsensitiveContains(query) ||
            $0.specialty.localizedCaseInsensitiveContains(query)
        }
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
                Text("Teachers")
                    .font(.largeTitle.bold())
                    .padding(.horizontal)

                searchBar

                List {
                    ForEach(filteredTeachers) { teacher in
                        Button {
                            teacherToEdit = teacher
                        } label: {
                            TeacherRow(teacher: teacher)
                        }
                        .buttonStyle(.plain)
                    }
                    .onDelete(perform: deleteTeachers)
                }
                .listStyle(.plain)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddForm = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddForm) {
                TeacherFormView(teacher: nil)
            }
            .sheet(item: $teacherToEdit) { teacher in
                TeacherFormView(teacher: teacher)
            }
        }
    }

    private var searchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)

            TextField("Search teachers...", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()

            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal)
    }

    private func deleteTeachers(at offsets: IndexSet) {
        // Se guardan primero los docentes a borrar, porque la lista cambia al eliminar
        let teachersToDelete = offsets.map { filteredTeachers[$0] }
        withAnimation {
            for teacher in teachersToDelete {
                modelContext.delete(teacher)
            }
        }
    }
}

// Fila de cada docente en la lista
struct TeacherRow: View {
    let teacher: Teacher

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(teacher.fullName)
                .font(.headline)
            Text(teacher.specialty)
                .font(.subheadline)
                .foregroundStyle(.blue)
            Text(teacher.email)
                .font(.caption)
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Teacher.self, inMemory: true)
}
