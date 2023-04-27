import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class AllProductPage extends StatefulWidget {
  const AllProductPage({Key? key}) : super(key: key);

  @override
  State<AllProductPage> createState() => _AllProductPageState();
}

class _AllProductPageState extends State<AllProductPage>
    with TickerProviderStateMixin {
  late TabController tabController;
  int index = 0;
  List data = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 9, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    List res = ModalRoute.of(context)!.settings.arguments as List;

    data = res[index]['products'];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(CupertinoIcons.arrow_left),
        ),
        title: Text(
          'Product',
          style: GoogleFonts.habibi(fontSize: 20, color: Colors.black),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: tabController,
          unselectedLabelStyle: const TextStyle(fontSize: 14),
          unselectedLabelColor: Colors.grey,
          indicatorWeight: 2.5,
          isScrollable: true,
          physics: const BouncingScrollPhysics(),
          indicatorSize: TabBarIndicatorSize.tab,
          onTap: (i) {
            setState(() {
              index = i;
            });
          },
          tabs: [
            Tab(
              child: Text(
                'Recommended',
                style: GoogleFonts.habibi(fontSize: 16),
              ),
            ),
            Tab(
              child: Text(
                'AC Services',
                style: GoogleFonts.habibi(fontSize: 16),
              ),
            ),
            Tab(
              child: Text(
                'Cleaning',
                style: GoogleFonts.habibi(fontSize: 16),
              ),
            ),
            Tab(
              child: Text(
                'Electronics',
                style: GoogleFonts.habibi(fontSize: 16),
              ),
            ),
            Tab(
              child: Text(
                'Furniture',
                style: GoogleFonts.habibi(fontSize: 16),
              ),
            ),
            Tab(
              child: Text(
                'Gardening',
                style: GoogleFonts.habibi(fontSize: 16),
              ),
            ),
            Tab(
              child: Text(
                'Painting',
                style: GoogleFonts.habibi(fontSize: 16),
              ),
            ),
            Tab(
              child: Text(
                'Plumbing',
                style: GoogleFonts.habibi(fontSize: 16),
              ),
            ),
            Tab(
              child: Text(
                'Solar',
                style: GoogleFonts.habibi(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: GridView.builder(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
          itemCount: data.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            mainAxisExtent: 225,
          ),
          itemBuilder: (context, i) {
            return GestureDetector(
              onTap: () {
                _launchUrl(url: data[i]['link']);
              },
              child: Card(
                margin: const EdgeInsets.all(0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Center(
                        child: Container(
                          height: 160,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(
                                  res[index]['products'][i]['imageURL']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 25,
                                width: 100,
                                child: Text(
                                  res[index]['products'][i]['name'],
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.habibi(fontSize: 16),
                                ),
                              ),
                              Text(
                                '₹ ${res[index]['products'][i]['price']}',
                                style: GoogleFonts.ubuntu(fontSize: 15),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.indigo.shade100,
                            ),
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.shopping_bag,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _launchUrl({required String url}) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
}
