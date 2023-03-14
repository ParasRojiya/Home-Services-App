import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  String expiryDate = 'DD/MM/YYYY';

  @override
  Widget build(BuildContext context) {
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
                    image: AssetImage('assets/image/credit-card.png'),
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
                height: 55,
                child: TextFormField(
                  controller: holderNameController,
                  validator: (val) {
                    return (val!.isEmpty) ? 'Enter Card Holder Name ...' : null;
                  },
                  style:
                      GoogleFonts.balooBhai2(color: Colors.black, fontSize: 17),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    contentPadding: const EdgeInsets.all(10),
                    hintText: "Enter Card Holder Name",
                    hintStyle: GoogleFonts.balooBhai2(
                        color: Colors.grey.shade600, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Card Number :',
                style: GoogleFonts.balooBhai2(fontSize: 18),
              ),
              const SizedBox(height: 5),
              SizedBox(
                height: 55,
                child: TextFormField(
                  controller: cardNumberController,
                  validator: (val) {
                    return (val!.isEmpty) ? 'Enter Card Number ...' : null;
                  },
                  style:
                      GoogleFonts.balooBhai2(color: Colors.black, fontSize: 17),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    contentPadding: const EdgeInsets.all(10),
                    hintText: "Enter Card Number",
                    hintStyle: GoogleFonts.balooBhai2(
                        color: Colors.grey.shade600, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Expiry Date :',
                style: GoogleFonts.balooBhai2(fontSize: 18),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  SizedBox(
                    height: 55,
                    width: 100,
                    child: TextFormField(
                      controller: expiryMonthController,
                      validator: (val) {
                        return (val!.isEmpty) ? 'Enter Month ...' : null;
                      },
                      style: GoogleFonts.balooBhai2(
                          color: Colors.black, fontSize: 17),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        contentPadding: const EdgeInsets.all(10),
                        hintText: "Month",
                        hintStyle: GoogleFonts.balooBhai2(
                            color: Colors.grey.shade600, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  SizedBox(
                    height: 55,
                    width: 100,
                    child: TextFormField(
                      controller: expiryYearController,
                      validator: (val) {
                        return (val!.isEmpty) ? 'Enter Year ...' : null;
                      },
                      style: GoogleFonts.balooBhai2(
                          color: Colors.black, fontSize: 17),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        contentPadding: const EdgeInsets.all(10),
                        hintText: "Year",
                        hintStyle: GoogleFonts.balooBhai2(
                            color: Colors.grey.shade600, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                'CVV :',
                style: GoogleFonts.balooBhai2(fontSize: 18),
              ),
              const SizedBox(height: 3),
              SizedBox(
                height: 55,
                child: TextFormField(
                  controller: cvvController,
                  validator: (val) {
                    return (val!.isEmpty) ? 'Enter Card CVV ...' : null;
                  },
                  style:
                      GoogleFonts.balooBhai2(color: Colors.black, fontSize: 17),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    contentPadding: const EdgeInsets.all(10),
                    hintText: "Enter Card Number",
                    hintStyle: GoogleFonts.balooBhai2(
                        color: Colors.grey.shade600, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Center(
                child: GestureDetector(
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      Map card = {
                        'name': holderNameController.text,
                        'number': cardNumberController.text,
                        'expiry':
                            '${expiryMonthController.text}/${expiryYearController.text}',
                        'cvv': cvvController.text,
                      };
                      print(card);
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
}
