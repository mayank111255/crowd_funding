var Form = function(htmlInfo) {
  this.signupLink = $(htmlInfo.signupLink);
  this.loginLink = $(htmlInfo.loginLink);
  this.signupContainer = $(htmlInfo.signupContainer);
  this.loginContainer = $(htmlInfo.loginContainer);
  this.loginModal = $(htmlInfo.loginModal);
  this.signupModal = $(htmlInfo.signupModal);
  this.flashElement = $(htmlInfo.flashElement);
  this.navbar = $(htmlInfo.navbar);
  this.loginForm = htmlInfo.loginForm;
  this.loginNotice = htmlInfo.loginNotice;
}

Form.prototype.bindEvents = function() {
  var _this = this;
  
  _this.loginLink.click(function(event) {
    _this.removeFlashFromBackground();
    $(_this.loginNotice).hide();
    _this.loginModal.modal('show');
  });

  
  _this.navbar.on('submit', _this.loginForm, function(event) {
    event.preventDefault();
    _this.authenticateUser();
  });

  _this.signupLink.click(function(event) {
    event.preventDefault();
    _this.removeFlashFromBackground();
    _this.signupModal.modal('show');
    _this.bindSignupEvents();
  });

}

Form.prototype.authenticateUser = function() {
  var form = this.loginContainer.find(this.loginForm);
  var email = form.find('#email').val();
  var password = form.find('#password').val();
  var data = { email: email, password: password }
  this.sendLoginFormAjax(form, data);
}

Form.prototype.sendLoginFormAjax= function(form, data) {
  var _this = this;

  $.ajax({
    type: "POST",
    url: form.attr('action'),
    data: data,
    success: function() {
      window.location = window.location.href;
    },
    error: function() {
      $(_this.loginNotice).html('Invalid Crendentials')
      $(_this.loginNotice).show()
    }
  })

}

Form.prototype.bindSignupEvents = function() {
  var _this = this;
  var form = $(_this.signupContainer.find('#new_user'));

  form.submit(function(event) {
    event.preventDefault();
    _this.extractSignupInputs(form);
  });

}

Form.prototype.extractSignupInputs = function(form) {
  var name = form.find('#user_name').val();
  var email = form.find('#user_email').val();
  var password = form.find('#user_password').val();
  var passwordConfirmation = form.find('#user_password_confirmation').val();
  var data = { name: name, email: email, password: password, password_confirmation: passwordConfirmation };
  this.sendSignupFormAjax(form, data);  
}

Form.prototype.sendSignupFormAjax = function(form, data) {
  var _this = this;
  
  $.post(form.attr('action'), data, function (response) {
    response.errors ? _this.displayRegistrationErrors(response.errors) : (window.location = response.redirect_url)
  }, "json");

}

Form.prototype.displayRegistrationErrors= function(errors) {
  for(error in errors) {
    $("#" + "user_" + error).after("<div id='errors'>" + errors[error] + "</div>");
  }
}

Form.prototype.removeFlashFromBackground = function() {
  $(this.flashElement).fadeOut("slow");
}

$(document).ready(function() {
  var htmlInfo = {
    'loginLink' : '#login_anchor',
    'signupLink' : '#signup_anchor',
    'signupContainer' : '#signup_container',
    'loginContainer' : '#login_container',
    'loginModal' : '#login_form',
    'signupModal' : '#signup_form',
    'loginForm' : '#login_user',
    'flashElement': 'p.notice',
    'loginNotice' : '#login_notice',
    'navbar' : '.navbar'
  }

  var modalForm = new Form(htmlInfo);
  modalForm.bindEvents();

});
