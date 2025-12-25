import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'AddAddressScreen.dart';
import '../Services/TranslationService.dart';

class AddressListScreen extends ConsumerWidget {
  const AddressListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    final currentLang = ref.watch(languageProvider);
    String tr(String key) => AppLocalizations.of(currentLang, key);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          tr('your_address'),
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddAddressScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add, color: Colors.green),
          ),
        ],
      ),
      body: user?.phoneNumber == null
          ? Center(child: Text(tr('user_not_identified')))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('User')
                  .doc(user!.phoneNumber)
                  .collection('Addresses')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.green),
                  );
                }

                if (snapshot.hasError) {
                  return const Center(child: Text("Error loading addresses"));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          IconlyLight.location,
                          size: 80,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          tr('no_orders'),
                        ), // Reusing generic empty message or similar if specific one not added, or 'no_orders'
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddAddressScreen(),
                              ),
                            );
                          },
                          child: Text(tr('add_new_address')),
                        ),
                      ],
                    ),
                  );
                }

                final docs = snapshot.data!.docs;
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Colors.green.shade50,
                      child: ListTile(
                        leading: const Icon(
                          IconlyBold.location,
                          color: Colors.green,
                        ),
                        title: Text(
                          data['street'] ?? tr('street'),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "${data['city']}, ${data['state']} ${data['zip']}\n${data['country']}",
                        ),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: const Icon(
                            IconlyLight.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('User')
                                .doc(user.phoneNumber)
                                .collection('Addresses')
                                .doc(docs[index].id)
                                .delete();
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
