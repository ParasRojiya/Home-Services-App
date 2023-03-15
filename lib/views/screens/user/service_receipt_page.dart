import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';

class ServiceReceiptPage extends StatefulWidget {
  const ServiceReceiptPage({Key? key}) : super(key: key);

  @override
  State<ServiceReceiptPage> createState() => _ServiceReceiptPageState();
}

class _ServiceReceiptPageState extends State<ServiceReceiptPage> {
  List data = [];

  final pdf = pw.Document();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Map<String, dynamic> res =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    data = [
      {'key': 'Name', 'value': res['Name']},
      {'key': 'Service', 'value': res['Service']},
      {'key': 'Category', 'value': res['Category']},
      {'key': 'Duration', 'value': res['Duration']},
      {'key': 'Date', 'value': res['Date']},
      {'key': 'Time', 'value': res['Time']},
    ];

    print(data);

    // res.forEach((key, value) {
    //   Map<String, dynamic> map = {'key': key, 'value': value};
    //   data.add(map);
    // });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Service Receipt',
          style: GoogleFonts.ubuntu(fontSize: 20, color: Colors.black),
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
                            'assets/images/barcode.png',
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
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: data.length,
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              Text(
                                '${data[i]['key']} :',
                                style: GoogleFonts.ubuntu(fontSize: 17),
                              ),
                              const Spacer(),
                              Text(
                                '${data[i]['value']}',
                                style: GoogleFonts.ubuntu(fontSize: 17),
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
                        style: GoogleFonts.ubuntu(fontSize: 18),
                      ),
                      const Spacer(),
                      Text(
                        '${res['Price']} RS.',
                        style: GoogleFonts.ubuntu(fontSize: 18),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      Text(
                        'Promo :',
                        style: GoogleFonts.ubuntu(fontSize: 18),
                      ),
                      const Spacer(),
                      Text(
                        '- 120 RS.',
                        style: GoogleFonts.ubuntu(fontSize: 18),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  const SizedBox(height: 10),
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
                        style: GoogleFonts.ubuntu(fontSize: 19),
                      ),
                      const Spacer(),
                      Text(
                        '${res['Price']} RS.',
                        style: GoogleFonts.ubuntu(fontSize: 19),
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
            GestureDetector(
              onTap: () async{
                await Printing.layoutPdf(onLayout: (format) => generatePDF(res: res));

                Directory? dir = await getExternalStorageDirectory();

                File file = File("${dir!.path}/Service Receipt.pdf");

                await file.writeAsBytes(await pdf.save());
              },
              child: Container(
                height: 60,
                alignment: Alignment.center,
                width: width * 0.85,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.indigo,
                ),
                child: Text(
                  'Download Receipt',
                  style: GoogleFonts.ubuntu(fontSize: 25, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<Uint8List> generatePDF ({required var res}) async {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final image = (await rootBundle.load('assets/images/barcode.png'))
        .buffer
        .asUint8List();

    print(data);

    try{
      pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              return pw.Container(
                color: PdfColors.red,
                height: height,
                width: width,
                child: pw.Column(
                  children: [
                    pw.SizedBox(
                      height: 20,
                    ),
                    pw.SizedBox(
                      height: 8,
                    ),
                    pw.Container(
                      height: height * 0.64,
                      width: width * 0.92,
                      decoration: pw.BoxDecoration(
                        borderRadius: pw.BorderRadius.circular(10),
                        color: PdfColors.white,
                      ),
                      child: pw.Column(
                        children: [
                          pw.Container(
                            margin:  pw.EdgeInsets.only(bottom: 5),
                            height: 15,
                            width: width,
                            decoration: pw.BoxDecoration(
                                borderRadius: pw.BorderRadius.only(
                                  topRight: pw.Radius.circular(10),
                                  topLeft: pw.Radius.circular(10),
                                ),
                                color: PdfColors.indigo),
                          ),
                          pw.Container(
                              height: 130,
                              width: width * 0.80,
                              child: pw.Image(pw.MemoryImage(image))
                            // decoration: pw.BoxDecoration(
                            //   image: pw.DecorationImage(
                            //       image: pw.Image(pw.MemoryImage(image)),
                            //       fit: pw.BoxFit.cover),
                            // ),
                          ),
                          pw.Divider(
                            color: PdfColors.black,
                            thickness: 1,
                            height: 1,
                            indent: 10,
                            endIndent: 10,
                          ),
                          pw.SizedBox(height: 12),
                          pw.Expanded(
                            child: pw.ListView.builder(
                              // physics: NeverScrollableScrollPhysics(),
                              itemCount: data.length,
                              itemBuilder: (context, i) {
                                return pw.Padding(
                                  padding: pw.EdgeInsets.all(8.0),
                                  child: pw.Row(
                                    children: [
                                      pw.SizedBox(width: 10),
                                      pw.Text(
                                        '${data[i]['key']} :',
                                        style: pw.TextStyle(
                                          font: pw.Font.times(),
                                          fontSize: 17,
                                        ),
                                        // style: GoogleFonts.ubuntu(fontSize: 17),
                                      ),
                                      pw.Spacer(),
                                      pw.Text(
                                        '${data[i]['value']}',
                                        style: pw.TextStyle(
                                          font: pw.Font.times(),
                                        ),
                                      ),
                                      pw.SizedBox(width: 10),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          pw.SizedBox(height: 10),
                          pw.Divider(
                            color: PdfColors.black,
                            thickness: 1,
                            height: 1,
                            indent: 10,
                            endIndent: 10,
                          ),
                          pw.SizedBox(
                            height: 10,
                          ),
                          pw.Row(
                            children: [
                              pw.SizedBox(width: 10),
                              pw.Text(
                                'Service Price :',
                                style: pw.TextStyle(
                                  font: pw.Font.times(),
                                  fontSize: 18,
                                ),
                              ),
                              pw.Spacer(),
                              pw.Text(
                                '${res['Price']} RS.',
                                style: pw.TextStyle(
                                  font: pw.Font.times(),

                                  fontSize: 18,

                                ),
                              ),
                              pw.SizedBox(width: 10),
                            ],
                          ),
                          pw.SizedBox(height: 10),
                          pw.Row(
                            children: [
                              pw.SizedBox(width: 10),
                              pw.Text(
                                'Promo :',
                                style: pw.TextStyle(
                                  font: pw.Font.times(),
                                  fontSize: 18,
                                ),
                              ),
                              pw.Spacer(),
                              pw.Text(
                                '- 120 RS.',
                                style: pw.TextStyle(
                                  font: pw.Font.times(),
                                  fontSize: 18,
                                ),
                              ),
                              pw.SizedBox(width: 10),
                            ],
                          ),
                          pw.SizedBox(height: 10),
                          pw.Divider(
                            color: PdfColors.black,
                            thickness: 1,
                            indent: 10,
                            endIndent: 10,
                            height: 1,
                          ),
                          pw.Divider(
                            color: PdfColors.black,
                            thickness: 1,
                            indent: 10,
                            endIndent: 10,
                            height: 2.5,
                          ),
                          pw.SizedBox(height: 8),
                          pw.Row(
                            children: [
                              pw.SizedBox(width: 10),
                              pw.Text(
                                'Total :',
                                style: pw.TextStyle(
                                  font: pw.Font.times(),
                                  fontSize: 19,
                                ),
                              ),
                              pw.Spacer(),
                              pw.Text(
                                '${res['Price']} RS.',
                                style: pw.TextStyle(
                                  font: pw.Font.times(),
                                  fontSize: 19,
                                ),
                              ),
                              pw.SizedBox(width: 10),
                            ],
                          ),
                          pw.SizedBox(height: 10),
                        ],
                      ),
                    ),
                    pw.SizedBox(
                      height: 40,
                    ),

                  ],
                ),
              );
            },
          )
      );
    }
    catch(e){
      print("Exception:$e");
    }
    return pdf.save();
  }

}
