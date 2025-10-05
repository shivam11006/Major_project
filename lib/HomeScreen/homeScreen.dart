import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hi Shivam 👋",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              "Enjoy our services",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton.filledTonal(
              onPressed: () {},
              icon: Icon(IconlyBroken.notification),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          //Filter and search in Row
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search here...",
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(99),
                        borderSide: BorderSide(color: Colors.green.shade300),
                      ),
                      prefixIcon: Icon(IconlyBroken.search),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton.filled(
                    onPressed: () {},
                    icon: Icon(IconlyLight.filter),
                  ),
                ),
              ],
            ),
          ),

          //   Consultation card
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: SizedBox(
              height: 170,
              child: Card(
                color: Colors.green.shade50,
                elevation: 0.1,
                shadowColor: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Free Consultation",
                              style: Theme.of(context).textTheme.titleLarge!
                                  .copyWith(color: Colors.green.shade700),
                            ),
                            Text("Get free support from our customer services"),
                            FilledButton(onPressed: () {}, child: Text("Call Us")),
                          ],
                        ),
                      ),
                      //Image
                      Image.asset("assets/contact_us.png",width: 140,)
                    ],
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Featured Product"),
              TextButton(onPressed: (){}, child: Text("See all"))

            ],
          )

        ],
      ),
    );
  }
}
