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

enum LessonData {
    static let lessons: [Lesson] = [
        Lesson(
            id: 1,
            title: "Introduction to Swift",
            duration: "5 min",
            theoryTitle: "Welcome to Swift",
            theoryText: """
            Swift is a programming language created by Apple.

            It is used to build apps for iPhone, iPad, Mac, Apple Watch and other Apple platforms.

            Swift code is designed to be readable, safe and fast.
            """,
            codeExample: "print(\"Hello, Swift!\")",
            explanation: """
            print() displays a value in the console.

            The text inside quotation marks is a String.

            When this code runs, Swift prints:

            Hello, Swift!
            """,
            quiz: QuizQuestion(
                question: "Which function prints a value in Swift?",
                answers: ["show()", "print()", "log()", "write()"],
                correctAnswerIndex: 1,
                explanation: "Swift uses the print() function to display values in the console."
            ),
            challenge: CodeChallenge(
                title: "Complete the code",
                description: "Choose the function that prints \"Hello, Swift!\".",
                codeTemplate: "___(\"Hello, Swift!\")",
                options: ["show", "print", "write", "display"],
                correctAnswerIndex: 1,
                completedCode: "print(\"Hello, Swift!\")"
            )
        ),
        Lesson(
            id: 2,
            title: "Variables & Constants",
            duration: "5 min",
            theoryTitle: "Variables and Constants",
            theoryText: """
            Swift stores values using variables and constants.

            Use var when a value can change.

            Use let when a value should stay the same.
            """,
            codeExample: """
            var score = 10
            score = 20

            let playerName = "Alex"
            """,
            explanation: """
            score is created with var, so its value can be changed later.

            playerName is created with let, so it cannot be assigned a new value.
            """,
            quiz: QuizQuestion(
                question: "Which keyword creates a constant in Swift?",
                answers: ["var", "let", "func", "const"],
                correctAnswerIndex: 1,
                explanation: "Use let when a value should not change after it is created."
            ),
            challenge: CodeChallenge(
                title: "Complete the code",
                description: "Create a constant called language containing \"Swift\".",
                codeTemplate: "___ language = \"Swift\"",
                options: ["var", "let", "func", "String"],
                correctAnswerIndex: 1,
                completedCode: "let language = \"Swift\""
            )
        ),
        Lesson(
            id: 3,
            title: "Data Types",
            duration: "5 min",
            theoryTitle: "Common Data Types",
            theoryText: """
            Every value in Swift has a type.

            Some of the most common types are String, Int, Double and Bool.

            Swift can often detect the type automatically from the assigned value.
            """,
            codeExample: """
            let name = "Alex"
            let age = 25
            let height = 1.82
            let isDeveloper = true
            """,
            explanation: """
            "Alex" is a String.

            25 is an Int.

            1.82 is a Double.

            true is a Bool.
            """,
            quiz: QuizQuestion(
                question: "What type is the value 25?",
                answers: ["String", "Int", "Double", "Bool"],
                correctAnswerIndex: 1,
                explanation: "Whole numbers such as 25 are represented by Int."
            ),
            challenge: CodeChallenge(
                title: "Complete the code",
                description: "Choose the correct type for a true or false value.",
                codeTemplate: "let isLearning: ___ = true",
                options: ["String", "Int", "Bool", "Double"],
                correctAnswerIndex: 2,
                completedCode: "let isLearning: Bool = true"
            )
        ),
        Lesson(
            id: 4,
            title: "Conditions",
            duration: "5 min",
            theoryTitle: "Making Decisions",
            theoryText: """
            Conditions allow your program to execute different code depending on a value.

            Swift commonly uses if and else for this.
            """,
            codeExample: """
            let age = 18

            if age >= 18 {
                print("Adult")
            } else {
                print("Minor")
            }
            """,
            explanation: """
            Swift first checks the condition age >= 18.

            If it is true, the first block runs.

            Otherwise, the else block runs.
            """,
            quiz: QuizQuestion(
                question: "Which keyword runs code when an if condition is false?",
                answers: ["then", "otherwise", "else", "case"],
                correctAnswerIndex: 2,
                explanation: "else provides an alternative block when the if condition is false."
            ),
            challenge: CodeChallenge(
                title: "Complete the code",
                description: "Complete the condition keyword.",
                codeTemplate: """
                ___ score > 10 {
                    print("Great!")
                }
                """,
                options: ["if", "for", "var", "func"],
                correctAnswerIndex: 0,
                completedCode: """
                if score > 10 {
                    print("Great!")
                }
                """
            )
        ),
        Lesson(
            id: 5,
            title: "Loops",
            duration: "5 min",
            theoryTitle: "Repeating Code",
            theoryText: """
            Loops let you run the same code multiple times.

            A for-in loop is commonly used to iterate over a sequence of values.
            """,
            codeExample: """
            for number in 1...5 {
                print(number)
            }
            """,
            explanation: """
            The range 1...5 contains the numbers from 1 through 5.

            The loop runs once for every value in that range.
            """,
            quiz: QuizQuestion(
                question: "Which keyword is commonly used to start a loop over a sequence?",
                answers: ["loop", "repeat", "for", "iterate"],
                correctAnswerIndex: 2,
                explanation: "Swift uses for-in loops to iterate over sequences such as ranges and arrays."
            ),
            challenge: CodeChallenge(
                title: "Complete the code",
                description: "Complete the loop.",
                codeTemplate: """
                ___ number in 1...3 {
                    print(number)
                }
                """,
                options: ["for", "if", "let", "while"],
                correctAnswerIndex: 0,
                completedCode: """
                for number in 1...3 {
                    print(number)
                }
                """
            )
        ),
        Lesson(
            id: 6,
            title: "Functions",
            duration: "5 min",
            theoryTitle: "Reusable Code with Functions",
            theoryText: """
            Functions group reusable pieces of code.

            A function can receive values called parameters and perform an action with them.

            Functions are declared using the func keyword.
            """,
            codeExample: """
            func greet(name: String) {
                print("Hello, \\(name)")
            }

            greet(name: "Alex")
            """,
            explanation: """
            func creates a function.

            The function is called greet and receives a String parameter named name.

            The function can then be called whenever that behavior is needed.
            """,
            quiz: QuizQuestion(
                question: "Which keyword declares a function in Swift?",
                answers: ["function", "method", "func", "def"],
                correctAnswerIndex: 2,
                explanation: "Swift functions are declared using the func keyword."
            ),
            challenge: CodeChallenge(
                title: "Complete the code",
                description: "Complete the function declaration.",
                codeTemplate: """
                ___ sayHello() {
                    print("Hello")
                }
                """,
                options: ["func", "let", "var", "class"],
                correctAnswerIndex: 0,
                completedCode: """
                func sayHello() {
                    print("Hello")
                }
                """
            )
        ),
        Lesson(
            id: 7,
            title: "Arrays",
            duration: "5 min",
            theoryTitle: "Storing Multiple Values",
            theoryText: """
            An Array stores multiple values in an ordered collection.

            Array elements can be accessed by their position and new values can be added using append().
            """,
            codeExample: """
            var languages = ["Swift", "Kotlin", "Java"]

            languages.append("Python")
            """,
            explanation: """
            languages contains several String values.

            append() adds another value to the end of the array.
            """,
            quiz: QuizQuestion(
                question: "Which method adds a new value to the end of an Array?",
                answers: ["insertLast()", "add()", "append()", "push()"],
                correctAnswerIndex: 2,
                explanation: "append() adds a new element to the end of a Swift Array."
            ),
            challenge: CodeChallenge(
                title: "Complete the code",
                description: "Add \"Python\" to the languages array.",
                codeTemplate: "languages.___(\"Python\")",
                options: ["append", "add", "push", "insertLast"],
                correctAnswerIndex: 0,
                completedCode: "languages.append(\"Python\")"
            )
        ),
        Lesson(
            id: 8,
            title: "Dictionaries",
            duration: "5 min",
            theoryTitle: "Key-Value Collections",
            theoryText: """
            A Dictionary stores values using keys.

            Each key is associated with a value.

            Dictionaries are useful when a value should be retrieved by a meaningful identifier instead of a numeric position.
            """,
            codeExample: """
            let user = [
                "name": "Alex",
                "language": "Swift"
            ]

            print(user["name"])
            """,
            explanation: """
            The dictionary contains keys such as "name" and "language".

            Each key points to its associated value.
            """,
            quiz: QuizQuestion(
                question: "How are values stored in a Dictionary?",
                answers: ["By numeric position only", "As key-value pairs", "As functions", "As loops"],
                correctAnswerIndex: 1,
                explanation: "A Dictionary associates each key with a corresponding value."
            ),
            challenge: CodeChallenge(
                title: "Complete the code",
                description: "Choose the key used to access the user's name.",
                codeTemplate: "user[\"___\"]",
                options: ["name", "0", "value", "first"],
                correctAnswerIndex: 0,
                completedCode: "user[\"name\"]"
            )
        )
    ]
}

