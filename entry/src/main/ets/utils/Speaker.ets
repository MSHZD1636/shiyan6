import { textToSpeech } from '@kit.CoreSpeechKit';
import { BusinessError } from '@kit.BasicServicesKit';

/**
 * 朗读工具类
 * 对鸿蒙官方 AI 服务工具包（CoreSpeechKit 文本转语音）进行封装，
 * 对外提供「创建引擎、开始朗读、停止朗读、释放引擎」等高级功能。
 */
export class Speaker {
  // 文本转语音引擎实例
  private ttsEngine?: textToSpeech.TextToSpeechEngine;

  constructor() {
    this.createEngine();
  }

  /**
   * 创建文本转语音引擎
   */
  private createEngine(): void {
    const extraParam: Record<string, Object> = {
      'style': 'interaction-broadcast',
      'locate': 'CN',
      'name': 'EngineName'
    };
    const initParams: textToSpeech.CreateEngineParams = {
      language: 'zh-CN',
      person: 0,
      online: 1,
      extraParams: extraParam
    };
    textToSpeech.createEngine(initParams)
      .then((engine: textToSpeech.TextToSpeechEngine) => {
        this.ttsEngine = engine;
      })
      .catch((err: BusinessError) => {
        console.error(`创建语音引擎失败 code: ${err.code}, message: ${err.message}`);
      });
  }

  /**
   * 开始朗读
   * @param text 需要朗读的文本内容
   */
  startSpeak(text: string): void {
    if (!this.ttsEngine || !text) {
      return;
    }
    const speakParams: textToSpeech.SpeakParams = {
      requestId: Date.now().toString()
    };
    this.ttsEngine.speak(text, speakParams);
  }

  /**
   * 停止朗读
   */
  stopSpeak(): void {
    this.ttsEngine?.stop();
  }

  /**
   * 释放语音引擎资源
   */
  shutdownEngine(): void {
    this.ttsEngine?.shutdown();
    this.ttsEngine = undefined;
  }
}
