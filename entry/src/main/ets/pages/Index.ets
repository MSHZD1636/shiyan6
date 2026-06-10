import router from '@ohos.router';

@Entry
@Component
struct Index {
  build() {
    Column({ space: 24 }) {
      Text($r('app.string.home_title'))
        .fontSize($r('app.float.title_font_size'))
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.title_color'))
        .margin({ top: 60, bottom: 20 })

      Button($r('app.string.video_nav_btn'))
        .fontSize($r('app.float.btn_font_size'))
        .backgroundColor($r('app.color.button_active'))
        .fontColor(Color.White)
        .width(200)
        .height(52)
        .borderRadius(10)
        .onClick(() => {
          router.pushUrl({ url: 'pages/VideoPage' });
        })

      Button($r('app.string.audio_nav_btn'))
        .fontSize($r('app.float.btn_font_size'))
        .backgroundColor($r('app.color.play_btn_color'))
        .fontColor(Color.White)
        .width(200)
        .height(52)
        .borderRadius(10)
        .onClick(() => {
          router.pushUrl({ url: 'pages/AudioPage' });
        })

      Button($r('app.string.ai_nav_btn'))
        .fontSize($r('app.float.btn_font_size'))
        .backgroundColor($r('app.color.button_active'))
        .fontColor(Color.White)
        .width(200)
        .height(52)
        .borderRadius(10)
        .onClick(() => {
          router.pushUrl({ url: 'pages/AIPage' });
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.page_bg'))
    .alignItems(HorizontalAlign.Center)
  }
}
