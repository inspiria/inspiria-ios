# Bridge Native vs Javascript Documentation

___

## Javascript

### • Display/Update Annotations

```javascript
function update(annotations) {}
```

`annotations` - list of annotations models.

Native will call `update` after document is loaded for the first time, or annotations list is changes (user adds or deletes one of annotations).

### • Create new annotation or highlight

```javascript
function highlight(colour) {}
function annotate(colour) {}
```

Native will call `highlight` after user selects `Highlight` menu. JS function should:

1. Higlight background of curren user selection
2. Calculate annotation model according to current selection
3. Deselect current user selection
4. Call callback function `highlight` with annotation model

Native will call `annotate` after user selects `Annotate` menu. JS function should do the same as in `highlight` function, except calling `annotate` callback instead `highlight`.

___

## Native callbacks

### • New annotation

```javascript
function highlight(annotation) {}
function annotate(annotation) {}
```

`annotation` - annotation model of selected text.

See detals of `highlight` and `annotate` in `Create new annotation or highlight` section;

### • User selection

```javascript
function select(annotationId) {}
```

JS should call `select` with annotation id after user touches annotation.
