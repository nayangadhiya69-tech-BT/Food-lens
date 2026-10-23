import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Platform-native pull-to-refresh, used across the app (dashboard,
/// history, …):
///
/// * **Android** (and other Material platforms): the classic clamping
///   [RefreshIndicator] — the list pushes down and the Material spinner
///   appears. Exactly the widget the app already used.
/// * **iOS/macOS**: the native bouncing indicator — the list
///   rubber-bands down and the standard Cupertino spinner shows
///   ([CupertinoSliverRefreshControl]), like the system-wide refresh.
///
/// The scroll physics inherit the platform default under
/// `AlwaysScrollableScrollPhysics`, so iOS keeps its bounce and Android
/// keeps its clamp while pull-to-refresh also works on short content.
///
/// Usage — pass either [children] (eager list) or [itemCount] +
/// [itemBuilder] (lazy list):
/// ```dart
/// CommonRefreshIndicator(
///   onRefresh: viewModel.load,
///   padding: EdgeInsets.only(bottom: 20),
///   children: [ ... ],
/// )
/// ```
class CommonRefreshIndicator extends StatelessWidget {
  static const ScrollPhysics _physics = AlwaysScrollableScrollPhysics();

  /// Called when the user pulls far enough; the indicator stays visible
  /// until the returned future completes.
  final Future<void> Function() onRefresh;

  /// Eager content mode (home dashboard).
  final List<Widget>? children;

  /// Lazy content mode (history list).
  final int? itemCount;
  final NullableIndexedWidgetBuilder? itemBuilder;

  /// List padding (same semantics as `ListView.padding`).
  final EdgeInsetsGeometry? padding;

  /// Spinner/track color on the Material (clamping) side; iOS shows its
  /// native indicator and ignores this.
  final Color color;

  const CommonRefreshIndicator({
    super.key,
    required this.onRefresh,
    this.children,
    this.itemCount,
    this.itemBuilder,
    this.padding,
    this.color = AppColors.brand,
  }) : assert(
         children != null || (itemCount != null && itemBuilder != null),
         'Provide children, or both itemCount and itemBuilder.',
       );

  @override
  Widget build(BuildContext context) {
    if (_useCupertino(context)) {
      // Native iOS/macOS bounce: rubber-band overscroll + system spinner.
      return CustomScrollView(
        physics: _physics,
        slivers: [
          CupertinoSliverRefreshControl(onRefresh: onRefresh),
          _buildContentSliver(),
        ],
      );
    }

    // Classic Android clamping indicator — same structure the app used
    // before (RefreshIndicator over a ListView).
    final kids = children;
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: color,
      child: kids != null
          ? ListView(physics: _physics, padding: padding, children: kids)
          : ListView.builder(
              physics: _physics,
              padding: padding,
              itemCount: itemCount,
              itemBuilder: itemBuilder!,
            ),
    );
  }

  Widget _buildContentSliver() {
    final kids = children;
    final Widget sliver;
    if (kids != null) {
      sliver = SliverList(delegate: SliverChildListDelegate(kids));
    } else {
      // Guaranteed by the constructor assert (children == null).
      sliver = SliverList.builder(
        itemCount: itemCount,
        itemBuilder: itemBuilder!,
      );
    }
    final listPadding = padding;
    if (listPadding == null) return sliver;
    return SliverPadding(padding: listPadding, sliver: sliver);
  }

  bool _useCupertino(BuildContext context) {
    final platform = Theme.of(context).platform;
    return platform == TargetPlatform.iOS || platform == TargetPlatform.macOS;
  }
}
