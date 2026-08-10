import Foundation

enum PracticeData {
    static func category(id: String) -> PracticeCategory? {
        categories.first { $0.id == id }
    }

    static let categories: [PracticeCategory] = [
        PracticeCategory(
            id: "variables",
            title: "Variables",
            description: "Test variables, constants and basic types",
            systemImage: "x.squareroot",
            questions: [
                PracticeQuestion(id: "variables-1", question: "Which keyword declares a mutable variable?", code: nil, answers: ["let", "var", "func", "mut"], correctAnswerIndex: 1, explanation: "Use var when a value needs to change after it is created."),
                PracticeQuestion(id: "variables-2", question: "What type is age?", code: "let age = 25", answers: ["String", "Int", "Bool", "Double"], correctAnswerIndex: 1, explanation: "25 is a whole number, so Swift infers the type Int."),
                PracticeQuestion(id: "variables-3", question: "Which keyword should replace the blank?", code: "___ name = \"John\"", answers: ["let", "func", "class", "if"], correctAnswerIndex: 0, explanation: "let creates a constant whose value cannot be reassigned."),
                PracticeQuestion(id: "variables-4", question: "Which value is a Bool?", code: nil, answers: ["\"true\"", "1", "true", "\"Bool\""], correctAnswerIndex: 2, explanation: "true and false are Boolean values in Swift."),
                PracticeQuestion(
                    id: "variables-5",
                    question: "What happens when this code is compiled?",
                    code: """
                    let score = 10
                    score = 20
                    """,
                    answers: ["score becomes 20", "Compile error", "Runtime crash", "Nothing happens"],
                    correctAnswerIndex: 1,
                    explanation: "score was created with let, so its value cannot be reassigned."
                )
            ]
        ),
        PracticeCategory(
            id: "conditions",
            title: "Conditions",
            description: "Practice if, else and comparison logic",
            systemImage: "arrow.triangle.branch",
            questions: [
                PracticeQuestion(id: "conditions-1", question: "Which keyword starts a conditional statement?", code: nil, answers: ["if", "for", "func", "switcher"], correctAnswerIndex: 0, explanation: "if evaluates a condition and runs a block when it is true."),
                PracticeQuestion(
                    id: "conditions-2",
                    question: "What will this code print?",
                    code: """
                    let age = 20

                    if age >= 18 {
                        print("Adult")
                    } else {
                        print("Minor")
                    }
                    """,
                    answers: ["Adult", "Minor", "Nothing", "Compile error"],
                    correctAnswerIndex: 0,
                    explanation: "20 is greater than or equal to 18, so the if block runs."
                ),
                PracticeQuestion(id: "conditions-3", question: "Which operator means equal to?", code: nil, answers: ["=", "==", "!=", ">="], correctAnswerIndex: 1, explanation: "== compares two values for equality. A single = assigns a value."),
                PracticeQuestion(id: "conditions-4", question: "What does else do?", code: nil, answers: ["Repeats code", "Runs when the if condition is false", "Creates a variable", "Stops the app"], correctAnswerIndex: 1, explanation: "else provides an alternative branch when the preceding condition is false."),
                PracticeQuestion(id: "conditions-5", question: "Which condition is true?", code: "let score = 12", answers: ["score < 10", "score == 5", "score > 10", "score != 12"], correctAnswerIndex: 2, explanation: "12 is greater than 10.")
            ]
        ),
        PracticeCategory(
            id: "functions",
            title: "Functions",
            description: "Review function declarations and calls",
            systemImage: "function",
            questions: [
                PracticeQuestion(id: "functions-1", question: "Which keyword declares a function?", code: nil, answers: ["func", "function", "def", "method"], correctAnswerIndex: 0, explanation: "Swift functions are declared with func."),
                PracticeQuestion(
                    id: "functions-2",
                    question: "What is the name of this function?",
                    code: """
                    func greet() {
                        print("Hello")
                    }
                    """,
                    answers: ["func", "greet", "print", "Hello"],
                    correctAnswerIndex: 1,
                    explanation: "greet is the identifier immediately after the func keyword."
                ),
                PracticeQuestion(
                    id: "functions-3",
                    question: "How do you call this function?",
                    code: """
                    func sayHello() {
                        print("Hello")
                    }
                    """,
                    answers: ["sayHello()", "func sayHello()", "call sayHello", "sayHello"],
                    correctAnswerIndex: 0,
                    explanation: "A function without parameters is called using its name followed by parentheses."
                ),
                PracticeQuestion(
                    id: "functions-4",
                    question: "What is name in this function?",
                    code: """
                    func greet(name: String) {
                        print(name)
                    }
                    """,
                    answers: ["A loop", "A parameter", "A class", "A constant outside the function"],
                    correctAnswerIndex: 1,
                    explanation: "name is a parameter that receives a value when the function is called."
                ),
                PracticeQuestion(
                    id: "functions-5",
                    question: "Which call passes \"Alex\" into greet?",
                    code: """
                    func greet(name: String) {
                        print(name)
                    }
                    """,
                    answers: ["greet(\"Alex\")", "greet(name: \"Alex\")", "greet = \"Alex\"", "func greet(\"Alex\")"],
                    correctAnswerIndex: 1,
                    explanation: "The parameter uses the external label name, so the call is greet(name: \"Alex\")."
                )
            ]
        ),
        PracticeCategory(
            id: "collections",
            title: "Collections",
            description: "Practice Arrays and Dictionaries",
            systemImage: "square.stack.3d.up",
            questions: [
                PracticeQuestion(id: "collections-1", question: "Which value is an Array?", code: nil, answers: ["[\"Swift\", \"Kotlin\"]", "[\"name\": \"Alex\"]", "\"Swift\"", "true"], correctAnswerIndex: 0, explanation: "An Array stores an ordered collection of values inside square brackets."),
                PracticeQuestion(id: "collections-2", question: "Which method adds an item to the end of an Array?", code: nil, answers: ["add()", "push()", "append()", "insertLast()"], correctAnswerIndex: 2, explanation: "append() adds a new element to the end of a Swift Array."),
                PracticeQuestion(id: "collections-3", question: "What will languages.count return?", code: "let languages = [\"Swift\", \"Kotlin\", \"Java\"]", answers: ["2", "3", "4", "0"], correctAnswerIndex: 1, explanation: "The array contains three elements."),
                PracticeQuestion(id: "collections-4", question: "How does a Dictionary store data?", code: nil, answers: ["As key-value pairs", "Only as numbers", "Only as Strings", "As functions"], correctAnswerIndex: 0, explanation: "A Dictionary associates each key with a corresponding value."),
                PracticeQuestion(
                    id: "collections-5",
                    question: "Which key accesses Alex?",
                    code: """
                    let user = [
                        "name": "Alex",
                        "language": "Swift"
                    ]
                    """,
                    answers: ["user[\"name\"]", "user[0]", "user[\"Alex\"]", "user.name()"],
                    correctAnswerIndex: 0,
                    explanation: "The value \"Alex\" is associated with the key \"name\"."
                )
            ]
        )
    ]
}
