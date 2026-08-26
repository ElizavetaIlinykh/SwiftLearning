import Foundation
@testable import SwiftLearning
import Testing

@Suite("Network contract")
@MainActor
struct NetworkContractTests {
    @Test
    func authResponseDecodesSwaggerDefaults() throws {
        let json = """
        {
            "access_token": "token",
            "user": {
                "id": "user-id",
                "email": "user@example.com",
                "name": "User",
                "created_at": "2026-08-26T12:00:00Z"
            }
        }
        """.data(using: .utf8)!

        let response = try makeDecoder().decode(AuthResponse.self, from: json)

        #expect(response.accessToken == "token")
        #expect(response.tokenType == "bearer")
        #expect(response.user.level == 1)
        #expect(response.user.completedLessonsCount == 0)
    }

    @Test
    func lessonResponsesDecodeNullableSwaggerFields() throws {
        let json = """
        {
            "id": "lesson-id",
            "title": "Lesson",
            "description": null,
            "order": 1,
            "theory": null,
            "code_example": null
        }
        """.data(using: .utf8)!

        let lesson = try makeDecoder().decode(LessonDetails.self, from: json)

        #expect(lesson.description == nil)
        #expect(lesson.theory == nil)
        #expect(lesson.codeExample == nil)
    }

    @Test
    func paginatedResponseDecodesSwaggerShape() throws {
        let json = """
        {
            "items": [
                {
                    "id": "lesson-id",
                    "title": "Lesson",
                    "description": null,
                    "order": 1,
                    "status": "available"
                }
            ],
            "total": 1,
            "limit": 20,
            "offset": 0,
            "has_more": false
        }
        """.data(using: .utf8)!

        let page = try makeDecoder().decode(PaginatedResponse<LessonSummary>.self, from: json)

        #expect(page.items.count == 1)
        #expect(page.items[0].description == nil)
        #expect(page.hasMore == false)
    }

    private func makeDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}

@Suite("Lessons service contract")
@MainActor
struct LessonsServiceContractTests {
    @Test
    func completeLessonDecodesSwaggerProgressArray() async throws {
        let lessonID = UUID()
        let expectedProgress = LessonProgress(
            lessonId: lessonID,
            status: .completed,
            completedAt: Date(timeIntervalSince1970: 0)
        )
        let networkManager = LessonsNetworkManagerMock(response: [expectedProgress])
        let service = LessonsService(networkManager: networkManager)

        let progress = try await service.completeLesson(id: lessonID.uuidString)

        #expect(progress == expectedProgress)
    }
}

private final class LessonsNetworkManagerMock: NetworkManaging {
    let response: [LessonProgress]

    init(response: [LessonProgress]) {
        self.response = response
    }

    func get<Response: Decodable>(_: APIEndpoint) async throws -> Response {
        throw NetworkContractTestError.unimplemented
    }

    func post<Response: Decodable>(
        _: APIEndpoint,
        body _: some Encodable
    ) async throws -> Response {
        guard let response = response as? Response else {
            throw NetworkContractTestError.unexpectedResponseType
        }

        return response
    }

    func put<Response: Decodable>(
        _: APIEndpoint,
        body _: some Encodable
    ) async throws -> Response {
        throw NetworkContractTestError.unimplemented
    }

    func delete<Response: Decodable>(_: APIEndpoint) async throws -> Response {
        throw NetworkContractTestError.unimplemented
    }
}

private enum NetworkContractTestError: Error {
    case unexpectedResponseType
    case unimplemented
}
