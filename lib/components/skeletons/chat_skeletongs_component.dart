import "package:com_nicodevelop_dotmessenger/components/responsive_component.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:skeletons/skeletons.dart";

class ChatSkeletonComponent extends StatelessWidget {
  const ChatSkeletonComponent({
    super.key,
  });

  Widget _bubbleSkeleton(
    BuildContext context,
    bool isMe,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 24.0,
      ),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              SkeletonLine(
                style: SkeletonLineStyle(
                  height: 16,
                  width: ResponsiveComponent.device == DeviceEnum.mobile
                      ? MediaQuery.of(context).size.width * 0.5
                      : MediaQuery.of(context).size.width * 0.3,
                  padding: EdgeInsets.only(
                    left: isMe ? 0 : 16.0,
                    right: isMe ? 16.0 : 0,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SkeletonLine(
                style: SkeletonLineStyle(
                  height: 16,
                  width: MediaQuery.of(context).size.width * 0.2,
                  padding: EdgeInsets.only(
                    left: isMe ? 0 : 16.0,
                    right: isMe ? 16.0 : 0,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(
        top: kIsWeb ? 100 : 5,
      ),
      shrinkWrap: true,
      children: [
        for (var i = 0; i < 5; i++)
          _bubbleSkeleton(
            context,
            // random bool
            i % 2 == 0,
          ),
      ],
    );
  }
}