final class LearningProgressStore: ObservableObject {
    @Published private(set) var completedLessonIDs: Set<Int>
    @Published private(set) var xp: Int
    @Published private(set) var totalAnswers: Int
    @Published private(set) var correctAnswers: Int

    private let completedLessonIDsKey = "completedLessonIDs"
    private let xpKey = "xp"
    private let totalAnswersKey = "totalAnswers"
    private let correctAnswersKey = "correctAnswers"
    private let userDefaults: UserDefaults

    var accuracy: Int {
        guard totalAnswers > 0 else { return 0 }
        return Int((Double(correctAnswers) / Double(totalAnswers)) * 100)
    }

    var completedLessonsCount: Int {
        completedLessonIDs.count
    }

    var courseProgress: Double {
        guard !LessonData.lessons.isEmpty else { return 0 }
        return Double(completedLessonsCount) / Double(LessonData.lessons.count)
    }

    var courseProgressPercentage: Int {
        Int(courseProgress * 100)
    }

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        self.completedLessonIDs = Set(userDefaults.array(forKey: completedLessonIDsKey) as? [Int] ?? [])
        self.xp = userDefaults.integer(forKey: xpKey)
        self.totalAnswers = userDefaults.integer(forKey: totalAnswersKey)
        self.correctAnswers = userDefaults.integer(forKey: correctAnswersKey)
    }

    func isCompleted(_ lesson: Lesson) -> Bool {
        completedLessonIDs.contains(lesson.id)
    }

    func isUnlocked(_ lesson: Lesson) -> Bool {
        lesson.id == 1 || completedLessonIDs.contains(lesson.id - 1)
    }

    func completeLesson(_ lesson: Lesson) {
        guard !isCompleted(lesson) else { return }

        completedLessonIDs.insert(lesson.id)
        xp += 20
        saveProgress()
    }

    func recordQuizAnswer(isCorrect: Bool) {
        totalAnswers += 1

        if isCorrect {
            correctAnswers += 1
        }

        saveProgress()
    }

    func resetProgress() {
        completedLessonIDs.removeAll()
        xp = 0
        totalAnswers = 0
        correctAnswers = 0
        saveProgress()
    }

    private func saveProgress() {
        userDefaults.set(Array(completedLessonIDs), forKey: completedLessonIDsKey)
        userDefaults.set(xp, forKey: xpKey)
        userDefaults.set(totalAnswers, forKey: totalAnswersKey)
        userDefaults.set(correctAnswers, forKey: correctAnswersKey)
    }
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

