var IndexPage = function (htmlInfo) {
  this.stateContainer = $(htmlInfo.stateContainer);
}

IndexPage.prototype.bindEvents = function () {
  var _this = this
  _this.stateContainer.click(function (event) {
    event.preventDefault();
    _this.stateContainer = this;
    _this.sendAjaxRequest();
  });
}

IndexPage.prototype.sendAjaxRequest = function() {
  $(this.stateContainer).hasClass('user') ? this.sendUserUpdateStateAjax() : this.sendProjectUpdateStateAjax();
}

IndexPage.prototype.sendUserUpdateStateAjax  =function() {
  var _this = this;

  $.post(_this.stateContainer.href, { id: _this.stateContainer.id }, function(response) {
    response ? _this.toggleState(_this.stateContainer) : alert("Sorry! Request could not be processed");
  }, "json");

}

IndexPage.prototype.sendProjectUpdateStateAjax = function() {
  var _this = this;

  $.ajax({
    type: 'POST',
    url: _this.stateContainer.href,
    data: { id: _this.stateContainer.id, status: _this.stateContainer.text + "ed" },
    dataType: 'html'
    })
    .done(function(response) {
      var newState = _this.getNewState();
      $(_this.stateContainer).html(newState);
    })
    .fail(function(){
      alert("Sorry! Request could not be processed"); 
    });

}

IndexPage.prototype.getNewState = function() {
  var newState = "";
  switch(this.stateContainer.text) {
    case 'Publish':
      newState = 'Unpublish';
      break;
    case 'Cancel':
      newState = 'Reopen';
      break;
    case 'Reopen':
      newState = 'Cancel';
      break;
    case 'Unpublish':
      newState = 'Publish';
      break;
  }
  return newState;
}

IndexPage.prototype.toggleState = function() {
  this.stateContainer.text = (this.stateContainer.text == 'activate') ? 'deactivate' : 'activate';
}

$(function(){
  var htmlInfo = {
    'stateContainer' : '.state'
  };

  var userIndex = new IndexPage(htmlInfo);
  userIndex.bindEvents();
  
});
