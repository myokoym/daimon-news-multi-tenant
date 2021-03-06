//= require ace-builds/src/ace
//= require ace-builds/src/theme-tomorrow
//= require ace-builds/src/mode-markdown
//= require ace-builds/src/ext-language_tools
//= require bootstrap-markdown-editor
//= require marked

$(function() {
  let $postBody = $('#post_body');

  if ($postBody.length === 0) {
    return;
  }

  let content = $postBody.val();
  let $editor = $('<div id="editor"></div>');

  $postBody.hide();
  $postBody.after($editor);

  $editor.markdownEditor({
    preview: true,
    imageUpload: true,
    uploadPath:  $postBody.data('upload-path'),
    onPreview(content, callback) {
      callback(marked(content));
    }
  });
  $editor.markdownEditor('setContent', content);
  $('form').submit((event) => {
    let content = $editor.markdownEditor('content');

    $postBody.val(content);
  });
});

$(function() {
  let $authorDescription = $('#author_description');

  if ($authorDescription.length === 0) {
    return;
  }

  let content = $authorDescription.val();
  let $editor = $('<div id="editor"></div>');

  $authorDescription.hide();
  $authorDescription.after($editor);

  $editor.markdownEditor({
    preview: true,
    onPreview(content, callback) {
      callback(marked(content));
    }
  });
  $editor.markdownEditor('setContent', content);
  $('form').submit((event) => {
    let content = $editor.markdownEditor('content');

    $authorDescription.val(content);
  });
});
