import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_app/product/data/memory/product_memory_data_source.dart';
import 'package:sample_app/product/data/repository/product_repository.dart';
import 'package:sample_app/product/ui/product_bloc.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../data/model/product.dart';

class ProductScreen extends StatefulWidget {
  static String routeName = 'product';

  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> with SingleTickerProviderStateMixin {
  double opacity = 0;
  double expandedHeight = 400;
  bool shouldShowForm = false;
  OrderButtonState buttonState = OrderButtonState.collapsed;
  final bloc = ProductBloc(id: '123', productRepository: ProductRepository(ProductMemoryDataSource())); // TODO: Improve Dependency Injection

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProductBloc, ProductState>(
          bloc: bloc,
          builder: (context, state) {
            return Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 400, end: expandedHeight),
                      duration: const Duration(milliseconds: 300),
                      builder: (BuildContext context, double height, Widget? child) {
                        return _ProductAppBar(height: height);
                      },
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 32, left: 32, right: 32),
                        child: state.maybeWhen(
                          loaded: (product) => _ProductDescription(product: product),
                          orElse: () => const Center(child: CircularProgressIndicator()),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      sliver: SliverAnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: shouldShowForm && state is ProductLoadedState
                              ? OrderFormSliver(product: state.product)
                              : const SliverToBoxAdapter(
                                  child: SizedBox.shrink(),
                                )),
                    ),
                  ],
                ),
                Positioned.directional(
                  textDirection: Directionality.of(context),
                  bottom: 0,
                  end: 0,
                  child: state is LoadingProductState
                      ? const SizedBox.shrink()
                      : OrderButton(
                          text: buttonState == OrderButtonState.collapsed ? 'CUSTOMIZE YOUR DRINK' : 'ADD TO ORDER',
                          onPressed: () {
                            setState(() {
                              buttonState = buttonState == OrderButtonState.expanded ? OrderButtonState.collapsed : OrderButtonState.expanded;
                              shouldShowForm = buttonState == OrderButtonState.expanded;
                              expandedHeight = buttonState == OrderButtonState.expanded ? 200 : 400;
                            });
                          },
                          buttonState: buttonState,
                        ),
                ),
              ],
            );
          }),
    );
  }
}

class _ProductDescription extends StatelessWidget {
  const _ProductDescription({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product; // TODO: Change the Model for a UI model

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          product.name,
          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFF223730)),
        ),
        const SizedBox(height: 16),
        Text(
          product.description,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }
}

class _ProductAppBar extends StatelessWidget {
  const _ProductAppBar({Key? key, required this.height}) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      title: const Text('STARBUCKS'),
      backgroundColor: const Color(0xFF1E3932),
      flexibleSpace: Image.asset(
          'assets/starbucks_coffee.png',
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            return Padding(
              padding: const EdgeInsets.only(top: 86),
              child: child,
            );
          },
        ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      pinned: true,
      elevation: 0,
      scrolledUnderElevation: 8,
      collapsedHeight: 150,
      expandedHeight: height,
    );
  }
}

class OrderFormSliver extends StatelessWidget {
  const OrderFormSliver({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      children: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            childCount: product.customizations.length,
            (context, index) {
              final customization = product.customizations[index];

              final widget = customization.when(
                (id, name, description) => const SizedBox.shrink(),
                items: (id, name, description, items) {
                  return DropDownButtonFormItem(
                    title: name,
                    value: items.first,
                    items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
                    onChanged: (_) {},
                  );
                },
                cupSizes: (id, description, sizes) {
                  return DropDownButtonFormItem(
                    title: 'Size',
                    value: sizes.first,
                    items: sizes.map((size) => DropdownMenuItem(value: size, child: Text(size))).toList(),
                    onChanged: (_) {},
                  );
                },
              );

              return Padding(
                padding: const EdgeInsets.only(top: 16),
                child: widget,
              );
            },
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: 16, bottom: 64),
            child: CounterFormItem(),
          ),
        )
      ],
    );
  }
}

class DropDownButtonFormItem extends StatelessWidget {
  const DropDownButtonFormItem({
    Key? key,
    required this.title,
    required this.items,
    required this.onChanged,
    this.value,
  }) : super(key: key);

