const pdfkit = require("pdfkit")
const yaml = require("node-yaml");
const path = require("path");

const PRECISION = 0.001

const UNICODE_RANGES = [
  [0x0020, 0x007F], // Basic Latin
  [0x00A0, 0x00FF], // Latin-1 Supplement
  [0x0100, 0x017F], // Latin Extended-A
  [0x0180, 0x024F], // Latin Extended-B
  [0x0250, 0x02AF], // IPA Extensions
  [0x02B0, 0x02FF], // Spacing Modifier Letters
  [0x0300, 0x036F], // Combining Diacritical Marks
  [0x0370, 0x03FF], // Greek and Coptic
  [0x0400, 0x04FF], // Cyrillic
  [0x0500, 0x052F], // Cyrillic Supplementary
  [0x20A0, 0x20CF], // Currency Symbols
  [0x1E00, 0x1EFF], // Latin Extended Additional
];

function range_to_chars(range) {
  let chars = new Array();

  for (let i = range[0]; i < range[1]; i++) {
    chars.push(String.fromCodePoint(i));
  }

  return chars
}

function flatten(array) {
  return [].concat.apply([], array);
}

const CHARACTERS = flatten(UNICODE_RANGES.map(range_to_chars));

function calculateKerning(fontFamily, fontSize) {
  let pdf = new pdfkit({size: "A4", layout: "landscape"});
  pdf.font(fontFamily);
  pdf.fontSize(fontSize);

  process.stdout.write("{");

  let charWidths = new Map();
  CHARACTERS.forEach(function(char) {
    let charWidth = pdf.widthOfString(char);
    charWidths[char] = charWidth;
    process.stdout.write(`${JSON.stringify(char)} => ${charWidth},`);
  });

  CHARACTERS.forEach(function(lhs) {
    CHARACTERS.forEach(function(rhs) {
      let digram = lhs + rhs;
      let rawWidth = charWidths[lhs] + charWidths[rhs];
      let kerning = pdf.widthOfString(digram) - rawWidth;

      if (kerning > PRECISION) {
        process.stdout.write(`${JSON.stringify(digram)} => ${kerning},`);
      }
    });
  });

  process.stdout.write("}");
}

calculateKerning(path.join(__dirname, "fonts/DejaVuSans.ttf"), 11)
