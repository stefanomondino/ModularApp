import Foundation
@testable import Networking
import Streams
import Testing

@Suite("Networking Tests", .serialized)
struct NetworkClientTests {
    struct AccessToken: Codable, Sendable, DataConvertible {
        let accessToken: String
        let refreshToken: String
        static var test: AccessToken {
            .init(accessToken: "invalid", refreshToken: "refresh-me")
        }

        static var refresh: AccessToken {
            .init(accessToken: "valid", refreshToken: "new-refresh-me")
        }
    }

    let client: Client
    let refreshRequest: Request
    let token: Property<AccessToken?>
    init() throws {
        let refreshRequest = try Request(baseURL: "http://localhost:8083", path: "token", method: .post, body: .json(AccessToken.test))
        self.refreshRequest = refreshRequest
        let token = Property<AccessToken?>(.test)
        self.token = token
        client = .init(authorization: TokenAuthorizationMiddleware<AccessToken>(
            token: token,
            headers: { request, currentToken in
                if let currentToken, request.authorization == .bearer {
                    [.authorization: "Bearer \(currentToken.accessToken)"]
                } else {
                    [:]
                }
            },
            refresh: { client, response in
                if response.statusCode == .unauthorized,
                   response.request.authorization == .bearer,
                   let refreshedToken = try? await client.response(refreshRequest).json(AccessToken.self) {
                    await token.send(refreshedToken)
                    return true
                }
                return false
            }
        ))
    }

    @Test("Basic Request")
    func basicRequest() async throws {
        try await withServer { server in
            let request = Request(baseURL: "http://localhost:8083", path: "test", method: .get)
            let expectedResponse = Response(Data(), request: request)

            try await server.register(expectedResponse, for: request)

            let actualResponse = try await client.response(request)
            #expect(actualResponse.data == expectedResponse.data, "Expected response data to match the registered response")
            #expect(actualResponse.statusCode == expectedResponse.statusCode, "Expected response status code to match the registered response")
        }
    }

    @Test("Mocking works for client by not triggering server API call")
    func mockRequest() async throws {
        try await withServer { server in
            let request = Request(baseURL: "http://localhost:8083", path: "test", method: .get)
            let expectedResponse = Response("mocked", statusCode: 404, request: request)
            let serverResponse = Response("from server", request: request)
            try await server.register(serverResponse, for: request)
            await client.mock(for: request, response: expectedResponse)

            let actualResponse = try await client.response(request)
            #expect(actualResponse.data == expectedResponse.data, "Expected response data to match the registered response")
            #expect(actualResponse.statusCode == expectedResponse.statusCode, "Expected response status code to match the registered response")
        }
    }

    @Test("Unmocked request hits server")
    func unmockedRequest() async throws {
        try await withServer { server in
            let request = Request(baseURL: "http://localhost:8083", path: "real", method: .get)
            let expectedResponse = Response(Data("real".utf8), request: request)
            try await server.register(expectedResponse, for: request)
            let actualResponse = try await client.response(request)
            #expect(actualResponse.data == expectedResponse.data, "Expected real server response")
        }
    }

    @Test("Handles network error gracefully")
    func networkError() async throws {
        // Do not start a server, localhost will fail simulating a network connection error
        let request = Request(baseURL: "http://localhost:8083", path: "error", method: .get)
        do {
            _ = try await client.response(request)
            Issue.record("Expected network error but got a response")
        } catch {
            #expect(error == .connectionError(request), "Error was thrown as expected")
        }
    }

    @Test("Multiple mocks, last one wins")
    func multipleMocks() async throws {
        try await withServer { _ in
            let request = Request(baseURL: "http://localhost:8083", path: "mock", method: .get)
            let firstMock = Response("first", request: request)
            let secondMock = Response("second", request: request)
            await client.mock(for: request, response: firstMock)
            await client.mock(for: request, response: secondMock)
            let actualResponse = try await client.response(request)
            #expect(actualResponse.data == secondMock.data, "Expected last mock to be used")
        }
    }

    @Test("Clears mocks")
    func clearMocks() async throws {
        try await withServer { server in
            let request = Request(baseURL: "http://localhost:8083", path: "clear", method: .get)
            let mockResponse = Response(Data("mock".utf8), request: request)

            await client.mock(for: request, response: mockResponse)
            let mockedResponse = try await client.response(request) // This should use the mock
            #expect(mockedResponse.data == mockResponse.data, "Expected mocked response to be returned")
            // Clear mocks
            await client.mock(for: request, response: nil)

            // Now this should hit the server
            let expectedResponse = Response(Data("real".utf8), request: request)
            try await server.register(expectedResponse, for: request)

            let actualResponse = try await client.response(request)
            #expect(actualResponse.data == expectedResponse.data, "Expected real server response after clearing mocks")
        }
    }

    @Test("Decodable response gets parsed correctly")
    func decodableResponse() async throws {
        try await withServer { server in
            struct TestData: Codable, Equatable {
                let id: Int
                let name: String
            }

            let request = Request(baseURL: "http://localhost:8083", path: "test", method: .get)
            let expectedData = TestData(id: 1, name: "Test")
            let expectedResponse = try Response(JSONEncoder().encode(expectedData), request: request)

            try await server.register(expectedResponse, for: request)

            let actualResponse: Response = try await client.response(request)
            #expect(try actualResponse.json(TestData.self) == expectedData, "Expected decoded response to match the expected data")
        }
    }

    @Test("Simultaneous API calls are sharing underlying REST connection")
    func concurrentCalls() async throws {
        try await withServer { server in
            let request = Request(baseURL: "http://localhost:8083", path: "concurrent", method: .get)
            let expectedData = Data("concurrent".utf8)
            let expectedResponse = Response(expectedData, request: request)
            try await server.register(expectedResponse, for: request, delay: 2, addTimestamp: true)
            async let response1 = client.response(request)
            try await Task.sleep(for: .milliseconds(500))
            async let response2 = client.response(request)
            try await print(response1, response2)
            #expect(try await response1 == response2)
            try await Task.sleep(for: .seconds(2))
            async let response3 = client.response(request)
            #expect(try await response3 != expectedResponse, "A new response should have been generated")
        }
    }

    @Test("Handle automatic refresh header")
    func authorizationHeaders() async throws {
        try await withServer { server in
            let authRequest = try Request(baseURL: "http://localhost:8083",
                                          path: "auth",
                                          method: .post,
                                          body: .json(AccessToken.test),
                                          authorization: .bearer)
            let unauthorizedResponse = Response("Unauthorized", statusCode: .unauthorized, request: authRequest)
            let finalResponse = Response("Final", statusCode: .ok, request: authRequest)

            await server.register(request: authRequest) { request in
                let token = request.httpHeaders[.authorization]?.replacingOccurrences(of: "Bearer ", with: "")
                if token != "valid" {
                    return unauthorizedResponse
                } else {
                    return finalResponse
                }
            }
            try await server.register(request: refreshRequest) { request in
                let refreshToken = try JSONDecoder().decode(AccessToken.self, from: request.body ?? .init())
                if refreshToken.refreshToken != "refresh-me" {
                    return unauthorizedResponse
                } else {
                    return try Response(AccessToken.refresh, request: request)
                }
            }

            let response = try await client.response(authRequest)
            #expect(response.data == finalResponse.data, "Expected final response after authorization flow")
            await #expect(token.value?.accessToken == "valid", "Expected token to be valid after authorization")
        }
    }
}
