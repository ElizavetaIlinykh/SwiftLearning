import SwiftUI
import Combine

struct ContentView: View {
    var body: some View {
        MainTabView()
    }
}

struct Lesson: Identifiable, Hashable {
    let id: Int
    let title: String
    let duration: String
    let theoryTitle: String
    let theoryText: String
    let codeExample: String
    let explanation: String
    let quiz: QuizQuestion
    let challenge: CodeChallenge
}

struct QuizQuestion: Hashable {
    let question: String
    let answers: [String]
    let correctAnswerIndex: Int
    let explanation: String
}

struct CodeChallenge: Hashable {
    let title: String
    let description: String
    let codeTemplate: String
    let options: [String]
    let correctAnswerIndex: Int
    let completedCode: String
}

struct MainTabView: View {
    var body: some View {
        TabView {
            LearnView()
                .tabItem {
                    Label("Learn", systemImage: "book.fill")
                }

            PracticeView()
                .tabItem {
                    Label("Practice", systemImage: "chevron.left.forwardslash.chevron.right")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(LearningProgressStore())
}
