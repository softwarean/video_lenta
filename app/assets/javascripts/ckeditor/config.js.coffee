CKEDITOR.editorConfig = (config) ->
  config.toolbar = "Standart"
  config.toolbar_Standart = [
    [ "Cut", "Copy", "Paste" ]
    [ "Undo", "Redo" ]
    [ "Bold", "Italic", "Underline", "Strike" ]
    [ "NumberedList", "BulletedList", "-", "Outdent", "Indent", "Blockquote" ]
    [ 'Format','Font','FontSize' ]
    [ 'TextColor','BGColor' ]
    [ 'Link','Unlink','Anchor' ]
    [ 'Table','HorizontalRule','SpecialChar','PageBreak' ]
    [ 'Maximize', 'ShowBlocks','-']
  ]
