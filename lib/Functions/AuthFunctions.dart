import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

signup(String username,String email,String password) async{
  UserCredential authResult;
  try {
    authResult = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email, password: password);
    await FirebaseFirestore.instance.collection('Users').doc(authResult.user!.uid).set(
        {
          "id": authResult.user!.uid.toString(),
          "name": username.toString(),
          "email": email.toString()
        });
  }on FirebaseAuthException catch(e){
    if(e.code == 'password-week'){
      print("Week Password");
    }
  }catch(e){
      print(e);
  }
}

login(String email,String Password)async{
  try{
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: Password).then((e){
      print("User Loginned Successfull");
    });
  }on FirebaseAuthException catch(e){
    print(e.code.toString());
  }catch(e){
    print(e.toString());
  }
}