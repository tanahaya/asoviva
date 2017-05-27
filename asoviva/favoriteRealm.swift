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
class favoriteRealm: Object{
    
    static let realm = try! Realm()
    
    private var id:Int = 0
    var storename:String!
    var lat: Double!
    var lng: Double!
    var vicinity:String!
    var placeid:String!
    var extended: Bool = false
    
    
    override static func primaryKey() -> String {
        return "id"
    }
    static func create(storename:String,lat:Double,lng:Double,vicinity:String,placeid:String) -> favoriteRealm {
        
        let storedata = favoriteRealm()
        storedata.storename = storename
        storedata.lat = lat
        storedata.lng = lng
        storedata.vicinity = vicinity
        storedata.placeid = placeid
        return storedata
        
        
        
    }
    static func update(model:favoriteRealm,content: String,dueDate:NSDate,importance:Int) {
        try! realm.write({
            /*
             model.name = content
             model.due_date = dueDate
             model.isDone = 0
             */
            
        })
    }
    static func fetch(FetchType type: FetchType) -> [favoriteRealm] {
        // .Allなら全件、.UnDoneなら未完了のデータを取得する
        switch type {
        case .All:
            return loadAll()
        }
    }
    static func loadAll() -> [favoriteRealm] {
        // idでソートしながら、全件取得
        let todos = realm.objects(favoriteRealm.self).sorted(byKeyPath: "due_date", ascending: true)
        // 取得したデータを配列にいれる
        var ret: [favoriteRealm] = []
        for todo in todos {
            ret.append(todo)
        }
        return ret
    }
    static func lastId() -> Int {
        // isDoneの値を変更するとデータベース上の順序が変わるために、以下のようにしてidでソートして最大値を求めて+1して返す
        // 更新の必要がないなら、 realm.objects(ToDoModel).last で最後のデータのidを取得すればよい
        if let todo = realm.objects(favoriteRealm.self).sorted(byKeyPath: "id", ascending: false).first {
            return todo.id + 1
        }else {
            return 1
        }
    }
    
    // ローカルのdefault.realmに作成したデータを保存するメソッド
    func save() {
        // writeでtransactionを生む
        try! favoriteRealm.realm.write {
            // モデルを保存
            favoriteRealm.realm.add(self)
        }
    }
    
    // TODO: UITableViewRowActionからインスタンスを送れない
    func delete(idOfDelete id: Int)  {
        let item = favoriteRealm.realm.objects(favoriteRealm.self)[id]
        try! favoriteRealm.realm.write {
            favoriteRealm.realm.delete(item)
        }
    }
    
    func updateDone(idOfUpdate id: Int) {
        let item = favoriteRealm.realm.objects(favoriteRealm.self)[id]
        try! favoriteRealm.realm.write {
            // item.isDone = 1
        }
    }
    
    
}
