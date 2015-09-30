var Filter = function(htmlInfo) {
  this.filterElement = $(htmlInfo.filter);
  this.loadMoreElement = htmlInfo.loadMore;
  this.projectsDiv = $(htmlInfo.projectsDiv);
  this.sortByElement = $(htmlInfo.sortBy);
  this.sortBy = this.sortByElement.val();
  this.filter = this.filterElement.val();
}

Filter.prototype.bindEvents = function() {
  var _this = this;
  _this.sortByElement.change(function() {
    _this.sortBy = this.value;
    _this.setProperties(true, this);
  });

  _this.filterElement.change(function() {
    _this.filter = this.value;
    _this.setProperties(true, this);
  });

  _this.projectsDiv.on('click', _this.loadMoreElement, function(event) {
    event.preventDefault();
    _this.setProperties(false, event.target);
  });

}

Filter.prototype.setProperties = function(replaceHome, currentElement) {
  this.replaceHome = replaceHome;
  this.currentElement = currentElement;
  this.sendAjax();
}

Filter.prototype.sendAjax = function() {
  var _this = this;
  var url = $(_this.currentElement).attr('href');
  var offset = $(_this.currentElement).attr('offset');

  $.ajax({
    type: 'GET',
    url: url,
    data: { filter: _this.filter, sort_by: _this.sortBy, offset: offset },
    dataType: 'html'
  })

    .done(function(response) {
      _this.replaceHome ? $(_this.projectsDiv).html(response) : _this.appendContent(response);
    })
    
    .fail(function() {
      alert('Request could not be completed');
    })
}

Filter.prototype.appendContent = function(response) {
  $(this.currentElement).remove();

  $(this.projectsDiv).append(response);
}

$(function() {
  htmlInfo = {
    'filter' : '#filter',
    'sortBy' : '#sort_by',
    'projectsDiv' : '#projects',
    'loadMore' : '.load',
  };
  var projectFilter = new Filter(htmlInfo);
  projectFilter.bindEvents();
});