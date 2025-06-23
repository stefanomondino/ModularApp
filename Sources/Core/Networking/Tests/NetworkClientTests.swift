import Foundation
@testable import Networking
import Testing

@Suite("Networking Tests", .serialized)
struct NetworkClientTests {
    let client: Client = .init()

    @Test("Basic Request")
    func basicRequest() async throws {
        try await withServer { server in
            let request = Request(baseURL: "http://localhost:8083", path: "test", method: .get)
            let expectedResponse = Response(data: Data())

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
            let expectedResponse = Response(data: Data(), statusCode: 404)
            let serverResponse = Response(data: Data())
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
            let expectedResponse = Response(data: Data("real".utf8))
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
            #expect(true, "Error was thrown as expected")
        }
    }

    @Test("Multiple mocks, last one wins")
    func multipleMocks() async throws {
        try await withServer { _ in
            let request = Request(baseURL: "http://localhost:8083", path: "mock", method: .get)
            let firstMock = Response(data: Data("first".utf8))
            let secondMock = Response(data: Data("second".utf8))
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
            let mockResponse = Response(data: Data("mock".utf8))

            await client.mock(for: request, response: mockResponse)
            let mockedResponse = try await client.response(request) // This should use the mock
            #expect(mockedResponse.data == mockResponse.data, "Expected mocked response to be returned")
            // Clear mocks
            await client.mock(for: request, response: nil)

            // Now this should hit the server
            let expectedResponse = Response(data: Data("real".utf8))
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

            let request = Request(baseURL: "http://localhost:8083", path: "data", method: .get)
            let expectedData = TestData(id: 1, name: "Test")
            let expectedResponse = try Response(data: JSONEncoder().encode(expectedData))

            try await server.register(expectedResponse, for: request)

            let actualResponse: Response.JSON<TestData> = try await client.response(request.json(TestData.self))
            #expect(try actualResponse.value() == expectedData, "Expected decoded response to match the expected data")
        }
    }
}
