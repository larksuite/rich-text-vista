export class ListNodeUtil {
  convertToAlphabet(index: number): string {
    let baseCharCode = 'a'.charCodeAt(0);
    let alphabetStr = '';
    while (index > 0) {
      index--;
      alphabetStr = String.fromCharCode(baseCharCode + index % 26) + alphabetStr;
      index = Math.floor(index / 26);
    }
    return alphabetStr;
  }

  convertToRoman(num: number): string {
    let roman = '';
    for (let element of ROMAN_NUMERAL_MAP) {
      const symbol = element[0];
      const value = element[1];
      while (num >= value) {
        roman += symbol;
        num -= value;
      }
    }
    return roman.toLowerCase();
  }

  generateOrderedListSign(index: number, nestLevel: number): string {
    switch (nestLevel % 3) {
      case 0:
        return `${this.convertToRoman(index)}. `;
      case 1:
        return `${index}. `;
      case 2:
      default:
        return `${this.convertToAlphabet(index)}. `;
    }
  }

  generateUnorderedListSign(nestLevel: number): string {
    return `${OL_SYMBOLS[nestLevel % 3]} `;
  }
}

const OL_SYMBOLS = ["▪", "•", "◦"]

const ROMAN_NUMERAL_MAP = new Map<string, number>([
  ['M', 1000],
  ['CM', 900],
  ['D', 500],
  ['CD', 400],
  ['C', 100],
  ['XC', 90],
  ['L', 50],
  ['XL', 40],
  ['X', 10],
  ['IX', 9],
  ['V', 5],
  ['IV', 4],
  ['I', 1]
])