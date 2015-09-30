var Image = function(htmlInfo) {
  this.editImageForm = htmlInfo.editImageForm;
  this.cancelButton = htmlInfo.cancelButton;
  this.editButton = $(htmlInfo.editButton);
  this.userImageDiv = $(htmlInfo.userImageDiv);
  this.projectImage = $(htmlInfo.projectImage);
}

Image.prototype.bindEvents = function() {
  var _this = this;

  _this.editButton.click(function() {
    $(this).hide();
    $(_this.editImageForm).show();
  });

  _this.userImageDiv.on('click', _this.cancelButton, function() {
    $(_this.editImageForm).hide();
    _this.editButton.show();
  });

  _this.projectImage.find('img').each(function() {
    var zoomUrl = $(this).attr('large');
    $(this).parent().zoom({ url: zoomUrl });
  });

};

$(function() {
  var htmlInfo = {
    'editImageForm' : '.edit_profile_pic',
    'cancelButton' : '.cancel',
    'editButton' : '.change',
    'userImageDiv' : '#user_image',
    'projectImage' : '.project_image'
  }

  var profileImage = new Image(htmlInfo);
  profileImage.bindEvents();
});