import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../global/global.dart';

class Bookings extends StatefulWidget {
  const Bookings({Key? key}) : super(key: key);

  @override
  State<Bookings> createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  List isOpen = [];
  @override
  Widget build(BuildContext context) {
    dynamic res = Get.arguments;
    List bookings = res;
    for (var book in bookings) {
      bool isOpenPanel = false;
      isOpen.add(isOpenPanel);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(Global.title),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: bookings.length,
          itemBuilder: (context, i) {
            return Card(
              child: ExpansionPanelList(
                expansionCallback: (panelIndex, isExpanded) {
                  setState(() {
                    isOpen[i] = !isOpen[i];
                  });
                },
                expandedHeaderPadding: const EdgeInsets.all(0),
                elevation: 0,
                children: <ExpansionPanel>[
                  ExpansionPanel(
                    headerBuilder: (context, isExpanded) {
                      return Container(
                        height: 130,
                        width: Get.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 8),
                            Container(
                              height: 105,
                              width: 115,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: NetworkImage(bookings[i]['imageURL']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Text(
                                  bookings[i]['serviceCategory'],
                                  style: GoogleFonts.poppins(fontSize: 13),
                                ),
                                const SizedBox(height: 5),
                                SizedBox(
                                  height: 25,
                                  width: 150,
                                  child: Text(
                                    bookings[i]['serviceName'],
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.indigo),
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  '₹ ${bookings[i]['servicePrice']}',
                                  style: GoogleFonts.poppins(fontSize: 13),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.person,
                                      size: 20,
                                      color: Colors.black54,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      '${bookings[i]['customerName']}',
                                      style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          color: Colors.indigo[500]),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                    body: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const SizedBox(width: 8),
                              Text(
                                'Date',
                                style: GoogleFonts.poppins(fontSize: 14),
                              ),
                              const Spacer(),
                              Text(
                                bookings[i]['SelectedDateTime']
                                    .split(' ')
                                    .first,
                                style: GoogleFonts.poppins(fontSize: 14),
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const SizedBox(width: 8),
                              Text(
                                'Time',
                                style: GoogleFonts.poppins(fontSize: 14),
                              ),
                              const Spacer(),
                              Text(
                                '${bookings[i]['SelectedDateTime'].split(' ').elementAt(1)} ${bookings[i]['SelectedDateTime'].split(' ').last}',
                                style: GoogleFonts.poppins(fontSize: 14),
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const SizedBox(width: 8),
                              Text(
                                'Duration',
                                style: GoogleFonts.poppins(fontSize: 14),
                              ),
                              const Spacer(),
                              Text(
                                '${bookings[i]['duration']} Min',
                                style: GoogleFonts.poppins(fontSize: 14),
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const SizedBox(width: 8),
                              Text(
                                'Worker',
                                style: GoogleFonts.poppins(fontSize: 14),
                              ),
                              const Spacer(),
                              Text(
                                bookings[i]['workerName'],
                                style: GoogleFonts.poppins(fontSize: 14),
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const SizedBox(width: 8),
                              Text(
                                'Phone Number',
                                style: GoogleFonts.poppins(fontSize: 14),
                              ),
                              const Spacer(),
                              Text(
                                '+91 ${bookings[i]['workerNumber']}',
                                style: GoogleFonts.poppins(fontSize: 14),
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    isExpanded: isOpen[i],
                    canTapOnHeader: true,
                    backgroundColor: Colors.transparent,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
