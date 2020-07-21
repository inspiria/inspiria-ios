function makeEditableAndHighlight(colour) {
  var range, sel = window.getSelection();
  if (sel.rangeCount && sel.getRangeAt) {
    range = sel.getRangeAt(0);
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
}

function highlight(colour) {
  var range, sel;
  if (window.getSelection) {
    try {
      if (!document.execCommand("BackColor", false, colour)) {
        makeEditableAndHighlight(colour);
      }
    } catch (ex) {
      makeEditableAndHighlight(colour);
    }
  }
}
