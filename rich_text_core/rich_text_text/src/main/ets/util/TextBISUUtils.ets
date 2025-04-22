import { TextBISUConstants } from "./TextBISUConstants";
import { LengthMetrics } from "@kit.ArkUI";

export function getTextFontStyle(fontSize: number, styles?: Map<string, string>) {
  const textStyle: StyledStringValue = new TextStyle({
    fontSize: LengthMetrics.vp(fontSize),
    fontWeight: isBold(styles) ? FontWeight.Bold : FontWeight.Normal,
    fontStyle: isItalic(styles) ? FontStyle.Italic : FontStyle.Normal
  })

  return textStyle
}

export function getTextDecorationStyle(styles?: Map<string, string>) {
  const decorationArray: StyledStringValue[] = []

  if (isUnderline(styles)) {
    decorationArray.push(new DecorationStyle({ type: TextDecorationType.Underline }))
  }

  if (isStrikeThrough(styles)) {
    decorationArray.push(new DecorationStyle({ type: TextDecorationType.LineThrough }))
  }
  return decorationArray
}

export function isBold(styles?: Map<string, string>): boolean {
  if (!styles) {
    return false
  }
  const weight = styles.get(TextBISUConstants.STYLE_FONT_WEIGHT) as string || ""
  return weight.length > 0 && weight.trim() === TextBISUConstants.FONT_WEIGHT_BOLD;
}

export function isItalic(styles?: Map<string, string>): boolean {
  if (!styles) {
    return false
  }
  const style = styles.get(TextBISUConstants.STYLE_FONT_STYLE) as string || ""
  return style.length > 0 && style.trim() === TextBISUConstants.ITALIC;
}

export function isUnderline(styles?: Map<string, string>): boolean {
  if (!styles) {
    return false
  }
  const underline = styles.get(TextBISUConstants.STYLE_TEXT_DECORATION) as string || ""
  return underline.length > 0 && underline.trim() === TextBISUConstants.UNDERLINE;
}

export function isStrikeThrough(styles?: Map<string, string>): boolean {
  if (!styles) {
    return false
  }
  const through = styles.get(TextBISUConstants.STYLE_TEXT_DECORATION) as string || ""
  return through.length > 0 && through.trim() === TextBISUConstants.STRIKE_THROUGH;
}