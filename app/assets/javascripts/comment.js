const regExpForEmail = /^[a-zA-Z][a-zA-Z0-9\.\_]*\@[a-zA-Z]+(\.\w+)?(\.[a-zA-Z]{2,3})$/;

var Comment = function(htmlInfo) {
  this.commentDiv = $(htmlInfo.commentDiv);
  this.guestForm = $(htmlInfo.guestForm);
  this.projectDetails = $(htmlInfo.projectDetails);
  this.loginModal = $(htmlInfo.loginModal);
  this.loginNotice = $(htmlInfo.loginNotice);
  this.guestUser = $(htmlInfo.guestUser);
  this.deleteCommentLink = $(htmlInfo.deleteCommentLink);
  this.userLoginSelector = htmlInfo.userLoginSelector;
  this.textBox = this.commentDiv.find('form:last :text');
  this.deleteImage = $(htmlInfo.deleteImage);
  this.isvalid = true;
  this.isGuestUser = false;
}

Comment.prototype.bindEvents = function() {
  var _this = this;

  _this.commentDiv.on('submit', $('form'), function(event) {
    event.preventDefault();
    _this.commentElement = $(this).find('form:last');
    _this.saveComment();
  })

  _this.projectDetails.on('click', _this.userLoginSelector, function() {
    _this.guestForm.modal('hide');
    _this.loginModal.modal('show');
    _this.loginNotice.hide();
  })

  _this.guestUser.submit(function() {
    _this.isGuestUser = true;
    _this.isGuestInfoValid();
    _this.isvalid ? _this.sendCommentToServer() : alert("Invalid Information");
  });

  _this.deleteCommentLink.on('click', _this.deleteImage, function(event) {
    event.stopPropagation();
    console.log(event.target);
    _this.url = this.getAttribute('href');
    _this.currentComment = $(this).parents('.comment');
    _this.deleteComment();
  });

  _this.deleteCommentLink.click(function(event) {
    event.preventDefault();
  });
}

Comment.prototype.deleteComment = function() {
  var _this = this;
  $.ajax({
    type: 'DELETE',
    url: _this.url,
    dataType: "html"
  })
  .done(function(){
    _this.currentComment.remove();
  })
  .fail(function() {
    alert("Comment could not be deleted");
  })
}

Comment.prototype.saveComment = function() {
  var comment = this.textBox.val().trim();

  this.data = {
    'project_id' : this.textBox.attr('project_id'),
    'description' : comment    
  };

  if(comment) this.sendCommentToServer();
}

Comment.prototype.sendCommentToServer = function() {
  var _this = this;
  $.ajax({
    type : 'POST',
    url : _this.textBox.attr('url'),
    data : _this.data,
    dataType : 'HTML'
  })
  .done(function(response) {
    _this.handleSuccess();
  })
  .fail(function(response) {
    _this.handleFailure(response.status);
  })
  
}

Comment.prototype.handleSuccess = function() {
  if(this.isGuestUser) {
    window.location = window.location.href;
    alert('Your comment was posted successfully');
  } else {
    this.createNewCommentElement();
    this.textBox.attr('readonly', true);
  }
}

Comment.prototype.handleFailure = function(status) {
  
  switch(status) {
    case 401:
      this.guestForm.modal('show');
      break;
    default:
      alert('Your request could not be completed');
  }

}

Comment.prototype.createNewCommentElement = function() {
  newCommentElement = this.commentElement.clone();
  newCommentElement.find(':text').val(null);
  this.commentDiv.append(newCommentElement);
}

Comment.prototype.isGuestInfoValid = function() {
  
  this.data = {
    'project_id' : this.textBox.attr('project_id'),
    'name' : this.guestUser.find('#name').val().trim(),
    'email' : this.guestUser.find('#email').val().trim(),
    'description' : this.guestUser.find('#guest_comment').val().trim()
  };

  this.isvalid = this.data.name && this.data.email && this.data.description && regExpForEmail.test(this.data.email);
}


$(function() {

  htmlInfo = {
    'commentDiv' : '#comments',
    'guestForm' : '#guest_form',
    'userLoginSelector' : '#guest',
    'loginModal' : '#login_form',
    'projectDetails' : '#project_details',
    'loginNotice' : '#login_notice',
    'guestUser' : '#guest_user',
    'deleteCommentLink' : '.delete_comment',
    'deleteImage' : '.delete_image'
  }

  var projectComment = new Comment(htmlInfo);
  projectComment.bindEvents();

})