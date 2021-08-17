import 'package:flutter/material.dart';
import 'package:flutter_khalti/flutter_khalti.dart';
import 'package:khalti_integration/amount_list.dart';

// * solve android label conflicts with
/* 
  android>>app>main>AndroidManifest.xml
  Action 1: Add this inside manifest tag
   xmlns:tools = "http://schemas.android.com/tools" 

   Action 2: Add below element inside application tag
   tools:replace="android:label" 

  Action 3: Run the cmd 
  flutter packages get
*/

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int _dropDownValue = amountList[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.payment,
            color: Color(0xff5D2E8E),
          ),
        ),
        title: Text(
          "Khalti Integration",
          style: TextStyle(
            color: Color(0xff5D2E8E),
          ),
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(40),
              child: DropdownButton(
                elevation: 4,
                autofocus: true,
                focusColor: Colors.lightBlue,
                icon: Icon(Icons.keyboard_arrow_down),
                iconEnabledColor: Colors.green,
                iconDisabledColor: Colors.red,
                isExpanded: false,
                isDense: false,
                dropdownColor: Colors.white,
                value: _dropDownValue,
                items: amountList.map((int itemValue) {
                  return DropdownMenuItem<int>(
                    value: itemValue,
                    child: Text('Rs $itemValue'),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _dropDownValue = newValue
                        as int; // typecasting conflicts removed by this
                  });
                },
                hint: Text(
                  "Please select the payment amount",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 120.0,
              height: 40.0,
              child: ElevatedButton(
                child: Text(
                  'Pay via Khalti',
                  textAlign: TextAlign.center,
                ),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xff5D2E8E))),
                onPressed: () {
                  _paymentWithKhalti(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _paymentWithKhalti(BuildContext context) {
    // conversion into paisa
    double amountValue = _dropDownValue.toDouble() * 100;

    // public key from merchant account
    FlutterKhalti _flutterkhalti = FlutterKhalti.configure(
      publicKey: ' test_public_key_62b088096c05433e8188f8432cbf369a',
      urlSchemeIOS: 'KhaltiPayFlutterExampleScheme',
      paymentPreferences: [
        KhaltiPaymentPreference.KHALTI,
      ],
    );

    KhaltiProduct product = KhaltiProduct(
        id: "testAdmin", name: "Payment Test", amount: amountValue);

    _flutterkhalti.startPayment(
      product: product,
      onSuccess: (data) {
        print("Payment Successful!");
      },
      onFaliure: (error) {
        print("Payment Failed!\nTry again.");
      },
    );
  }
}
