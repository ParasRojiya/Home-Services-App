import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ServiceReceiptPage extends StatefulWidget {
  const ServiceReceiptPage({Key? key}) : super(key: key);

  @override
  State<ServiceReceiptPage> createState() => _ServiceReceiptPageState();
}

class _ServiceReceiptPageState extends State<ServiceReceiptPage> {
  List data = [
    {'key': 'Name', 'value': 'Paras Rojiya'},
    {'key': 'Service', 'value': 'General Services'},
    {'key': 'Category', 'value': 'AC Services'},
    {'key': 'Duration', 'value': '01:00 HR.'},
    {'key': 'Date', 'value': '20-03-2023'},
    {'key': 'Time', 'value': '04:00 PM'},
  ];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Service Receipt',
          style: GoogleFonts.habibi(fontSize: 20, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey.shade200,
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              height: height * 0.64,
              width: width * 0.92,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    height: 15,
                    width: width,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                        ),
                        color: Colors.indigo),
                  ),
                  Container(
                    height: 130,
                    width: width * 0.80,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            'assets/image/barcode.png',
                          ),
                          fit: BoxFit.cover),
                    ),
                  ),
                  const Divider(
                    color: Colors.black45,
                    thickness: 1,
                    height: 1,
                    indent: 10,
                    endIndent: 10,
                  ),
                  Expanded(
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data.length,
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              Text(
                                '${data[i]['key']} :',
                                style: GoogleFonts.balooBhai2(fontSize: 17),
                              ),
                              const Spacer(),
                              Text(
                                '${data[i]['value']}',
                                style: GoogleFonts.balooBhai2(fontSize: 17),
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(
                    color: Colors.black45,
                    thickness: 1,
                    height: 1,
                    indent: 10,
                    endIndent: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      Text(
                        'Service Price :',
                        style: GoogleFonts.balooBhai2(fontSize: 18),
                      ),
                      const Spacer(),
                      Text(
                        '250 RS.',
                        style: GoogleFonts.balooBhai2(fontSize: 18),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      Text(
                        'Promo :',
                        style: GoogleFonts.balooBhai2(fontSize: 18),
                      ),
                      const Spacer(),
                      Text(
                        '- 120 RS.',
                        style: GoogleFonts.balooBhai2(fontSize: 18),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Divider(
                    color: Colors.black,
                    thickness: 1,
                    indent: 10,
                    endIndent: 10,
                    height: 1,
                  ),
                  const Divider(
                    color: Colors.black,
                    thickness: 1,
                    indent: 10,
                    endIndent: 10,
                    height: 2.5,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      Text(
                        'Total :',
                        style: GoogleFonts.balooBhai2(fontSize: 19),
                      ),
                      const Spacer(),
                      Text(
                        '130 RS.',
                        style: GoogleFonts.balooBhai2(fontSize: 19),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              height: 60,
              alignment: Alignment.center,
              width: width * 0.85,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.indigo),
              child: Text(
                'Download Receipt',
                style: GoogleFonts.habibi(fontSize: 16, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
