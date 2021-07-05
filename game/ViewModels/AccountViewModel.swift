//
//  AccountViewModel.swift
//  game
//
//  Created by 張凱翔 on 2021/7/1.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import FirebaseStorageSwift

// HomeView
func getSafeArea()->UIEdgeInsets{
    return UIApplication.shared.windows.first?.safeAreaInsets ??  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
}

//SignUpview
enum ActiveAlert{
    case confirmPasswordError,authError
}
//新增個人資料
func creatUser(store: UserData, email: String){
    let db = Firestore.firestore()
    let user = store
    do{
        try db.collection("users").document(email).setData(from: user)
        
    }catch {
        
        print(error)
    }
            
   
}

//抓資料
func fetchPlayers(email:String,completion: @escaping(Result<UserData,Error>)->Void){
    let db = Firestore.firestore()
    db.collection("users").document(email).getDocument { document, error in
        
        guard let document = document,document.exists,let user = try?document.data(as: UserData.self)else
        {
            if let error = error{
                print("抓取失敗")
                print(error.localizedDescription)
                completion(.failure(error))
            }
            
            return
        }
        print(document.documentID )
        
        completion(.success(user))
    }
}
//登出
func SignOut() -> Void {
    do {
        try Auth.auth().signOut()
        if Auth.auth().currentUser == nil {
            print("登出成功")
        }
    }
    catch {
        print("登出錯誤")
    }
}
//修改個人資料
func modifyUserData(email:String,name:String,gender:String) {
        let db = Firestore.firestore()
        let documentReference =
            db.collection("users").document(email)
        documentReference.getDocument { document, error in
                   
          guard let document = document,
                document.exists,
                var user = try? document.data(as: UserData.self)
          else {
                    return
          }
            
            user.name = name
            user.gender = gender
          do {
             try documentReference.setData(from: user)
              
          } catch {
             print(error)
          }
                        
        }
}

func modifyImgURL(email: String,url: String){
    let db = Firestore.firestore()
    let documentReference =
        db.collection("users").document(email)
    documentReference.getDocument { document, error in
               
      guard let document = document,
            document.exists,
            var user = try? document.data(as: UserData.self)
      else {
                return
      }
        
        user.imgURL = url
      do {
         try documentReference.setData(from: user)
          
      } catch {
         print(error)
      }
                    
    }
}

//上傳照片
func uploadPhoto(image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        
        let fileReference = Storage.storage().reference().child(UUID().uuidString + ".jpg")
        if let data = image.jpegData(compressionQuality: 0.9) {
            
            fileReference.putData(data, metadata: nil) { result in
                switch result {
                case .success(_):
                    fileReference.downloadURL { result in
                        switch result {
                        case .success(let url):
                            completion(.success(url))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
}

func setUserPhoto(url: URL) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.photoURL = url
        changeRequest?.commitChanges(completion: { error in
           guard error == nil else {
               print(error?.localizedDescription)
               return
           }
        })
}
