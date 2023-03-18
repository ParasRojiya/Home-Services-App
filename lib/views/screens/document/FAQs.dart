import 'package:flutter/material.dart';

class FAQs extends StatefulWidget {
  const FAQs({Key? key}) : super(key: key);

  @override
  State<FAQs> createState() => _FAQsState();
}

class _FAQsState extends State<FAQs> {
  bool active1 = false;
  bool active2 = false;
  bool active3 = false;
  bool active4 = false;
  bool active5 = false;
  bool active6 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_outlined,
            color: Colors.black,
            size: 30,
          ),
        ),
        title: const Text(
          "FAQs",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            ExpansionPanelList(
              expansionCallback: (panelIndex, isExpanded) {
                active1 = !active1;
                setState(() {});
              },
              children: <ExpansionPanel>[
                ExpansionPanel(
                  headerBuilder: (context, isExpanded) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        SizedBox(width: 10),
                        Icon(
                          Icons.circle,
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Who can utilise Home Services?",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  },
                  body: ListTile(
                    title: Text(
                      "The customer has a choice to choose additional quantity of products from the list of Add-ons during sign up. The Add-ons are attractively priced to ensure customers with an additional TV, or an AC, etc. are able to buy the right plan with necessary Add-ons for their entire household.",
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                  ),
                  isExpanded: active1,
                  canTapOnHeader: true,
                ),
              ],
            ),
            ExpansionPanelList(
              expansionCallback: (panelIndex, isExpanded) {
                active2 = !active2;
                setState(() {});
              },
              children: <ExpansionPanel>[
                ExpansionPanel(
                  headerBuilder: (context, isExpanded) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        SizedBox(width: 10),
                        Icon(
                          Icons.circle,
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "What do you mean by visits?",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  },
                  body: ListTile(
                    title: Text(
                      "When a customer registers for a repair or general service, the same will be considered as a visit.",
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                  ),
                  isExpanded: active2,
                  canTapOnHeader: true,
                ),
              ],
            ),
            ExpansionPanelList(
              expansionCallback: (panelIndex, isExpanded) {
                active3 = !active3;
                setState(() {});
              },
              children: <ExpansionPanel>[
                ExpansionPanel(
                  headerBuilder: (context, isExpanded) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        SizedBox(width: 10),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Icon(
                            Icons.circle,
                            size: 20,
                          ),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          child: Text(
                            "What happens if i have additional\nquantities of products more than\nwhat is in the current packages?",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  body: ListTile(
                    title: Text(
                      "The customer has a choice to choose additional quantity of products from the list of Add-ons during sign up. The Add-ons are attractively priced to ensure customers with an additional TV, or an AC, etc. are able to buy the right plan with necessary Add-ons for their entire household.",
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                  ),
                  isExpanded: active3,
                  canTapOnHeader: true,
                ),
              ],
            ),
            ExpansionPanelList(
              expansionCallback: (panelIndex, isExpanded) {
                active4 = !active4;
                setState(() {});
              },
              children: <ExpansionPanel>[
                ExpansionPanel(
                  headerBuilder: (context, isExpanded) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        SizedBox(width: 10),
                        Icon(
                          Icons.circle,
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "What is Pay per Call?",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  },
                  body: ListTile(
                    title: Text(
                      "For customers who have consumed their allotted service visits or who have not taken any Add-ons for the additional products then they can avail the services of Home Serve by paying for the service on a need basis as per the “Pay per Call” rate card.",
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                  ),
                  isExpanded: active4,
                  canTapOnHeader: true,
                ),
              ],
            ),
            ExpansionPanelList(
              expansionCallback: (panelIndex, isExpanded) {
                active5 = !active5;
                setState(() {});
              },
              children: <ExpansionPanel>[
                ExpansionPanel(
                  headerBuilder: (context, isExpanded) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        SizedBox(width: 10),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Icon(
                            Icons.circle,
                            size: 20,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Do you provide any service\nwarranty?",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  },
                  body: ListTile(
                    title: Text(
                      "All services carry a 30 day service warranty. If there is a repeat service fault within 30 days then the service is done once again without considering it as another service visit.",
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                  ),
                  isExpanded: active5,
                  canTapOnHeader: true,
                ),
              ],
            ),
            ExpansionPanelList(
              expansionCallback: (panelIndex, isExpanded) {
                active6 = !active6;
                setState(() {});
              },
              children: <ExpansionPanel>[
                ExpansionPanel(
                  headerBuilder: (context, isExpanded) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        SizedBox(width: 10),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Icon(
                            Icons.circle,
                            size: 20,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Do you provide any parts\nwarranty?",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  },
                  body: ListTile(
                    title: Text(
                      "All parts carry a 30 day parts warranty. Parts warranty however does not apply to accessories, power adapters, jars, batteries, consumables like coffee filters, mesh, etc.",
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                  ),
                  isExpanded: active6,
                  canTapOnHeader: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
