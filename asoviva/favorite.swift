//
//  favoriteRealm.swift
//  asoviva
//
//  Created by 田中千洋 on 2017/05/17.
//  Copyright © 2017年 田中 颯. All rights reserved.
//

import UIKit
import RealmSwift

public enum FetchType { // 取得するデータを決めるためのenum
    case All // すべてのToDoを取得するためのenum
}
class favorite: Object{
    
    static let realm = try! Realm()
    
    dynamic var id:Int = 0
    dynamic var storename:String!
    dynamic var lat: Double = 0.0
    dynamic var lng: Double = 0.0
    dynamic var vicinity:String!
    dynamic var placeid:String!
    dynamic var extended: Bool = false
    
    
    override static func primaryKey() -> String {
        return "id"
    }
    static func create(storename:String,lat:Double,lng:Double,vicinity:String,placeid:String) -> favorite {
        
        let storedata = favorite()
        storedata.storename = storename
        storedata.lat = lat
        storedata.lng = lng
        storedata.vicinity = vicinity
        storedata.placeid = placeid
        return storedata
        
        
        
    }
    static func update(model:favorite,extended: Bool) {
        try! realm.write({
            /*
             model.name = content
             model.due_date = dueDate
             model.isDone = 0
             */
            model.extended = extended
        })
    }
    static func fetch(FetchType type: FetchType) -> [favorite] {
        // .Allなら全件、.UnDoneなら未完了のデータを取得する
        switch type {
        case .All:
            return loadAll()
        }
    }
    static func loadAll() -> [favorite] {
        // idでソートしながら、全件取得
        let favoritesarray = realm.objects(favorite.self).sorted(byKeyPath: "id", ascending: true)
        // 取得したデータを配列にいれる
        var ret: [favorite] = []
        for favoritedata in favoritesarray {
            ret.append(favoritedata)
        }
        return ret
    }
    static func lastId() -> Int {
        // isDoneの値を変更するとデータベース上の順序が変わるために、以下のようにしてidでソートして最大値を求めて+1して返す
        // 更新の必要がないなら、 realm.objects(ToDoModel).last で最後のデータのidを取得すればよい
        if let todo = realm.objects(favorite.self).sorted(byKeyPath: "id", ascending: false).first {
            return todo.id + 1
        }else {
            return 1
        }
    }
    
    // ローカルのdefault.realmに作成したデータを保存するメソッド
    func save() {
        // writeでtransactionを生む
        try! favorite.realm.write {
            // モデルを保存
            favorite.realm.add(self)
        }
    }
    
    // TODO: UITableViewRowActionからインスタンスを送れない
    func delete(idOfDelete id: Int)  {
        let item = favorite.realm.objects(favorite.self)[id]
        try! favorite.realm.write {
            favorite.realm.delete(item)
        }
    }
    
    func updateDone(idOfUpdate id: Int) {
        let item = favorite.realm.objects(favorite.self)[id]
        try! favorite.realm.write {
            // item.isDone = 1
        }
    }
    
    
}
