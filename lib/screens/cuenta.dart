// ignore_for_file: deprecated_member_use

import 'package:avu/screens/new_password.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final userData = await _firestore.collection('users').doc(user.uid).get();
      //Comprobar que el usuario exista gg
      if (userData.exists) {
        setState(() {
          nameController.text = userData['name'] ?? '';
          emailController.text = userData['email'] ?? '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuenta'),
        backgroundColor: const Color(0xFF9E0044),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;

          return Container(
            width: screenWidth,
            height: screenHeight,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: screenWidth * 0.7,
                  child: TextField(
                    controller: nameController,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: screenWidth * 0.043,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      height: 0.09,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                    ),
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.7,
                  child: TextField(
                    controller: emailController,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: screenWidth * 0.043,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      height: 0.09,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9E0044),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  onPressed: () {
                    // Actualizar
                    final User? user = _auth.currentUser;
                    if (user != null) {
                      user.updateProfile(displayName: nameController.text);

                      // Actualizar en la base de datos
                      _firestore.collection('users').doc(user.uid).update({
                        'name': nameController.text,
                        'email': emailController.text,
                      });
                    }
                  },
                  child: const Text('Cambiar perfil'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9E0044),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  onPressed: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NewPassword()),
                    );
                  },
                  child: const Text('Cambiar Contraseña'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
