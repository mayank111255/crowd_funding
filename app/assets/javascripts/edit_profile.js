var CheckBox = function (htmlInfo) {
  this.checkBoxElement = $(htmlInfo.checkBoxElement);
  this.currentAddressElement = $(htmlInfo.currentAddressElement);
  this.permanentAddressElement = $(htmlInfo.permanentAddressElement);
}

CheckBox.prototype.bindEvents = function() {
  var _this = this;
  this.checkBoxElement.bind('click', function() {
    _this.setPermanentAddress();
  });

}

CheckBox.prototype.setPermanentAddress = function() {
  var newAddress = this.checkBoxElement[0].checked ? this.currentAddressElement.val() : null;
  this.permanentAddressElement.val(newAddress);  
}


$(function(){

  var htmlInfo = {
    'checkBoxElement' : '#same_as_current',
    'currentAddressElement' : '#user_profile_attributes_current_address',
    'permanentAddressElement' : '#user_profile_attributes_permanent_address'
  }

  var currentCheckbox = new CheckBox(htmlInfo);
  currentCheckbox.bindEvents();

});