struct LearnView: View {
    @EnvironmentObject private var progressStore: LearningProgressStore
    @State private var navigationPath: [Lesson] = []

    private let lessons = LessonData.lessons

    private var completedLessonsCount: Int {
        lessons.filter { progressStore.isCompleted($0) }.count
    }

    private var currentLesson: Lesson? {
        lessons.first { lesson in
            !progressStore.isCompleted(lesson) && progressStore.isUnlocked(lesson)
        }
    }

    private var nextLesson: Lesson? {
        currentLesson
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 20) {
                    header

                    ProgressCard(
                        courseTitle: "Swift Basics",
                        completedLessonsCount: completedLessonsCount,
                        totalLessonsCount: lessons.count
                    ) {
                        openNextLesson()
                    }

                    VStack(alignment: .leading, spacing: 14) {
                        Text("Course")
                            .font(.title2)
                            .fontWeight(.bold)

                        ForEach(lessons) { lesson in
                            LessonCard(
                                lesson: lesson,
                                state: state(for: lesson)
                            ) {
                                openLessonIfAvailable(lesson)
                            }
                        }
                    }
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Lesson.self) { lesson in
                destination(for: lesson)
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Swift Learning")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Continue learning Swift")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 8)
    }

    private func destination(for lesson: Lesson) -> some View {
        LessonView(
            lesson: lesson,
            totalLessonsCount: lessons.count,
            wasAlreadyCompleted: progressStore.isCompleted(lesson)
        ) {
            navigationPath.removeAll()
        }
    }

    private func state(for lesson: Lesson) -> LessonState {
        if progressStore.isCompleted(lesson) {
            return .completed
        }

        if lesson == currentLesson {
            return .current
        }

        return .locked
    }

    private func openNextLesson() {
        guard let nextLesson else { return }
        navigationPath.append(nextLesson)
    }

    private func openLessonIfAvailable(_ lesson: Lesson) {
        guard state(for: lesson) != .locked else { return }
        navigationPath.append(lesson)
    }
}

