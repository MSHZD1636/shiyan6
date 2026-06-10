/**
 * 弹幕设置数据模型
 * 用于在 AIPage（设置页）与 Led（展示页）之间传递弹幕内容、字号、字体粗细。
 * 使用状态管理 V2 的 @ObservedV2 / @Trace，保证属性变化时界面自动刷新。
 */
@ObservedV2
export class Settings {
  // 弹幕内容（字符串类型）
  @Trace content: string;
  // 字号大小（数字类型）
  @Trace fontSize: number;
  // 字体粗细
  @Trace fontWeight: FontWeight;

  constructor(content: string, fontSize: number, fontWeight: FontWeight) {
    this.content = content;
    this.fontSize = fontSize;
    this.fontWeight = fontWeight;
  }
}
