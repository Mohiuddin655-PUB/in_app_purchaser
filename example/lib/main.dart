import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchaser/in_app_purchaser.dart';
import 'package:in_app_purchaser_revenue_cat_delegate/in_app_purchaser_revenue_cat_delegate.dart';

const kQonversionApiKey = "";

void main() {
  runApp(
    PurchaseProvider(
      delegate: const RevenueCatDelegate(
        apiKey: kQonversionApiKey,
      ),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'In App Purchaser',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const PurchasePaywall(),
    );
  }
}

class PurchasePaywall extends StatelessWidget {
  const PurchasePaywall({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Stack(
            children: [
              ListenableBuilder(
                listenable: Purchaser.i,
                builder: (context, child) {
                  return const PurchaseButton();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PurchaseButton extends StatefulWidget {
  const PurchaseButton({
    super.key,
  });

  @override
  State<PurchaseButton> createState() => _PurchaseButtonState();
}

class _PurchaseButtonState extends State<PurchaseButton> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Get Unlimited Access',
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Column(
              children: List.generate(Purchaser.i.products.length, (index) {
                final product = Purchaser.i.products.elementAtOrNull(index);
                final priceString = product?.priceString ?? '0 BDT';
                final monthlyPrice = (product?.price ?? 0) / 12;
                return MonthlyPlan(
                  leftSideString: priceString,
                  selected: selected == index,
                  rightSideString: monthlyPrice.toString(),
                  discount: "25%",
                  onTap: () => setState(() => selected = index),
                );
              }),
            ),
            const SizedBox(height: 5),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => Purchaser.i.purchaseAt(selected),
              child: Container(
                height: 65,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1000),
                  color: Colors.black,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                alignment: Alignment.center,
                child: Builder(builder: (context) {
                  if (Purchaser.i.products.isEmpty) {
                    return const SizedBox.square(
                      dimension: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    );
                  }
                  return const FittedBox(
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  );
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    child: const Text(
                      'Terms ',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.grey,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: Purchaser.i.restore,
                    child: const Text(
                      'Restore ',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.grey,
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: const Text(
                      'Privacy ',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.grey,
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: const Text(
                      'User ID ',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MonthlyPlan extends StatelessWidget {
  final String leftSideString;
  final bool selected;
  final String rightSideString;
  final String? discount;
  final VoidCallback onTap;

  const MonthlyPlan({
    super.key,
    required this.leftSideString,
    required this.selected,
    required this.rightSideString,
    required this.onTap,
    this.discount,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        height: 76,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? Colors.black : Colors.transparent,
            width: 3,
          ),
        ),
        padding: const EdgeInsets.only(
          right: 20,
          left: 15,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.centerLeft,
          children: [
            Text(
              leftSideString,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text.rich(
                textScaler: TextScaler.noScaling,
                TextSpan(
                  children: [
                    TextSpan(
                      text: rightSideString, //inchToReadableFt(heightHive),
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    // TextSpan(
                    //   text: extension,
                    //   style: const TextStyle(
                    //     fontFamily: defaultFont,
                    //     fontSize: Sizex.h6 + 1,
                    //     fontWeight: Weightx.heavy,
                    //     color: Colorx.black,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            if ((discount ?? '').isNotEmpty) ...[
              Positioned(
                top: -15,
                right: -0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(105),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: Text(
                    discount!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