struct LessonView: View {
    let lesson: Lesson
    let totalLessonsCount: Int
    let wasAlreadyCompleted: Bool
    let onFlowCompleted: () -> Void

    private var courseProgress: Double {
        Double(lesson.id) / Double(totalLessonsCount)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                lessonProgress

                VStack(alignment: .leading, spacing: 12) {
                    Text("THEORY")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)

                    Text(lesson.theoryTitle)
                        .font(.title)
                        .fontWeight(.bold)

                    Text(lesson.theoryText)
                        .font(.body)
                        .lineSpacing(6)
                        .multilineTextAlignment(.leading)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("CODE EXAMPLE")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)

                    CodeBlockView(code: lesson.codeExample)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("How it works")
                        .font(.headline)

                    Text(lesson.explanation)
                        .font(.body)
                        .lineSpacing(5)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.secondary)
                }
                .padding(18)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

                NavigationLink {
                    QuizView(
                        lesson: lesson,
                        question: lesson.quiz,
                        wasAlreadyCompleted: wasAlreadyCompleted,
                        onFlowCompleted: onFlowCompleted
                    )
                } label: {
                    PrimaryButtonLabel(title: "Continue")
                }
                .buttonStyle(.plain)
            }
            .padding(20)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(lesson.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var lessonProgress: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Lesson \(lesson.id) of \(totalLessonsCount)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)

                Spacer()

                Text("\(lesson.id) / \(totalLessonsCount)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
            }

            ProgressView(value: courseProgress)
                .tint(.accentColor)
        }
    }
}

struct QuizView: View {
    @EnvironmentObject private var progressStore: LearningProgressStore

    let lesson: Lesson
    let question: QuizQuestion
    let wasAlreadyCompleted: Bool
    let onFlowCompleted: () -> Void

    @State private var selectedAnswerIndex: Int?

    private var isAnswered: Bool {
        selectedAnswerIndex != nil
    }

