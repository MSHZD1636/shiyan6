import router from '@ohos.router';
import media from '@ohos.multimedia.media';
import common from '@ohos.app.ability.common';
import resourceManager from '@ohos.resourceManager';

@Entry
@Component
struct AudioPage {
  @State isPlaying: boolean = false;
  @State currentTimeSec: number = 0;
  @State durationSec: number = 0;
  @State statusText: string = '准备中...';
  private avPlayer: media.AVPlayer | null = null;
  private context = getContext(this) as common.UIAbilityContext;
  private playerState: string = 'idle';

  async aboutToAppear() {
    await this.initPlayer();
  }

  async initPlayer() {
    try {
      this.avPlayer = await media.createAVPlayer();
      this.setupPlayerListeners();

      // 优先用 getRawFileDescriptor（API9+），兜底用 getRawFd
      let fd: resourceManager.RawFileDescriptor;
      try {
        fd = await this.context.resourceManager.getRawFileDescriptor('test01.mp3');
      } catch {
        fd = await this.context.resourceManager.getRawFd('test01.mp3');
      }

      this.avPlayer.fdSrc = {
        fd: fd.fd,
        offset: fd.offset,
        length: fd.length
      };
    } catch (err) {
      this.statusText = '初始化失败';
      console.error('AudioPage: 初始化错误 ' + JSON.stringify(err));
    }
  }

  setupPlayerListeners() {
    if (!this.avPlayer) {
      return;
    }
    this.avPlayer.on('stateChange', (state: string) => {
      this.playerState = state;
      switch (state) {
        case 'idle':
          this.statusText = '空闲';
          break;
        case 'initialized':
          this.statusText = '加载中...';
          this.avPlayer?.prepare();
          break;
        case 'prepared':
          this.durationSec = Math.floor((this.avPlayer?.duration ?? 0) / 1000);
          this.statusText = '就绪，可以播放';
          break;
        case 'playing':
          this.isPlaying = true;
          this.statusText = '播放中';
          break;
        case 'paused':
          this.isPlaying = false;
          this.statusText = '已暂停';
          break;
        case 'completed':
          this.isPlaying = false;
          this.statusText = '播放完毕';
          this.currentTimeSec = 0;
          break;
        case 'stopped':
          this.isPlaying = false;
          this.statusText = '已停止';
          this.currentTimeSec = 0;
          break;
        case 'released':
          this.statusText = '已释放';
          break;
        default:
          break;
      }
    });
    this.avPlayer.on('timeUpdate', (time: number) => {
      this.currentTimeSec = Math.floor(time / 1000);
    });
    this.avPlayer.on('error', (err) => {
      this.statusText = `错误: ${err.code} ${err.message}`;
      console.error('AudioPage: AVPlayer错误 ' + JSON.stringify(err));
    });
  }

  aboutToDisappear() {
    this.avPlayer?.release();
    this.avPlayer = null;
  }

  formatTime(sec: number): string {
    const m = Math.floor(sec / 60);
    const s = sec % 60;
    return `${m.toString().padStart(2, '0')}:${s.toString().padStart(2, '0')}`;
  }

  async onClickPlay() {
    if (!this.avPlayer) {
      return;
    }
    try {
      if (this.playerState === 'completed' || this.playerState === 'stopped') {
        // 重置后重新播放
        await this.avPlayer.reset();
        await this.initPlayer();
        await this.avPlayer.play();
      } else {
        await this.avPlayer.play();
      }
    } catch (err) {
      console.error('AudioPage: 播放失败 ' + JSON.stringify(err));
    }
  }

  async onClickPause() {
    try {
      await this.avPlayer?.pause();
    } catch (err) {
      console.error('AudioPage: 暂停失败 ' + JSON.stringify(err));
    }
  }

  async onClickStop() {
    try {
      await this.avPlayer?.stop();
    } catch (err) {
      console.error('AudioPage: 停止失败 ' + JSON.stringify(err));
    }
  }

  build() {
    Column({ space: 20 }) {
      // 标题栏
      Row() {
        Button('← 返回')
          .fontSize($r('app.float.btn_font_size'))
          .backgroundColor($r('app.color.button_bg'))
          .fontColor($r('app.color.button_text'))
          .borderRadius(8)
          .onClick(() => {
            this.avPlayer?.stop();
            router.back();
          })
        Text($r('app.string.audio_page_title'))
          .fontSize($r('app.float.title_font_size'))
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.title_color'))
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 16, bottom: 8 })

      // 音符图标区域
      Column({ space: 8 }) {
        Text('♪')
          .fontSize(72)
          .fontColor($r('app.color.button_active'))
        Text($r('app.string.audio_filename'))
          .fontSize($r('app.float.subtitle_font_size'))
          .fontColor($r('app.color.subtitle_color'))
      }
      .width('90%')
      .padding({ top: 20, bottom: 20 })
      .backgroundColor($r('app.color.card_bg'))
      .borderRadius(12)

      // 时间显示
      Row() {
        Text(this.formatTime(this.currentTimeSec))
          .fontSize($r('app.float.subtitle_font_size'))
          .fontColor($r('app.color.title_color'))
        Text(' / ')
          .fontSize($r('app.float.subtitle_font_size'))
          .fontColor($r('app.color.subtitle_color'))
        Text(this.formatTime(this.durationSec))
          .fontSize($r('app.float.subtitle_font_size'))
          .fontColor($r('app.color.subtitle_color'))
      }

      // 进度条
      Slider({
        value: this.durationSec > 0 ? this.currentTimeSec : 0,
        min: 0,
        max: this.durationSec > 0 ? this.durationSec : 100,
        style: SliderStyle.OutSet
      })
        .width('90%')
        .trackColor($r('app.color.button_bg'))
        .selectedColor($r('app.color.button_active'))
        .onChange((value: number) => {
          if (this.avPlayer && this.durationSec > 0 && this.playerState === 'playing') {
            this.avPlayer.seek(value * 1000, media.SeekMode.SEEK_PREV_SYNC);
          }
        })

      // 状态文字
      Text(this.statusText)
        .fontSize($r('app.float.subtitle_font_size'))
        .fontColor($r('app.color.subtitle_color'))

      // 播放控制按钮
      Row({ space: 20 }) {
        Button($r('app.string.play_btn'))
          .fontSize($r('app.float.btn_font_size'))
          .backgroundColor($r('app.color.play_btn_color'))
          .fontColor(Color.White)
          .borderRadius(8)
          .width(90)
          .onClick(() => {
            this.onClickPlay();
          })
        Button($r('app.string.pause_btn'))
          .fontSize($r('app.float.btn_font_size'))
          .backgroundColor($r('app.color.pause_btn_color'))
          .fontColor(Color.White)
          .borderRadius(8)
          .width(90)
          .onClick(() => {
            this.onClickPause();
          })
        Button($r('app.string.stop_btn'))
          .fontSize($r('app.float.btn_font_size'))
          .backgroundColor($r('app.color.stop_btn_color'))
          .fontColor(Color.White)
          .borderRadius(8)
          .width(90)
          .onClick(() => {
            this.onClickStop();
          })
      }
      .justifyContent(FlexAlign.Center)
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.page_bg'))
  }
}
