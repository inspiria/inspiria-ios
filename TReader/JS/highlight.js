function selectText(colour) {

  const selection = document.getSelection()
  if (! selection.rangeCount ) {
    alert("Please select some text.")
    return
  }

  const range = selection.getRangeAt(0)
  const quoteSelector = anchoring.TextQuoteAnchor.fromRange(document.body, range)
  const exact = quoteSelector.exact
  const prefix = quoteSelector.prefix
  const suffix = quoteSelector.suffix

  const positionSelector = anchoring.TextPositionAnchor.fromRange(document.body, range)
  const start = positionSelector.start
  const end = positionSelector.end

  const titleElement = document.querySelector('head title')
  const title = titleElement ? titleElement.innerText : location.href

  const data = {
    uri: location.href,
    title: title,
    exact: exact,
    prefix: prefix,
    suffix: suffix,
    start: start,
    end: end,
  }

  selection.removeAllRanges();

  const encodedData = JSON.stringify(data)
  return encodedData;
}


function highlight(colour) {
  let text = selectText(colour);
  window.webkit.messageHandlers.highlight.postMessage(text);
}

function annotate(colour) {
  let text = selectText(colour);
  window.webkit.messageHandlers.annotate.postMessage(text);
}
