import Foundation
import Domain

func makeAccountModel() -> AccountModel {
    return AccountModel(id: "someId", name: "anyName", email: "anyEmail", password: "anyPassword")
}