    private var isCorrect: Bool {
        selectedAnswerIndex == question.correctAnswerIndex
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Quick Check")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text(question.question)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                }

                VStack(spacing: 12) {
                    ForEach(question.answers.indices, id: \.self) { index in
                        AnswerOptionView(
                            title: question.answers[index],
                            state: optionState(for: index)
                        ) {
                            selectAnswer(index)
                        }
                        .disabled(isAnswered)
                    }
                }

                if isAnswered {
                    quizFeedbackView

                    NavigationLink {
                        CodeChallengeView(
                            lesson: lesson,
                            challenge: lesson.challenge,
                            wasAlreadyCompleted: wasAlreadyCompleted,
                            onFlowCompleted: onFlowCompleted
                        )
                    } label: {
                        PrimaryButtonLabel(title: "Continue")
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(20)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Quiz")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var quizFeedbackView: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundStyle(isCorrect ? .green : .red)

                Text(isCorrect ? "Correct!" : "Not quite")
                    .font(.headline)
                    .foregroundStyle(isCorrect ? .green : .red)
            }

            Text(question.explanation)
                .font(.body)
                .foregroundStyle(.secondary)
                .lineSpacing(5)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private func optionState(for index: Int) -> AnswerOptionState {
        guard let selectedAnswerIndex else { return .neutral }

        if index == selectedAnswerIndex && index == question.correctAnswerIndex {
            return .selectedCorrect
        }

        if index == selectedAnswerIndex {
            return .selectedIncorrect
        }

        if index == question.correctAnswerIndex {
            return .correct
        }

        return .neutral
    }

    private func selectAnswer(_ index: Int) {
        guard selectedAnswerIndex == nil else { return }

        selectedAnswerIndex = index
        progressStore.recordQuizAnswer(isCorrect: index == question.correctAnswerIndex)
    }
}

struct CodeChallengeView: View {
    @EnvironmentObject private var progressStore: LearningProgressStore

    let lesson: Lesson
    let challenge: CodeChallenge
    let wasAlreadyCompleted: Bool
    let onFlowCompleted: () -> Void

    @State private var selectedOptionIndex: Int?
    @State private var challengeCompleted = false
    @State private var showCompletion = false

    private var didChooseIncorrectAnswer: Bool {
        if let selectedOptionIndex {
            return selectedOptionIndex != challenge.correctAnswerIndex && !challengeCompleted
        }

        return false
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Code Challenge")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text(challenge.title)
                        .font(.title3)
                        .fontWeight(.semibold)

                    Text(challenge.description)
                        .font(.body)
                        .foregroundStyle(.secondary)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text(challengeCompleted ? "COMPLETED CODE" : "COMPLETE THE CODE")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)

                    CodeBlockView(code: challengeCompleted ? challenge.completedCode : challenge.codeTemplate)
                }

                VStack(spacing: 12) {
                    ForEach(challenge.options.indices, id: \.self) { index in
                        AnswerOptionView(
                            title: challenge.options[index],
                            state: optionState(for: index)
                        ) {
                            selectOption(index)
                        }
                        .disabled(challengeCompleted)
                    }
                }

                if didChooseIncorrectAnswer {
                    Text("Try again")
                        .font(.headline)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                if challengeCompleted {
                    successView

                    Button {
                        progressStore.completeLesson(lesson)
                        showCompletion = true
                    } label: {
                        PrimaryButtonLabel(title: "Finish Lesson")
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(20)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Challenge")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showCompletion) {
            LessonCompletedView(
                lesson: lesson,
                didEarnXP: !wasAlreadyCompleted,
                onContinue: onFlowCompleted
            )
        }
    }

    private var successView: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)

                Text("Great job!")
                    .font(.headline)
                    .foregroundStyle(.green)
            }

            Text("You completed the challenge.")
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private func optionState(for index: Int) -> AnswerOptionState {
        guard let selectedOptionIndex else { return .neutral }

        if challengeCompleted && index == challenge.correctAnswerIndex {
            return .selectedCorrect
        }

        if index == selectedOptionIndex && index == challenge.correctAnswerIndex {
            return .selectedCorrect
        }

        if index == selectedOptionIndex {
            return .selectedIncorrect
        }

        return .neutral
    }

    private func selectOption(_ index: Int) {
        guard !challengeCompleted else { return }

        selectedOptionIndex = index

        if index == challenge.correctAnswerIndex {
            challengeCompleted = true
        }
    }
}

struct LessonCompletedView: View {
    let lesson: Lesson
    let didEarnXP: Bool
    let onContinue: () -> Void

