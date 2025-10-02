import 'package:flutter/material.dart';
import 'package:flutter_text_parser/text.dart';
import 'package:in_app_purchaser/in_app_purchaser.dart';

class PurchaseButton extends StatefulWidget {
  final bool loading;
  final String? placement;
  final String text;
  final PaywallStyle? style;
  final InAppPurchaseProduct? product;
  final int? index;
  final Widget Function(BuildContext context)? loadingBuilder;
  final Widget Function(BuildContext context, String text)? textBuilder;
  final Widget Function(
    BuildContext context,
    Future<InAppPurchaseResult> Function()? callback,
    Widget child,
  ) builder;

  const PurchaseButton({
    super.key,
    required InAppPurchaseProduct this.product,
    required this.text,
    required this.builder,
    this.loadingBuilder,
    this.textBuilder,
    this.loading = false,
    this.style,
  })  : placement = null,
        index = null;

  const PurchaseButton.indexed({
    super.key,
    required int this.index,
    required this.text,
    required this.builder,
    this.loadingBuilder,
    this.textBuilder,
    this.placement,
    this.loading = false,
    this.style,
  }) : product = null;

  @override
  State<PurchaseButton> createState() => _PurchaseButtonState();
}

class _PurchaseButtonState extends State<PurchaseButton> {
  late InAppPurchaseState state =
      widget.loading ? InAppPurchaseState.running : InAppPurchaseState.none;

  Future<InAppPurchaseResult> _callback() async {
    if (widget.product != null) return InAppPurchaser.purchase(widget.product!);
    if (widget.index != null) {
      return InAppPurchaser.purchaseAt(
        widget.index!,
        placement: widget.placement,
      );
    }
    return InAppPurchaseResultInvalid();
  }

  void _listen() {
    final state = InAppPurchaser.purchasingState.value;
    setState(() => this.state = state);
  }

  void _listenRestore() {
    final state = InAppPurchaser.restoringState.value;
    setState(() => this.state = state);
  }

  @override
  void initState() {
    super.initState();
    InAppPurchaser.purchasingState.addListener(_listen);
    InAppPurchaser.restoringState.addListener(_listenRestore);
  }

  @override
  void didUpdateWidget(covariant PurchaseButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.loading != oldWidget.loading) {
      state = widget.loading ? InAppPurchaseState.running : state;
    }
  }

  @override
  void dispose() {
    InAppPurchaser.purchasingState.removeListener(_listen);
    InAppPurchaser.restoringState.removeListener(_listenRestore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ??
        PaywallStyle(
          backgroundColorState: PaywallState.all(
            Theme.of(context).primaryColor,
          ),
          borderRadiusState: PaywallState.all(
            BorderRadius.circular(50),
          ),
          heightState: PaywallState.all(65),
          textStyleState: PaywallState.all(
            TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
    return widget.builder(
      context,
      state.isRunning ? null : _callback,
      PaywallDecoratedBox(
        style: style,
        child: _buildButton(context, style.textStyle),
      ),
    );
  }

  Widget _buildButton(BuildContext context, TextStyle? style) {
    return state.isRunning
        ? _buildLoader(context, style?.color)
        : _buildText(context, style);
  }

  Widget _buildLoader(BuildContext context, Color? color) {
    if (widget.loadingBuilder == null) {
      return Center(
        child: SizedBox.square(
          dimension: 32,
          child: CircularProgressIndicator(
            color: color,
            strokeWidth: 3,
          ),
        ),
      );
    }
    return widget.loadingBuilder!(context);
  }

  Widget _buildText(BuildContext context, TextStyle? style) {
    if (widget.textBuilder == null) {
      return Center(
        child: SpannableText(
          widget.text,
          style: style,
          textAlign: TextAlign.center,
          maxLines: 1,
        ),
      );
    }
    return widget.textBuilder!(context, widget.text);
  }
}
