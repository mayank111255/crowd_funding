var Form = function(htmlInfo){
  this.uploadMoreLinks = $(htmlInfo.uplaodMoreLinks);
  this.projectTotalAmount = $(htmlInfo.projectTotalAmount);
  this.userMinimumContribution = $(htmlInfo.userMinimumContribution);
}

Form.prototype.bindEvents = function() {
  var _this = this;
  _this.uploadMoreLinks.click(function(event) {
    _this.currentTableData = $(this).parents('td');
    _this.createFileField();
  });

  _this.projectTotalAmount.change(function() {
    _this.userMinimumContribution.val(this.value/10);
  });

}

Form.prototype.createFileField = function() {
  var currentFileField = this.currentTableData.find('input:file').last();
  var currentHiddenField = this.currentTableData.find(':hidden').last();
  
  this.newFileField = currentFileField.clone();
  this.newHiddenField = currentHiddenField.clone();

  this.changeNewFileFieldName(currentFileField);
  this.changeNewHiddenFieldName(currentHiddenField);

  currentHiddenField.last().after(this.newFileField, this.newHiddenField);
}

Form.prototype.changeNewFileFieldName = function(currentFileField) {
  this.newFileField.removeAttr('required id');

  var currentFileFieldName = currentFileField.attr('name');
  this.generateNewFieldName(currentFileFieldName);
  this.newFileField.attr('name', this.newFieldName);

}

Form.prototype.changeNewHiddenFieldName = function(currentHiddenField) {
  this.newHiddenField.removeAttr('id');
  
  var currentHiddenFieldName = currentHiddenField.attr('name');
  this.generateNewFieldName(currentHiddenFieldName);
  this.newHiddenField.attr('name', this.newFieldName);

}

Form.prototype.generateNewFieldName = function(currentFieldName) {
  var index = currentFieldName.search(/\d/);
  var newAttachmentId = parseInt(currentFieldName[index]) + 1;
  this.newFieldName = [currentFieldName.slice(0,index), newAttachmentId, currentFieldName.slice(index + 1)].join('');
}

$(function() {
  htmlInfo = {
    'uplaodMoreLinks' : '.upload',
    'projectTotalAmount' : '#project_total_amount',
    'userMinimumContribution' : '#project_user_minimum_contribution'
  }

  var projectForm = new Form(htmlInfo);
  projectForm.bindEvents();
});