    @State private var isVisible = false

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 88, weight: .semibold))
                .foregroundStyle(.green)
                .scaleEffect(isVisible ? 1.0 : 0.7)
                .opacity(isVisible ? 1 : 0)
                .animation(.spring(response: 0.45, dampingFraction: 0.72), value: isVisible)

            VStack(spacing: 10) {
                Text("Lesson Complete!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text("You completed \(lesson.title)")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            Text(didEarnXP ? "+20 XP" : "Lesson reviewed")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(didEarnXP ? .green : .secondary)
                .padding(.horizontal, 22)
                .padding(.vertical, 12)
                .background((didEarnXP ? Color.green : Color.secondary).opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            Spacer()

            PrimaryButton(title: "Continue", action: onContinue)
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
        .navigationBarBackButtonHidden(true)
        .onAppear {
            isVisible = true
        }
    }
}

struct PracticeView: View {
    @State private var navigationPath: [PracticeCategory] = []

    private let categories = PracticeData.categories

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    header
                    infoCard

                    VStack(spacing: 14) {
                        ForEach(categories) { category in
                            PracticeCategoryCard(category: category) {
                                navigationPath.append(category)
                            }
                        }
                    }
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Practice")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: PracticeCategory.self) { category in
                PracticeSessionView(category: category) {
                    navigationPath.removeAll()
                }
            }
        }
    }

    private var header: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: "chevron.left.forwardslash.chevron.right")
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(Color.accentColor)
                .frame(width: 58, height: 58)
                .background(Color.accentColor.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

            VStack(alignment: .leading, spacing: 6) {
                Text("Practice Swift")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Improve your skills with quick challenges")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var infoCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Quick Practice")
                .font(.headline)

            Text("Answer 5 questions and check your Swift knowledge.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.primary.opacity(0.06), lineWidth: 1)
        )
    }
}

struct ProfileView: View {
    @EnvironmentObject private var progressStore: LearningProgressStore
    @State private var isShowingResetAlert = false

    private let totalLessonsCount = LessonData.lessons.count
    private let statisticColumns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    private var achievements: [Achievement] {
        let completedCount = progressStore.completedLessonsCount

        return [
            Achievement(
                id: "first-step",
                title: "First Step",
                description: "Complete your first lesson",
                systemImage: "figure.walk",
                isUnlocked: completedCount >= 1
            ),
            Achievement(
                id: "swift-beginner",
                title: "Swift Beginner",
                description: "Complete 3 lessons",
                systemImage: "chevron.left.forwardslash.chevron.right",
                isUnlocked: completedCount >= 3
            ),
            Achievement(
                id: "halfway-there",
                title: "Halfway There",
                description: "Complete 4 lessons",
                systemImage: "flag.fill",
                isUnlocked: completedCount >= 4
            ),
            Achievement(
                id: "swift-explorer",
                title: "Swift Explorer",
                description: "Complete all lessons",
                systemImage: "trophy.fill",
                isUnlocked: completedCount == totalLessonsCount
            )
        ]
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    profileHeader
                    progressSection
                    statisticsSection
                    achievementsSection
                    demoSection
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Reset progress?", isPresented: $isShowingResetAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Reset", role: .destructive) {
                    progressStore.resetProgress()
                }
            } message: {
                Text("All lesson progress, XP and quiz statistics will be removed.")
            }
        }
    }

    private var profileHeader: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 92, weight: .regular))
                .foregroundStyle(Color.accentColor)

            VStack(spacing: 5) {
                Text("Swift Learner")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Learning Swift one step at a time")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
    }

    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Progress")
                .font(.title2)
                .fontWeight(.bold)

            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .firstTextBaseline) {
                    Text("\(progressStore.completedLessonsCount) of \(totalLessonsCount) lessons completed")
                        .font(.headline)

                    Spacer()

                    Text("\(progressStore.courseProgressPercentage)%")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.accentColor)
                }

                ProgressView(value: progressStore.courseProgress)
                    .tint(.accentColor)

                if progressStore.completedLessonsCount == totalLessonsCount {
                    courseCompletedCard
                }
            }
            .padding(20)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.primary.opacity(0.06), lineWidth: 1)
            )
        }
    }

    private var courseCompletedCard: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.seal.fill")
                .font(.title3)
                .foregroundStyle(.green)

            VStack(alignment: .leading, spacing: 3) {
                Text("Course Completed")
                    .font(.headline)
                    .foregroundStyle(.green)

                Text("You finished Swift Basics!")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color.green.opacity(0.10))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var statisticsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Statistics")
                .font(.title2)
                .fontWeight(.bold)

            LazyVGrid(columns: statisticColumns, spacing: 12) {
                StatCard(title: "XP", value: "\(progressStore.xp)", systemImage: "bolt.fill")
                StatCard(title: "Lessons", value: "\(progressStore.completedLessonsCount) / \(totalLessonsCount)", systemImage: "book.fill")
                StatCard(title: "Accuracy", value: "\(progressStore.accuracy)%", systemImage: "target")
            }
        }
    }

    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Achievements")
                .font(.title2)
                .fontWeight(.bold)

            VStack(spacing: 12) {
                ForEach(achievements) { achievement in
                    AchievementCard(achievement: achievement)
                }
            }
        }
    }

    private var demoSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Demo")
                .font(.title2)
                .fontWeight(.bold)

            Button(role: .destructive) {
                isShowingResetAlert = true
            } label: {
                HStack {
                    Image(systemName: "arrow.counterclockwise")
                    Text("Reset Progress")
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
            }
            .buttonStyle(.bordered)
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let systemImage: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: systemImage)
                .font(.headline)
                .foregroundStyle(Color.accentColor)
                .frame(width: 34, height: 34)
                .background(Color.accentColor.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)

                Text(value)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    .minimumScaleFactor(0.8)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.primary.opacity(0.06), lineWidth: 1)
        )
    }
}

