//
//  TeacherFormView.swift
//  apple_lab12_pract03_SwiftData
//

import SwiftUI
import SwiftData

struct TeacherFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    // nil = crear docente nuevo, con valor = editar ese docente
    let teacher: Teacher?

    @State private var firstName: String
    @State private var lastName: String
    @State private var email: String
    @State private var phone: String
    @State private var dateOfBirth: Date
    @State private var specialty: String
    @State private var hireDate: Date
    @State private var isActive: Bool

    init(teacher: Teacher?) {
        self.teacher = teacher
        _firstName = State(initialValue: teacher?.firstName ?? "")
        _lastName = State(initialValue: teacher?.lastName ?? "")
        _email = State(initialValue: teacher?.email ?? "")
        _phone = State(initialValue: teacher?.phone ?? "")
        _dateOfBirth = State(initialValue: teacher?.dateOfBirth ?? Date())
        _specialty = State(initialValue: teacher?.specialty ?? "")
        _hireDate = State(initialValue: teacher?.hireDate ?? Date())
        _isActive = State(initialValue: teacher?.isActive ?? true)
    }

    // Para guardar se exige al menos nombre y apellido
    private var canSave: Bool {
        !firstName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !lastName.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Personal Information") {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    TextField("Phone", text: $phone)
                        .keyboardType(.phonePad)
                    DatePicker("Date of Birth", selection: $dateOfBirth, displayedComponents: .date)
                }

                Section("Professional Information") {
                    TextField("Specialty", text: $specialty)
                    DatePicker("Hire Date", selection: $hireDate, displayedComponents: .date)
                    Toggle("Active", isOn: $isActive)
                }

                // El botón de borrar solo aparece al editar
                if teacher != nil {
                    Section {
                        Button("Delete Teacher", role: .destructive) {
                            deleteTeacher()
                        }
                    }
                }
            }
            .navigationTitle(teacher == nil ? "Add Teacher" : "Edit Teacher")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveTeacher()
                    }
                    .disabled(!canSave)
                }
            }
        }
    }

    private func saveTeacher() {
        if let teacher {
            // Editar: se actualizan los datos del docente existente
            teacher.firstName = firstName
            teacher.lastName = lastName
            teacher.email = email
            teacher.phone = phone
            teacher.dateOfBirth = dateOfBirth
            teacher.specialty = specialty
            teacher.hireDate = hireDate
            teacher.isActive = isActive
        } else {
            // Crear: se inserta un docente nuevo
            let newTeacher = Teacher(
                firstName: firstName,
                lastName: lastName,
                email: email,
                phone: phone,
                dateOfBirth: dateOfBirth,
                specialty: specialty,
                hireDate: hireDate,
                isActive: isActive
            )
            modelContext.insert(newTeacher)
        }
        dismiss()
    }

    private func deleteTeacher() {
        if let teacher {
            modelContext.delete(teacher)
        }
        dismiss()
    }
}

#Preview {
    TeacherFormView(teacher: nil)
        .modelContainer(for: Teacher.self, inMemory: true)
}