  final String title;
  final List<DropdownMenuItem<String>>? items;
  final String? value;
  final ValueChanged<String?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF223730))),
        const Spacer(),
        CardFormItem(
          child: SizedBox(
            height: 36,
            child: DropdownButton(
              style: DefaultTextStyle.of(context).style.copyWith(color: const Color(0xFF223730), fontSize: 16),
              items: items,
              onChanged: onChanged,
              value: value,
              underline: const SizedBox.shrink(),
              icon: const Icon(Icons.keyboard_arrow_down),
            ),
          ),
        ),
      ],
    );
  }
}

class CardFormItem extends StatelessWidget {
  const CardFormItem({Key? key, required this.child}) : super(key: key);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
        child: child,
      ),
    );
  }
}

class CounterFormItem extends StatefulWidget {
  const CounterFormItem({Key? key}) : super(key: key);

  @override
  State<CounterFormItem> createState() => _CounterFormItemState();
}

class _CounterFormItemState extends State<CounterFormItem> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(-12, 0),
      child: Row(
        children: <Widget>[
          _SquareElevatedButton(onPressed: () => setState(() => _count--), child: const Text('-',)),
          Text('$_count', style: const TextStyle(fontSize: 24),),
          _SquareElevatedButton(onPressed: () => setState(() => _count++), child: const Text('+')),
        ],
      ),
    );
  }
}

class _SquareElevatedButton extends StatelessWidget {
  const _SquareElevatedButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.size = 24,
  }) : super(key: key);

  final Widget child;
  final VoidCallback? onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        minimumSize: Size.zero,
        maximumSize: Size(size, size),
        fixedSize: Size(size, size),
        elevation: 8,
        padding: EdgeInsets.zero,
        onPrimary: Colors.black87,
      ),
      child: child,
    );
  }
}

enum OrderButtonState {
  expanded,
  collapsed,
}

typedef OrderButtonStateCallback = void Function(OrderButtonState state);

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.text,
    required this.buttonState,
    this.onPressed,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final OrderButtonState buttonState;
  final String text;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> with TickerProviderStateMixin {
  // TODO: Improve color and Theme configurations
  static const _textColor = Color(0xFF296146);
  static const _backgroundColor = Color(0xFFE3F5EE);
  static const _tapBackgroundColor = Color(0xFFD8E9E3);

  late final _sizeController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
  late final _tapController = AnimationController(duration: const Duration(milliseconds: 50), vsync: this);
  late final _tapAnimation = ColorTween(begin: _tapBackgroundColor, end: _backgroundColor).animate(_tapController);

  @visibleForTesting
  bool get isEnabled => widget.onPressed != null;

  void _animateShape() {
    if (widget.buttonState == OrderButtonState.expanded) {
      _sizeController.forward();
    } else {
      _sizeController.reverse();
    }
  }

  @override
  void didUpdateWidget(OrderButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.buttonState != widget.buttonState) {
      _animateShape();
    }
  }

  @override
  void dispose() {
    _sizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTapDown: (details) => _tapController.forward(),
      onTap: widget.onPressed,
      onTapUp: (details) => _tapController.reverse(),
      child: AnimatedBuilder(
        animation: _tapAnimation,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Container(),
              AnimatedBuilder(
                animation: _sizeController,
                builder: (context, child) {
                  return CustomPaint(
                    size: SizeTween(
                      begin: const Size(200, 56),
                      end: Size(width, 56),
                    ).evaluate(_sizeController) ?? Size.zero,
                    painter: _OrderButtonPainter(
                        plateauHeight: 0,
                        radius: 24,
                        color: _tapAnimation.value ?? Colors.transparent),
                  );
                },
              ),
              Text(
                widget.text,
                style: TextStyle(
                    color: _textColor.withOpacity(
                      Tween<double>(begin: 1, end: 0.7).evaluate(_tapController),
                    ),
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _OrderButtonPainter extends CustomPainter {
  _OrderButtonPainter({
    required this.plateauHeight,
    required this.radius,
    required this.color,
  });

  final double plateauHeight;
  final double radius;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color;

    final rrect = RRect.fromRectAndCorners(Offset.zero & size, topLeft: Radius.circular(radius));

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(_OrderButtonPainter oldDelegate) =>
      oldDelegate.plateauHeight != plateauHeight ||
          oldDelegate.radius != radius ||
          oldDelegate.color != color;
}
