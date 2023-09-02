import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pilipala/models/video/play/quality.dart';
import 'package:pilipala/models/video/play/url.dart';
import 'package:pilipala/pages/video/detail/index.dart';
import 'package:pilipala/plugin/pl_player/index.dart';

class HeaderControl extends StatefulWidget implements PreferredSizeWidget {
  final PlPlayerController? controller;
  final VideoDetailController? videoDetailCtr;
  const HeaderControl({
    this.controller,
    this.videoDetailCtr,
    Key? key,
  }) : super(key: key);

  @override
  State<HeaderControl> createState() => _HeaderControlState();

  @override
  Size get preferredSize => throw UnimplementedError();
}

class _HeaderControlState extends State<HeaderControl> {
  late PlayUrlModel videoInfo;
  List<PlaySpeed> playSpeed = PlaySpeed.values;
  TextStyle subTitleStyle = const TextStyle(fontSize: 12);
  TextStyle titleStyle = const TextStyle(fontSize: 14);
  Size get preferredSize => const Size(double.infinity, kToolbarHeight);

  @override
  void initState() {
    super.initState();
    videoInfo = widget.videoDetailCtr!.data;
  }

  /// 设置面板
  void showSettingSheet() {
    showModalBottomSheet(
      elevation: 0,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          width: double.infinity,
          height: 400,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          margin: const EdgeInsets.all(12),
          child: Column(
            children: [
              SizedBox(
                height: 35,
                child: Center(
                  child: Container(
                    width: 32,
                    height: 3,
                    decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .onSecondaryContainer
                            .withOpacity(0.5),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(3))),
                  ),
                ),
              ),
              Expanded(
                  child: Material(
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    ListTile(
                      onTap: () {},
                      dense: true,
                      enabled: false,
                      leading:
                          const Icon(Icons.network_cell_outlined, size: 20),
                      title: Text('省流模式', style: titleStyle),
                      subtitle: Text('低画质 ｜ 减少视频缓存', style: subTitleStyle),
                      trailing: Transform.scale(
                        scale: 0.75,
                        child: Switch(
                          thumbIcon: MaterialStateProperty.resolveWith<Icon?>(
                              (Set<MaterialState> states) {
                            if (states.isNotEmpty &&
                                states.first == MaterialState.selected) {
                              return const Icon(Icons.done);
                            }
                            return null; // All other states will use the default thumbIcon.
                          }),
                          value: false,
                          onChanged: (value) => {},
                        ),
                      ),
                    ),
                    // Obx(
                    //   () => ListTile(
                    //     onTap: () => {Get.back(), showSetSpeedSheet()},
                    //     dense: true,
                    //     leading: const Icon(Icons.speed_outlined, size: 20),
                    //     title: Text('播放速度', style: titleStyle),
                    //     subtitle: Text(
                    //         '当前倍速 x${widget.controller!.playbackSpeed}',
                    //         style: subTitleStyle),
                    //   ),
                    // ),
                    ListTile(
                      onTap: () => {Get.back(), showSetVideoQa()},
                      dense: true,
                      leading: const Icon(Icons.play_circle_outline, size: 20),
                      title: Text('选择画质', style: titleStyle),
                      subtitle: Text(
                          '当前画质 ${widget.videoDetailCtr!.currentVideoQa.description}',
                          style: subTitleStyle),
                    ),
                    if (widget.videoDetailCtr!.currentAudioQa != null)
                      ListTile(
                        onTap: () => {Get.back(), showSetAudioQa()},
                        dense: true,
                        leading: const Icon(Icons.album_outlined, size: 20),
                        title: Text('选择音质', style: titleStyle),
                        subtitle: Text(
                            '当前音质 ${widget.videoDetailCtr!.currentAudioQa!.description}',
                            style: subTitleStyle),
                      ),
                    ListTile(
                      onTap: () => {Get.back(), showSetDecodeFormats()},
                      dense: true,
                      leading: const Icon(Icons.av_timer_outlined, size: 20),
                      title: Text('解码格式', style: titleStyle),
                      subtitle: Text(
                          '当前解码格式 ${widget.videoDetailCtr!.currentDecodeFormats.description}',
                          style: subTitleStyle),
                    ),
                    // ListTile(
                    //   onTap: () {},
                    //   dense: true,
                    //   enabled: false,
                    //   leading: const Icon(Icons.play_circle_outline, size: 20),
                    //   title: Text('播放设置', style: titleStyle),
                    // ),
                    ListTile(
                      onTap: () {},
                      dense: true,
                      enabled: false,
                      leading: const Icon(Icons.subtitles_outlined, size: 20),
                      title: Text('弹幕设置', style: titleStyle),
                    ),
                  ],
                ),
              ))
            ],
          ),
        );
      },
      clipBehavior: Clip.hardEdge,
      isScrollControlled: true,
    );
  }

  /// 选择倍速
  void showSetSpeedSheet() {
    double currentSpeed = widget.controller!.playbackSpeed;
    SmartDialog.show(
      animationType: SmartAnimationType.centerFade_otherSlide,
      builder: (context) {
        return AlertDialog(
          title: const Text('播放速度'),
          contentPadding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          content: StatefulBuilder(builder: (context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('$currentSpeed倍'),
                Slider(
                  min: PlaySpeed.values.first.value,
                  max: PlaySpeed.values.last.value,
                  value: currentSpeed,
                  divisions: PlaySpeed.values.length - 1,
                  label: '${currentSpeed}x',
                  onChanged: (double val) =>
                      {setState(() => currentSpeed = val)},
                )
              ],
            );
          }),
          actions: [
            TextButton(
              onPressed: () => SmartDialog.dismiss(),
              child: Text(
                '取消',
                style: TextStyle(color: Theme.of(context).colorScheme.outline),
              ),
            ),
            TextButton(
              onPressed: () async {
                await SmartDialog.dismiss();
                widget.controller!.setPlaybackSpeed(currentSpeed);
              },
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }

  /// 选择画质
  void showSetVideoQa() {
    List<FormatItem> videoFormat = videoInfo.supportFormats!;
    VideoQuality currentVideoQa = widget.videoDetailCtr!.currentVideoQa;

    /// 总质量分类
    int totalQaSam = videoFormat.length;

    /// 可用的质量分类
    int userfulQaSam = 0;
    List<VideoItem> video = videoInfo.dash!.video!;
    Set<int> idSet = {};
    for (var item in video) {
      int id = item.id!;
      if (!idSet.contains(id)) {
        idSet.add(id);
        userfulQaSam++;
      }
    }

    showModalBottomSheet(
      context: context,
      elevation: 0,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          height: 310,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          margin: const EdgeInsets.all(12),
          child: Column(
            children: [
              SizedBox(
                height: 45,
                child: GestureDetector(
                  onTap: () {
                    SmartDialog.showToast('标灰画质可能需要bilibili会员');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('选择画质', style: titleStyle),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Theme.of(context).colorScheme.outline,
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Material(
                  child: Scrollbar(
                    child: ListView(
                      children: [
                        for (var i = 0; i < totalQaSam; i++) ...[
                          ListTile(
                            onTap: () {
                              if (currentVideoQa.code ==
                                  videoFormat[i].quality) {
                                return;
                              }
                              final int quality = videoFormat[i].quality!;
                              widget.videoDetailCtr!.currentVideoQa =
                                  VideoQualityCode.fromCode(quality)!;
                              widget.videoDetailCtr!.updatePlayer();
                              Get.back();
                            },
                            dense: true,
                            // 可能包含会员解锁画质
                            enabled: i >= totalQaSam - userfulQaSam,
                            contentPadding:
                                const EdgeInsets.only(left: 20, right: 20),
                            title: Text(videoFormat[i].newDesc!),
                            subtitle: Text(
                              videoFormat[i].format!,
                              style: subTitleStyle,
                            ),
                            trailing: currentVideoQa.code ==
                                    videoFormat[i].quality
                                ? Icon(
                                    Icons.done,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  )
                                : const SizedBox(),
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 选择音质
  void showSetAudioQa() {
    AudioQuality currentAudioQa = widget.videoDetailCtr!.currentAudioQa!;

    List<AudioItem> audio = videoInfo.dash!.audio!;
    showModalBottomSheet(
      context: context,
      elevation: 0,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          height: 250,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          margin: const EdgeInsets.all(12),
          child: Column(
            children: [
              SizedBox(
                  height: 45,
                  child: Center(child: Text('选择音质', style: titleStyle))),
              Expanded(
                child: Material(
                  child: ListView(
                    children: [
                      for (var i in audio) ...[
                        ListTile(
                          onTap: () {
                            if (currentAudioQa.code == i.id) return;
                            final int quality = i.id!;
                            widget.videoDetailCtr!.currentAudioQa =
                                AudioQualityCode.fromCode(quality)!;
                            widget.videoDetailCtr!.updatePlayer();
                            Get.back();
                          },
                          dense: true,
                          contentPadding:
                              const EdgeInsets.only(left: 20, right: 20),
                          title: Text(i.quality!),
                          subtitle: Text(
                            i.codecs!,
                            style: subTitleStyle,
                          ),
                          trailing: currentAudioQa.code == i.id
                              ? Icon(
                                  Icons.done,
                                  color: Theme.of(context).colorScheme.primary,
                                )
                              : const SizedBox(),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 选择解码格式
  void showSetDecodeFormats() {
    // 当前选中的解码格式
    VideoDecodeFormats currentDecodeFormats =
        widget.videoDetailCtr!.currentDecodeFormats;
    VideoItem firstVideo = widget.videoDetailCtr!.firstVideo;
    // 当前视频可用的解码格式
    List<FormatItem> videoFormat = videoInfo.supportFormats!;
    List list = videoFormat
        .firstWhere((e) => e.quality == firstVideo.quality!.code)
        .codecs!;

    showModalBottomSheet(
      context: context,
      elevation: 0,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          height: 250,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          margin: const EdgeInsets.all(12),
          child: Column(
            children: [
              SizedBox(
                  height: 45,
                  child: Center(child: Text('选择解码格式', style: titleStyle))),
              Expanded(
                child: Material(
                  child: ListView(
                    children: [
                      for (var i in list) ...[
                        ListTile(
                          onTap: () {
                            if (i.startsWith(currentDecodeFormats.code)) return;
                            widget.videoDetailCtr!.currentDecodeFormats =
                                VideoDecodeFormatsCode.fromString(i)!;
                            widget.videoDetailCtr!.updatePlayer();
                            Get.back();
                          },
                          dense: true,
                          contentPadding:
                              const EdgeInsets.only(left: 20, right: 20),
                          title: Text(VideoDecodeFormatsCode.fromString(i)!
                              .description!),
                          subtitle: Text(
                            i!,
                            style: subTitleStyle,
                          ),
                          trailing: i.startsWith(currentDecodeFormats.code)
                              ? Icon(
                                  Icons.done,
                                  color: Theme.of(context).colorScheme.primary,
                                )
                              : const SizedBox(),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _ = widget.controller!;
    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 12,
    );
    return AppBar(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      primary: false,
      centerTitle: false,
      automaticallyImplyLeading: false,
      titleSpacing: 14,
      title: Row(
        children: [
          ComBtn(
            icon: const Icon(
              FontAwesomeIcons.arrowLeft,
              size: 15,
              color: Colors.white,
            ),
            fuc: () => Get.back(),
          ),
          const SizedBox(width: 4),
          ComBtn(
            icon: const Icon(
              FontAwesomeIcons.house,
              size: 15,
              color: Colors.white,
            ),
            fuc: () async {
              // 销毁播放器实例
              await widget.controller!.dispose(type: 'all');
              if (mounted) {
                Navigator.popUntil(context, (route) => route.isFirst);
              }
            },
          ),
          const Spacer(),
          // ComBtn(
          //   icon: const Icon(
          //     FontAwesomeIcons.cropSimple,
          //     size: 15,
          //     color: Colors.white,
          //   ),
          //   fuc: () => _.screenshot(),
          // ),
          SizedBox(
            width: 34,
            height: 34,
            child: Obx(
              () => IconButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                ),
                onPressed: () {
                  _.isOpenDanmu.value = !_.isOpenDanmu.value;
                },
                icon: Icon(
                  _.isOpenDanmu.value
                      ? Icons.subtitles_outlined
                      : Icons.subtitles_off_outlined,
                  size: 19,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Obx(
            () => SizedBox(
              width: 45,
              height: 34,
              child: TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                ),
                onPressed: () => showSetSpeedSheet(),
                child: Text(
                  '${_.playbackSpeed.toString()}X',
                  style: textStyle,
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          ComBtn(
            icon: const Icon(
              FontAwesomeIcons.sliders,
              size: 15,
              color: Colors.white,
            ),
            fuc: () => showSettingSheet(),
          ),
        ],
      ),
    );
  }
}
