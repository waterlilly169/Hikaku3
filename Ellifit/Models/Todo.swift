
import Foundation

struct Todo: Codable, Equatable, Identifiable, Hashable {

    var id: String
    var email: String
    var styleboardname: String
    var styleboardimages: [String: String]
}
