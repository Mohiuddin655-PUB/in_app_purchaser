import 'package:flutter/material.dart';
import 'package:flutter_text_parser/text.dart';
import 'package:in_app_purchaser/in_app_purchaser.dart';

class ProductCard extends StatefulWidget {
  final PaywallProduct product;

  const ProductCard(this.product, {super.key});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    final badge = widget.product.badgeTextLocalized ?? '';
    return PaywallLayout(
      style: widget.product.style,
      children: [_buildContent(), if (badge.isNotEmpty) _buildBadge(badge)],
    );
  }

  Widget _buildBadge(String data) {
    return _buildText(data, widget.product.badgeStyle);
  }

  Widget _buildContent() {
    return PaywallLayout(
      style: widget.product.selectedButtonStyle,
      children: [_buildLeft(), Spacer(), _buildRight()],
    );
  }

  Widget _buildLeft() {
    final top = widget.product.leftTopTextLocalized ?? '';
    final middle = widget.product.leftMiddleTextLocalized ?? '';
    final bottom = widget.product.leftBottomTextLocalized ?? '';
    return PaywallLayout(
      style: widget.product.selectedLeftStyle,
      children: [
        if (top.isNotEmpty)
          _buildText(top, widget.product.selectedLeftTopStyle),
        if (middle.isNotEmpty)
          _buildText(middle, widget.product.selectedLeftMiddleStyle),
        if (bottom.isNotEmpty)
          _buildText(bottom, widget.product.selectedLeftBottomStyle),
      ],
    );
  }

  Widget _buildRight() {
    final top = widget.product.rightTopTextLocalized ?? '';
    final middle = widget.product.rightMiddleTextLocalized ?? '';
    final bottom = widget.product.rightBottomTextLocalized ?? '';
    return PaywallLayout(
      style: widget.product.selectedRightStyle,
      children: [
        if (top.isNotEmpty)
          _buildText(top, widget.product.selectedRightTopStyle),
        if (middle.isNotEmpty)
          _buildText(middle, widget.product.selectedRightMiddleStyle),
        if (bottom.isNotEmpty)
          _buildText(bottom, widget.product.selectedRightBottomStyle),
      ],
    );
  }

  Widget _buildText(String value, PaywallStyle? style) {
    return PaywallDecoratedBox(
      style: style,
      child: SpannableText(
        value,
        style: style?.textStyle,
        textAlign: style?.textAlign,
        maxLines: style?.maxLines,
      ),
    );
  }
}
