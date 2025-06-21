import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_proj/Login.dart';
import 'HomePage.dart';
final FirebaseAuth _auth = FirebaseAuth.instance;
class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override

  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final imageUrlController = TextEditingController();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    final currentUser = auth.currentUser;
    if (currentUser != null) {
      final userDoc =
      await firestore.collection("users").doc(currentUser.uid).get();
      final userData = userDoc.data() as Map<String, dynamic>;

      nameController.text = userData["username"] ?? "";
      emailController.text = userData["email"] ?? "";
      imageUrlController.text = userData["avatar"] ?? "";

      setState(() {
        isLoading = false;
      });
    }
  }

  void updateProfile() async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        await firestore.collection("users").doc(user.uid).update({
          "username": nameController.text.trim(),
          "email": emailController.text.trim(),
          "avatar": imageUrlController.text.trim(),

        });

        await user.updateDisplayName(nameController.text.trim());
        await user.updatePhotoURL(imageUrlController.text.trim());
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Profile updated successfully")),
        );
      }
    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating profile")),
      );
    }
  }

  void changePassword() async {
    final user = auth.currentUser;
    if (user != null) {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPasswordController.text.trim(),
      );
      try {
        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPasswordController.text.trim());

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Password changed successfully")),
        );
      } catch (e) {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Wrong old password or other error")),
        );
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [ IconButton(onPressed: ()async{
        _auth.signOut();
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>  Login()));
      }, icon: Icon(Icons.exit_to_app))],
        backgroundColor: Color(0xFFB2594B),
        title: Text('Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
             Navigator.push(context, MaterialPageRoute(builder: (_)=> Homepage()));
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(
                imageUrlController.text.isNotEmpty
                    ? imageUrlController.text
                    : "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png",
              ),
            ),
            SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: "Username"),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(labelText: "Email"),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: imageUrlController,
                      decoration:
                      InputDecoration(labelText: "Profile Image URL"),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: updateProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFB2594B),
                      ),
                      child: Text(
                        "Update Profile",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: oldPasswordController,
                      obscureText: true,
                      decoration:
                      InputDecoration(labelText: "Old Password"),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: newPasswordController,
                      obscureText: true,
                      decoration:
                      InputDecoration(labelText: "New Password"),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: changePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFB2594B),
                      ),
                      child: Text(
                        "Change Password",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}