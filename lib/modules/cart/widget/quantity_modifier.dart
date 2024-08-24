import 'package:flutter/material.dart';

const quantityModifierKey = 'quantityModifierKey';
const minusButtonKey = 'minusButtonKey';
const plusButtonKey = 'plusButtonKey';
const quantityTextContainerKey = 'quantityTextContainerKey';
const quantityIconKey = 'quantityIconKey';
const quantityIconContainerKey = 'quantityIconContainerKey';

class QuantityModifierWidget extends StatefulWidget {
  final int quantity;
  final ValueChanged<double> onQuantityUpdate;
  final ValueChanged<String> addOrRemove;
  final double? height;
  final double? iconSize;
  final double? iconBoxWidth;
  final double? centerWidth;
  final Color? borderColor;
  final TextStyle? textStyle;
  final int? maxQuantity;
  final bool isOutOfStock;

  const QuantityModifierWidget({
    super.key,
    required this.quantity,
    required this.onQuantityUpdate,
    required this.addOrRemove,
    this.height,
    this.iconSize,
    this.centerWidth,
    this.iconBoxWidth,
    this.borderColor,
    this.textStyle,
    this.maxQuantity,
    this.isOutOfStock = false,
  })  : assert(quantity > 0, 'quantity should be greater than 0');

  @override
  State<QuantityModifierWidget> createState() => _QuantityModifierWidgetState();
}

class _QuantityModifierWidgetState extends State<QuantityModifierWidget> with SingleTickerProviderStateMixin {
  late int _quantity;
  late int _maxQuantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.quantity;
    _maxQuantity = widget.maxQuantity ?? 0;
  }

  @override
  void didUpdateWidget(covariant QuantityModifierWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _quantity = widget.quantity;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? 35,
      child: Row(
        children: [
          Semantics(
            label: minusButtonKey,
            child: _IconButton(
              key: const Key(minusButtonKey),
              iconData: Icons.remove,
              width: widget.iconBoxWidth,
              iconSize: widget.iconSize,
              borderColor: widget.borderColor ?? Theme.of(context).primaryIconTheme.color!.withOpacity(.5),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                bottomLeft: Radius.circular(4),
              ),
              isDisabled: _quantity == 1,
              onPressed: () {
                if (_quantity > 1) {
                  setState(() {
                    _quantity--;
                    // _animationController.forward(from: _from);
                    widget.addOrRemove("sub");
                    widget.onQuantityUpdate(_quantity.toDouble());
                  });
                }
              },
            ),
          ),
          Container(
            key: const Key(quantityTextContainerKey),
            width: widget.centerWidth ?? 50,
            decoration: BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(
                  color: widget.borderColor ?? Theme.of(context).primaryIconTheme.color!.withOpacity(.5),
                ),
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 1.0),
                child: Text(
                  _quantity.toInt().toString(),
                  style: widget.textStyle ??
                      const TextStyle(
                        fontSize: 16,
                      ),
                ),
              ),
            ),
          ),
          Semantics(
            label: plusButtonKey,
            child: _IconButton(
              key: const Key(plusButtonKey),
              iconSize: widget.iconSize,
              width: widget.iconBoxWidth,
              borderColor: widget.borderColor ?? Theme.of(context).primaryIconTheme.color!.withOpacity(.5),
              iconData: Icons.add,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(4),
                bottomRight: Radius.circular(4),
              ),
              isDisabled: (_quantity >= _maxQuantity || widget.isOutOfStock),
              onPressed: () {
                setState(() {
                  _quantity++;
                  widget.addOrRemove("add");
                  widget.onQuantityUpdate(_quantity.toDouble());
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _IconButton extends StatefulWidget {
  final BorderRadiusGeometry borderRadius;
  final VoidCallback onPressed;
  final IconData iconData;
  final double? iconSize;
  final double? width;
  final Color borderColor;
  final bool isDisabled;

  const _IconButton({
    super.key,
    required this.iconData,
    required this.borderRadius,
    required this.onPressed,
    required this.borderColor,
    this.isDisabled = false,
    this.iconSize,
    this.width,
  });

  @override
  State<_IconButton> createState() => _IconButtonState();
}

class _IconButtonState extends State<_IconButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key(quantityIconContainerKey),
      width: widget.width ?? 40,
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.borderColor,
        ),
        borderRadius: widget.borderRadius,
      ),
      child: Center(
        child: GestureDetector(
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: widget.isDisabled ? null : widget.onPressed,
            splashRadius: 0.1,
            icon: Icon(
              widget.iconData,
              key: const Key(quantityIconKey),
              color: widget.isDisabled ? Theme.of(context).dividerColor : Theme.of(context).disabledColor,
              size: widget.iconSize,
            ),
          ),
        ),
      ),
    );
  }
}
