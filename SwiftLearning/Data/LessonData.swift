import Foundation

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
