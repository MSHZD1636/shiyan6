import router from '@ohos.router';

@Entry
@Component
struct VideoPage {
  private controller1: VideoController = new VideoController();
  private controller2: VideoController = new VideoController();
  @State currentIndex: number = 0;
  @State isPlaying: boolean = false;

  build() {
    Column({ space: 12 }) {
      // 标题栏
      Row() {
        Button('← 返回')
          .fontSize($r('app.float.btn_font_size'))
          .backgroundColor($r('app.color.button_bg'))
          .fontColor($r('app.color.button_text'))
          .borderRadius(8)
          .onClick(() => {
            this.controller1.stop();
            this.controller2.stop();
            router.back();
          })
        Text($r('app.string.video_page_title'))
          .fontSize($r('app.float.title_font_size'))
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.title_color'))
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 16, bottom: 8 })

      // 当前视频标签
      Text(this.currentIndex === 0 ?
        $r('app.string.video1_btn') : $r('app.string.video2_btn'))
        .fontSize($r('app.float.subtitle_font_size'))
        .fontColor($r('app.color.subtitle_color'))

      // 视频1 —— 始终挂载，用 Visibility 控制显示
      Video({
        src: $rawfile('demo01.mp4'),
        controller: this.controller1
      })
        .width('100%')
        .height(260)
        .controls(true)
        .autoPlay(false)
        .objectFit(ImageFit.Contain)
        .backgroundColor(Color.Black)
        .visibility(this.currentIndex === 0 ? Visibility.Visible : Visibility.None)
        .onStart(() => {
          this.isPlaying = true;
        })
        .onPause(() => {
          this.isPlaying = false;
        })
        .onFinish(() => {
          this.isPlaying = false;
        })
        .onError(() => {
          console.error('VideoPage: 视频1播放错误');
        })

      // 视频2 —— 始终挂载，用 Visibility 控制显示
      Video({
        src: $rawfile('demo02.mp4'),
        controller: this.controller2
      })
        .width('100%')
        .height(260)
        .controls(true)
        .autoPlay(false)
        .objectFit(ImageFit.Contain)
        .backgroundColor(Color.Black)
        .visibility(this.currentIndex === 1 ? Visibility.Visible : Visibility.None)
        .onStart(() => {
          this.isPlaying = true;
        })
        .onPause(() => {
          this.isPlaying = false;
        })
        .onFinish(() => {
          this.isPlaying = false;
        })
        .onError(() => {
          console.error('VideoPage: 视频2播放错误');
        })

      // 视频切换按钮
      Row({ space: 16 }) {
        Button($r('app.string.video1_btn'))
          .fontSize($r('app.float.btn_font_size'))
          .backgroundColor(this.currentIndex === 0 ?
            $r('app.color.button_active') : $r('app.color.button_bg'))
          .fontColor(this.currentIndex === 0 ? Color.White : $r('app.color.button_text'))
          .borderRadius(8)
          .width(120)
          .onClick(() => {
            if (this.currentIndex !== 0) {
              this.controller2.pause();
              this.currentIndex = 0;
              this.isPlaying = false;
            }
          })
        Button($r('app.string.video2_btn'))
          .fontSize($r('app.float.btn_font_size'))
          .backgroundColor(this.currentIndex === 1 ?
            $r('app.color.button_active') : $r('app.color.button_bg'))
          .fontColor(this.currentIndex === 1 ? Color.White : $r('app.color.button_text'))
          .borderRadius(8)
          .width(120)
          .onClick(() => {
            if (this.currentIndex !== 1) {
              this.controller1.pause();
              this.currentIndex = 1;
              this.isPlaying = false;
            }
          })
      }
      .justifyContent(FlexAlign.Center)
      .width('100%')

      // 播放控制按钮
      Row({ space: 16 }) {
        Button($r('app.string.play_btn'))
          .fontSize($r('app.float.btn_font_size'))
          .backgroundColor($r('app.color.play_btn_color'))
          .fontColor(Color.White)
          .borderRadius(8)
          .width(90)
          .onClick(() => {
            if (this.currentIndex === 0) {
              this.controller1.start();
            } else {
              this.controller2.start();
            }
          })
        Button($r('app.string.pause_btn'))
          .fontSize($r('app.float.btn_font_size'))
          .backgroundColor($r('app.color.pause_btn_color'))
          .fontColor(Color.White)
          .borderRadius(8)
          .width(90)
          .onClick(() => {
            if (this.currentIndex === 0) {
              this.controller1.pause();
            } else {
              this.controller2.pause();
            }
          })
        Button($r('app.string.stop_btn'))
          .fontSize($r('app.float.btn_font_size'))
          .backgroundColor($r('app.color.stop_btn_color'))
          .fontColor(Color.White)
          .borderRadius(8)
          .width(90)
          .onClick(() => {
            if (this.currentIndex === 0) {
              this.controller1.stop();
            } else {
              this.controller2.stop();
            }
            this.isPlaying = false;
          })
      }
      .justifyContent(FlexAlign.Center)
      .width('100%')

      // 播放状态
      Text(this.isPlaying ? $r('app.string.status_playing') : $r('app.string.status_stopped'))
        .fontSize($r('app.float.subtitle_font_size'))
        .fontColor(this.isPlaying ? $r('app.color.play_btn_color') : $r('app.color.subtitle_color'))
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.page_bg'))
  }
}
