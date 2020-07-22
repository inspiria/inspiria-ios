function selectText(colour) {
  var range, text, sel = window.getSelection();
  if (sel.rangeCount && sel.getRangeAt) {
    range = sel.getRangeAt(0);
    text = sel.toString();
  }
  document.designMode = "on";
  if (range) {
    sel.removeAllRanges();
    sel.addRange(range);
  }
  if (!document.execCommand("HiliteColor", false, colour)) {
    document.execCommand("BackColor", false, colour);
  }
  document.designMode = "off";
  window.getSelection().removeAllRanges();
  return text;
}


function highlight(colour) {
  let text = selectText(colour);
  window.webkit.messageHandlers.highlight.postMessage(text);
}

function annotate(colour) {
  let text = selectText(colour);
  window.webkit.messageHandlers.annotate.postMessage(text);
}
