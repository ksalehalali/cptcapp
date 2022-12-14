import 'dart:async';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../Assistants/globals.dart';
import '../../Data/current_data.dart';
import '../../controller/location_controller.dart';
import '../../controller/payment_controller.dart';
import '../widgets/QRCodeScanner.dart';
import '../widgets/headerDesgin.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DirectPayment extends StatefulWidget {
  @override
  State<DirectPayment> createState() => _DirectPaymentState();
}

class _DirectPaymentState extends State<DirectPayment> {
  final PaymentController paymentController = Get.find();
  final LocationController locationController = Get.find();
  final PaymentController walletController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = Get.size;

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [

            routes_color6,
            routes_color,
          ]
          )
      ),
      child: SafeArea(
        child: Scaffold(
          body: Stack(
              children: [
                Positioned(
                    top: 0.0,
                    width: screenSize.width,

                    child: SizedBox(
                        height: screenSize.height*0.1+11.h,
                        width: screenSize.width.w,
                        child: Header(screenSize))),
               Positioned(
                  top:screenSize.height *0.1 +50.h,
                  left: 0.w,
                  width: screenSize.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [
                      SizedBox(height: 16.h,),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 22.0.h),
                        child: Text(
                          "start_pay_txt".tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h,),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: DelayedDisplay(
                          child: Image.asset(
                            "${assetsDir}scanqrcode2.png",
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                      ),
                     SizedBox(height: screenSize.height*0.1-30.h,),
                      // QR SCAN BUTTON
                      DelayedDisplay(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            OutlinedButton.icon(
                              style: ButtonStyle(
                                backgroundColor:MaterialStateProperty.all(Colors.white),
                                foregroundColor: MaterialStateProperty.all(routes_color),
                                padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 12.h,horizontal: 6.w)),

                              ) ,
                              onPressed: ()async{
                              String balance = await checkWallet();
                              double balanceNum = double.parse(balance);
                              if(balanceNum >= 0.200) {
                                paymentController.ticketPayed.value = false;
                                scanQRCodeToPay(context,true);

                              } else {
                                Fluttertoast.showToast(
                                    msg: "msg_0_balance".tr,
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.white70,
                                    textColor: Colors.black,
                                    fontSize: 16.0.sp);
                              }
                            }, label: Text(
                              "Pay via scan QR code_txt".tr,
                              style: TextStyle(
                                  fontSize: 13.sp,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.bold

                              ),
                            ), icon: Icon(Icons.qr_code), ),
                            SizedBox(width:screenSize.width *0.1-26.w,),
                            OutlinedButton.icon(
                              style: ButtonStyle(
                                backgroundColor:MaterialStateProperty.all(Colors.white),
                                foregroundColor: MaterialStateProperty.all(routes_color),
                                padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 12,horizontal: 6)),
                              ) ,
                              onPressed: ()async{
                              await walletController.getPaymentCode();
                              Get.dialog(Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      15.0,
                                    ),
                                  ),
                                  elevation: 0,
                                  backgroundColor: Colors.transparent,
                                  child: Container(
                                    height:360.h,
                                    color: Colors.white,
                                    child: Center(
                                      child: QrImage(
                                        data: "{\"userId\":\"${user.id!}\",\"userName\":\"${user.name}\",\"paymentCode\":\"${user.PaymentCode}\"}",
                                        version: QrVersions.auto,
                                        size: 250.0.sp,
                                      ),
                                    ),
                                  )
                              ));
                              print("{\"userId\":\"${user.id!}\",\"userName\":\"${user.name}\",\"paymentCode\":\"${user.PaymentCode}\"}");
                            }, icon: Icon(Icons.qr_code),
                            label:Text(
                              "Pay via show QR code_txt".tr,
                              style: TextStyle(
                                  fontSize: 13.sp,
                                  letterSpacing: 0,
                                fontWeight: FontWeight.bold
                              ),
                            ), ),
                          ],
                        ),
                      ),
                      SizedBox(height: 32.h,)
                    ],
                  ),
                ),
              ],
          ),
        ),
      ),
    );
  }

  Future<String> checkWallet() async{
    await paymentController.getMyWallet();
    return paymentController.myBalance.value;
  }

}