struct AchievementCard: View {
    let achievement: Achievement

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: achievement.systemImage)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(achievement.isUnlocked ? Color.accentColor : .secondary)
                .frame(width: 48, height: 48)
                .background((achievement.isUnlocked ? Color.accentColor : Color.secondary).opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))

            VStack(alignment: .leading, spacing: 5) {
                Text(achievement.title)
                    .font(.headline)
                    .foregroundStyle(achievement.isUnlocked ? .primary : .secondary)

                Text(achievement.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
            }

            Spacer(minLength: 12)

            Image(systemName: achievement.isUnlocked ? "checkmark.circle.fill" : "lock.fill")
                .font(.headline)
                .foregroundStyle(achievement.isUnlocked ? .green : .secondary)
        }
        .padding(16)
        .background(achievement.isUnlocked ? Color(.secondarySystemGroupedBackground) : Color.secondary.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(achievement.isUnlocked ? Color.primary.opacity(0.06) : Color.secondary.opacity(0.12), lineWidth: 1)
        )
        .opacity(achievement.isUnlocked ? 1 : 0.68)
    }
}

struct PracticeCategoryCard: View {
    let category: PracticeCategory
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: category.systemImage)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(Color.accentColor)
                    .frame(width: 48, height: 48)
                    .background(Color.accentColor.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))

                VStack(alignment: .leading, spacing: 6) {
                    Text(category.title)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text(category.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)

                    Text("\(category.questions.count) questions")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.accentColor)
                }

                Spacer(minLength: 12)

                Image(systemName: "chevron.right")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
            }
            .padding(16)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color.primary.opacity(0.06), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

struct PrimaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            PrimaryButtonLabel(title: title)
        }
        .buttonStyle(.plain)
    }
}

struct PrimaryButtonLabel: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(Color.accentColor)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct ProgressCard: View {
    let courseTitle: String
    let completedLessonsCount: Int
    let totalLessonsCount: Int
    let action: () -> Void

    private var progress: Double {
        guard totalLessonsCount > 0 else { return 0 }
        return Double(completedLessonsCount) / Double(totalLessonsCount)
    }

    private var isCourseCompleted: Bool {
        totalLessonsCount > 0 && completedLessonsCount == totalLessonsCount
    }

    private var buttonTitle: String {
        completedLessonsCount == 0 ? "Start Learning" : "Continue Learning"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 8) {
                Text(courseTitle)
                    .font(.title3)
                    .fontWeight(.bold)

                Text("\(completedLessonsCount) of \(totalLessonsCount) lessons completed")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            ProgressView(value: progress)
                .tint(.accentColor)

            if isCourseCompleted {
                HStack(spacing: 10) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)

                    Text("Course Completed")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.green)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(Color.green.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            } else {
                PrimaryButton(title: buttonTitle, action: action)
            }
        }
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.primary.opacity(0.06), lineWidth: 1)
        )
    }
}

