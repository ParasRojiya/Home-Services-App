import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_services_app/helper/cloud_firestore_helper.dart';

import '../../../global/global.dart';
import '../../../global/snack_bar.dart';

class AddCardPage extends StatefulWidget {
  const AddCardPage({Key? key}) : super(key: key);

  @override
  State<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController holderNameController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiryMonthController = TextEditingController();
  TextEditingController expiryYearController = TextEditingController();
  TextEditingController cvvController = TextEditingController();

  String? cardHolderName;
  String? cardNumber;
  String? expiryMonth;
  String? expiryYear;
  String? cvvNumber;

  String expiryDate = 'DD/MM/YYYY';

  @override
  Widget build(BuildContext context) {
    dynamic res = ModalRoute.of(context)!.settings.arguments;

    if (res != null) {
      holderNameController.text = res['cardHolderName'];
      cardNumberController.text = res['cardNumber'];
      expiryMonthController.text =
          res['expiryDate'].toString().split('/').first;
      expiryYearController.text = res['expiryDate'].toString().split('/').last;
      cvvController.text = res['cvvNumber'];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Service Receipt',
          style: GoogleFonts.balooBhai2(fontSize: 20, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey.shade200,
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        alignment: Alignment.center,
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                height: 200,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/credit-card.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Card Holder Name :',
                style: GoogleFonts.balooBhai2(fontSize: 18),
              ),
              const SizedBox(height: 5),
              SizedBox(
                height: 70,
                child: TextFormField(
                  controller: holderNameController,
                  validator: (val) {
                    return (val!.isEmpty) ? 'Enter Card Holder Name ...' : null;
                  },
                  onSaved: (val) {
                    cardHolderName = val;
                  },
                  style:
                      GoogleFonts.balooBhai2(color: Colors.black, fontSize: 18),
                  decoration: decorationStyle(
                      hintText: "Enter card holder name",
                      label: "Card holder name"),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Card Number :',
                style: GoogleFonts.balooBhai2(fontSize: 18),
              ),
              const SizedBox(height: 5),
              SizedBox(
                height: 70,
                child: TextFormField(
                  controller: cardNumberController,
                  keyboardType: TextInputType.number,
                  onSaved: (val) {
                    cardNumber = val;
                  },
                  validator: (val) {
                    return (val!.isEmpty)
                        ? 'Enter Card Number ...'
                        : (val.length != 16)
                            ? "card number must be of 16 digits"
                            : null;
                  },
                  style:
                      GoogleFonts.balooBhai2(color: Colors.black, fontSize: 18),
                  decoration: decorationStyle(
                      hintText: "Enter card number", label: "Card Number"),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Expiry Date :',
                style: GoogleFonts.balooBhai2(fontSize: 18),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  SizedBox(
                    height: 70,
                    width: 120,
                    child: TextFormField(
                      controller: expiryMonthController,
                      onSaved: (val) {
                        expiryMonth = val;
                      },
                      keyboardType: TextInputType.number,
                      validator: (val) {
                        return (val!.isEmpty) ? 'Enter Month ...' : null;
                      },
                      style: GoogleFonts.balooBhai2(
                          color: Colors.black, fontSize: 18),
                      decoration: decorationStyle(
                          hintText: "Enter expiry month",
                          label: "Expiry Month"),
                    ),
                  ),
                  const SizedBox(width: 15),
                  SizedBox(
                    height: 70,
                    width: 120,
                    child: TextFormField(
                      controller: expiryYearController,
                      onSaved: (val) {
                        expiryYear = val;
                      },
                      keyboardType: TextInputType.number,
                      validator: (val) {
                        return (val!.isEmpty) ? 'Enter Year ...' : null;
                      },
                      style: GoogleFonts.balooBhai2(
                          color: Colors.black, fontSize: 18),
                      decoration: decorationStyle(
                          hintText: "Enter expiry year", label: "Expiry Year"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                'CVV :',
                style: GoogleFonts.balooBhai2(fontSize: 18),
              ),
              const SizedBox(height: 5),
              SizedBox(
                height: 70,
                child: TextFormField(
                  controller: cvvController,
                  onSaved: (val) {
                    cvvNumber = val;
                  },
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    return (val!.isEmpty) ? 'Enter Card CVV ...' : null;
                  },
                  style:
                      GoogleFonts.balooBhai2(color: Colors.black, fontSize: 18),
                  decoration: decorationStyle(
                      hintText: "Enter CVV Number", label: "CVV Number"),
                ),
              ),
              const SizedBox(height: 25),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();

                      Map<String, dynamic> card = {
                        'cardHolderName': cardHolderName,
                        'cardNumber': cardNumber,
                        'expiryDate': '$expiryMonth/$expiryYear',
                        'cvvNumber': cvvNumber,
                      };

                      Map<String, dynamic> data = {
                        'wallet': card,
                      };

                      await CloudFirestoreHelper.cloudFirestoreHelper
                          .updateUsersRecords(
                              id: Global.currentUser!['email'], data: data);

                      Get.back();
                      successSnackBar(
                          msg: (res != null)
                              ? "Wallet details updated successfully"
                              : "Wallet details added Successfully",
                          context: context);
                    }
                  },
                  child: Container(
                    height: 55,
                    width: 280,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.indigo,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.black38)),
                    child: Text(
                      'Add New Card',
                      style: GoogleFonts.balooBhai2(
                          fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  decorationStyle({required String hintText, required String label}) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.black),
      ),
      // contentPadding: const EdgeInsets.all(4),
      hintText: hintText,
      label: Text(label),
      hintStyle:
          GoogleFonts.balooBhai2(color: Colors.grey.shade600, fontSize: 16),
    );
  }
}
