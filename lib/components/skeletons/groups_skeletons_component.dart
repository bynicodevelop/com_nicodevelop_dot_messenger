import "package:com_nicodevelop_dotmessenger/components/responsive_component.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:skeletons/skeletons.dart";

class GroupSkeletonsComponent extends StatelessWidget {
  final Widget child;
  final bool isLoading;

  const GroupSkeletonsComponent({
    super.key,
    required this.child,
    required this.isLoading,
  });

  Widget _loadingGroupItem(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 24.0,
        left: ResponsiveComponent.device == DeviceEnum.mobile ? 0 : 16.0,
        right: 16.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonAvatar(
            style: SkeletonAvatarStyle(
              width: 40,
              height: 40,
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SkeletonLine(
                          style: SkeletonLineStyle(
                            height: 16,
                            padding: EdgeInsets.only(
                              right: ResponsiveComponent.device ==
                                      DeviceEnum.mobile
                                  ? MediaQuery.of(context).size.width * 0.3
                                  : 24.0,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth:
                              ResponsiveComponent.device == DeviceEnum.mobile
                                  ? MediaQuery.of(context).size.width * 0.1
                                  : 50.0,
                        ),
                        child: SkeletonLine(
                          style: SkeletonLineStyle(
                            height: 16.0,
                            padding: const EdgeInsets.only(
                              left: 16.0,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                  ),
                  child: SkeletonLine(
                    style: SkeletonLineStyle(
                      height: 16,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _loadingPlaceholder(BuildContext context) {
    return ListView(
      padding: ResponsiveComponent.device == DeviceEnum.mobile
          ? const EdgeInsets.only(
              top: kIsWeb ? 90 : 5,
              left: 20.0,
              right: 20.0,
            )
          : null,
      children: [
        for (var i = 0; i < 5; i++) _loadingGroupItem(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(
        milliseconds: 300,
      ),
      child: isLoading ? _loadingPlaceholder(context) : child,
    );
  }
}
