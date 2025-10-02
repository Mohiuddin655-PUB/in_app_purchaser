import 'package:example/purchase_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_text_parser/text.dart';
import 'package:in_app_purchaser/in_app_purchaser.dart';

import 'product_card.dart';

class DefaultPaywall extends StatefulWidget {
  final Paywall paywall;
  final VoidCallback? onSkipped;

  const DefaultPaywall({super.key, required this.paywall, this.onSkipped});

  @override
  State<DefaultPaywall> createState() => _DefaultPaywallState();
}

class _DefaultPaywallState extends State<DefaultPaywall> {
  List<PaywallProduct> get products => widget.paywall.products;

  final selectedIndex = ValueNotifier(0);

  final lightColor = Color(0xffFBF9F8);

  void _terms() {}

  void _privacy() {}

  void _userId() {}

  void _restore() => InAppPurchaser.restore();

  void _choosePackage(int index) {
    selectedIndex.value = index;
  }

  @override
  void dispose() {
    selectedIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PaywallLayout(
      style: widget.paywall.style,
      safeArea: widget.paywall.safeArea ?? false,
      children: [
        _buildHero(),
        _buildHeader(),
        _buildBody(),
        _buildFooter(),
        _buildCloseButton(),
      ],
    );
  }

  Widget _buildCloseButton() {
    final style = widget.paywall.closeButtonStyle;
    if (widget.paywall.skipMode != true || widget.onSkipped == null) {
      return SizedBox();
    }
    return PaywallDecoratedBox(
      style: style,
      child: GestureDetector(
        onTap: widget.onSkipped,
        child: Icon(
          Icons.clear,
          color: style?.color,
          size: style?.size,
        ),
      ),
    );
  }

  Widget _buildHero() {
    return PaywallDecoratedBox(
      style: widget.paywall.heroStyle,
      child: Image.asset(widget.paywall.heroLocalized ?? ''),
    );
  }

  Widget _buildHeader() {
    return PaywallLayout(
      style: widget.paywall.headerStyle,
      children: [
        if ((widget.paywall.imageLocalized ?? '').isNotEmpty)
          PaywallDecoratedBox(
            style: widget.paywall.imageStyle,
            child: Image.asset(
              widget.paywall.imageLocalized ?? '',
              fit: BoxFit.fitHeight,
            ),
          ),
        if ((widget.paywall.titleLocalized ?? '').isNotEmpty)
          PaywallDecoratedBox(
            style: widget.paywall.titleStyle,
            child: SpannableText(
              widget.paywall.titleLocalized ?? '',
              style: widget.paywall.titleStyle?.textStyle,
            ),
          ),
        if ((widget.paywall.subtitleLocalized ?? '').isNotEmpty)
          PaywallDecoratedBox(
            style: widget.paywall.subtitleStyle,
            child: SpannableText(
              widget.paywall.subtitleLocalized ?? '',
              style: widget.paywall.subtitleStyle?.textStyle,
            ),
          ),
      ],
    );
  }

  Widget _buildBody() {
    final style = widget.paywall.featureStyle;
    final features = widget.paywall.featuresLocalized ?? [];
    return PaywallLayout(
      style: widget.paywall.bodyStyle,
      children: List.generate(features.length, (
        index,
      ) {
        final raw = features[index];
        final data = raw is Map ? raw : {};
        final icon = data['icon'];
        final text = data['text'];
        return PaywallLayout(
          style: style,
          children: [
            if (icon != null)
              Image.asset(
                icon,
                width: style?.size,
                height: style?.size,
                color: style?.color,
              ),
            if (text is String && text.isNotEmpty)
              Expanded(child: Text(text, style: style?.textStyle)),
          ],
        );
      }),
    );
  }

  Widget _buildFooter() {
    return PaywallLayout(
      style: widget.paywall.footerStyle,
      children: [
        _buildProductCards(),
        _buildBottom(),
        _buildPurchaseButton(),
        _buildTextButtons(),
      ],
    );
  }

  Widget _buildProductCards() {
    return ValueListenableBuilder(
      valueListenable: selectedIndex,
      builder: (context, _, child) {
        return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: products.length,
          itemBuilder: (context, index) {
            return _buildProductCard(index);
          },
        );
      },
    );
  }

  Widget _buildProductCard(int index) {
    final package = products[index];
    final selected = selectedIndex.value == index;
    return GestureDetector(
      onTap: () => _choosePackage(index),
      child: ProductCard(
        package.copyWith(selected: selected),
      ),
    );
  }

  Widget _buildBottom() {
    return ValueListenableBuilder(
      valueListenable: selectedIndex,
      builder: (context, index, child) {
        final package = widget.paywall.products[index];
        final style = package.selectedBottomStyle;
        return PaywallDecoratedBox(
          style: style,
          child: SpannableText(
            package.bottomTextLocalized ?? '',
            textAlign: style?.textAlign,
            maxLines: style?.maxLines,
            style: style?.textStyle,
          ),
        );
      },
    );
  }

  Widget _buildPurchaseButton() {
    return ValueListenableBuilder(
      valueListenable: selectedIndex,
      builder: (context, index, child) {
        final product = products.elementAtOrNull(index);
        return PurchaseButton.indexed(
          index: index,
          loading: widget.paywall.defaultMode,
          text: product?.buttonTextLocalized ?? "Continue",
          style: product?.buttonStyle,
          builder: (context, callback, child) {
            return GestureDetector(onTap: callback, child: child);
          },
        );
      },
    );
  }

  Widget _buildTextButtons() {
    return PaywallLayout(
      style: widget.paywall.textButtonsStyle,
      children: {
        "Terms": _terms,
        "Privacy": _privacy,
        "Restore": _restore,
        "User Id": _userId,
      }.entries.map(_buildTextButton).toList(),
    );
  }

  Widget _buildTextButton(MapEntry<String, VoidCallback> data) {
    return PaywallDecoratedBox(
      style: widget.paywall.textButtonStyle,
      child: GestureDetector(
        onTap: data.value,
        child: Text(
          data.key,
          textAlign: TextAlign.center,
          style: widget.paywall.textButtonStyle?.textStyle,
        ),
      ),
    );
  }
}
