import Foundation

struct APIEndpoint {
    // MARK: - Public properties -

    let path: String
    let queryItems: [URLQueryItem]
    let requiresAuthorization: Bool

    // MARK: - Init -

    init(
        path: String,
        queryItems: [URLQueryItem] = [],
        requiresAuthorization: Bool = true
    ) {
        self.path = path
        self.queryItems = queryItems
        self.requiresAuthorization = requiresAuthorization
    }
}

extension APIEndpoint {
    // MARK: - Auth -

    static let register = APIEndpoint(
        path: "/auth/register",
        requiresAuthorization: false
    )

    static let login = APIEndpoint(
        path: "/auth/login",
        requiresAuthorization: false
    )

    // MARK: - User -

    static let currentUser = APIEndpoint(path: "/me")
    static let userStatistics = APIEndpoint(path: "/me/statistics")
    static let practiceProgress = APIEndpoint(path: "/me/practice-progress")

    static func userLessons(offset: Int, limit: Int) -> APIEndpoint {
        APIEndpoint(
            path: "/me/lessons",
            queryItems: paginationQueryItems(offset: offset, limit: limit)
        )
    }

    // MARK: - Lessons -

    static func lesson(id: String) -> APIEndpoint {
        APIEndpoint(path: "/lessons/\(pathComponent(id))")
    }

    static func lessonQuestions(lessonID: String) -> APIEndpoint {
        APIEndpoint(path: "/lessons/\(pathComponent(lessonID))/questions")
    }

    static func lessonCodeTask(lessonID: String) -> APIEndpoint {
        APIEndpoint(path: "/lessons/\(pathComponent(lessonID))/code-task")
    }

    static func completeLesson(id: String) -> APIEndpoint {
        APIEndpoint(path: "/lessons/\(pathComponent(id))/complete")
    }

    // MARK: - Practice -

    static func practiceTopics(offset: Int, limit: Int) -> APIEndpoint {
        APIEndpoint(
            path: "/practice/topics",
            queryItems: paginationQueryItems(offset: offset, limit: limit)
        )
    }

    static func practiceTasks(topicID: String, offset: Int, limit: Int) -> APIEndpoint {
        APIEndpoint(
            path: "/practice/topics/\(pathComponent(topicID))/tasks",
            queryItems: paginationQueryItems(offset: offset, limit: limit)
        )
    }

    static func completePracticeTopic(topicID: String) -> APIEndpoint {
        APIEndpoint(path: "/practice/topics/\(pathComponent(topicID))/complete")
    }

    // MARK: - Private methods -

    private static func pathComponent(_ value: String) -> String {
        var allowedCharacters = CharacterSet.urlPathAllowed
        allowedCharacters.remove(charactersIn: "/")
        return value.addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? value
    }
}