enum LessonState {
    case completed
    case current
    case locked
}

struct LessonCard: View {
    let lesson: Lesson
    let state: LessonState
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Text(String(format: "%02d", lesson.id))
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(numberColor)
                    .frame(width: 44, height: 44)
                    .background(numberBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                VStack(alignment: .leading, spacing: 6) {
                    Text(lesson.title)
                        .font(.headline)
                        .foregroundStyle(titleColor)

                    Text(lesson.duration)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer(minLength: 12)

                stateView
            }
            .padding(16)
            .background(cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(borderColor, lineWidth: state == .current ? 1.5 : 1)
            )
            .opacity(state == .locked ? 0.62 : 1)
        }
        .buttonStyle(.plain)
        .disabled(state == .locked)
    }

    @ViewBuilder
    private var stateView: some View {
        switch state {
        case .completed:
            Image(systemName: "checkmark.circle.fill")
                .font(.title3)
                .foregroundStyle(.green)
        case .current:
            HStack(spacing: 6) {
                Text(lesson.id == 1 ? "Start" : "Continue")
                    .font(.caption)
                    .fontWeight(.semibold)
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .fontWeight(.bold)
            }
            .foregroundStyle(Color.accentColor)
        case .locked:
            Image(systemName: "lock.fill")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var cardBackground: Color {
        switch state {
        case .completed:
            return Color.green.opacity(0.08)
        case .current:
            return Color.accentColor.opacity(0.10)
        case .locked:
            return Color.secondary.opacity(0.08)
        }
    }

    private var borderColor: Color {
        switch state {
        case .completed:
            return Color.green.opacity(0.22)
        case .current:
            return Color.accentColor.opacity(0.55)
        case .locked:
            return Color.secondary.opacity(0.12)
        }
    }

    private var numberColor: Color {
        state == .locked ? .secondary : .accentColor
    }

    private var titleColor: Color {
        state == .locked ? .secondary : .primary
    }

    private var numberBackground: Color {
        state == .locked ? Color.secondary.opacity(0.10) : Color.accentColor.opacity(0.13)
    }
}

struct CodeBlockView: View {
    let code: String

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            Text(code)
                .font(.system(.body, design: .monospaced))
                .foregroundStyle(Color.white.opacity(0.94))
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(18)
        }
        .background(Color(red: 0.10, green: 0.11, blue: 0.13))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

enum AnswerOptionState {
    case neutral
    case selectedCorrect
    case selectedIncorrect
    case correct
}

struct AnswerOptionView: View {
    let title: String
    let state: AnswerOptionState
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(textColor)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if let systemImageName {
                    Image(systemName: systemImageName)
                        .font(.headline)
                        .foregroundStyle(iconColor)
                }
            }
            .padding(16)
            .frame(minHeight: 58)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(borderColor, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }

    private var backgroundColor: Color {
        switch state {
        case .neutral:
            return Color(.secondarySystemGroupedBackground)
        case .selectedCorrect, .correct:
            return Color.green.opacity(0.13)
        case .selectedIncorrect:
            return Color.red.opacity(0.13)
        }
    }

    private var borderColor: Color {
        switch state {
        case .neutral:
            return Color.primary.opacity(0.08)
        case .selectedCorrect, .correct:
            return Color.green.opacity(0.55)
        case .selectedIncorrect:
            return Color.red.opacity(0.55)
        }
    }

    private var textColor: Color {
        switch state {
        case .neutral:
            return .primary
        case .selectedCorrect, .correct:
            return .green
        case .selectedIncorrect:
            return .red
        }
    }

    private var iconColor: Color {
        switch state {
        case .selectedCorrect, .correct:
            return .green
        case .selectedIncorrect:
            return .red
        case .neutral:
            return .secondary
        }
    }

    private var systemImageName: String? {
        switch state {
        case .selectedCorrect, .correct:
            return "checkmark.circle.fill"
        case .selectedIncorrect:
            return "xmark.circle.fill"
        case .neutral:
            return nil
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(LearningProgressStore())
}
