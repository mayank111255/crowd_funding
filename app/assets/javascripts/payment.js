var Payment = function(htmlInfo) {
  this.loginModal = $(htmlInfo.loginModal);
  this.loginNotice = $(htmlInfo.loginNotice);
  this.investButton = $(htmlInfo.investButton);
  this.investedAmountContainer = $(htmlInfo.investedAmountContainer);
  this.minimumAmount = parseInt(this.investedAmountContainer.attr('minimum'));
  this.maximumAmount = parseInt(this.investedAmountContainer.attr('maximum'));
}

Payment.prototype.bindEvents = function() {
  var _this = this;
  _this.investButton.click(function(event) {
    event.preventDefault();
    _this.validatePayment();
  });
}

Payment.prototype.validatePayment = function() {
  var userDonation = parseInt(this.investedAmountContainer.val());
  if(userDonation >= this.minimumAmount && userDonation <= this.maximumAmount) {
    this.redirectToPaymentPage();
  } else {
    alert("Invalid Amount - Amount should in range " + this.minimumAmount + " - " + this.maximumAmount);
  }
}

Payment.prototype.redirectToPaymentPage = function() {
  var _this = this;

  var url = this.investButton.attr('url');
  var amount = this.investedAmountContainer.val();

  var request = $.ajax({
    type : 'POST',
    url : url,
    data : { 'amount' : amount },
    dataType : 'html'
  })
  .done(function() {
    window.location = request.getResponseHeader('location');
  })
  .fail(function(response) {
    _this.handleFailure(request, response);
  })
  
}

Payment.prototype.handleFailure = function(request, response) {
  switch(response.status) {
    case 401:
      this.loginModal.modal('show');
      this.loginNotice.html('Please log in');    
      break;
    case 402:
      window.location = request.getResponseHeader('location');
      break;
    default:
      alert('Invalid Request');
      break;
  }
}

$(function() {
  htmlInfo = {
    'investButton' : '#invest_button',
    'investedAmountContainer' : '#invested_amount',
    'loginModal' : '#login_form',
    'loginNotice' : '#login_notice'
  }

  var donation = new Payment(htmlInfo);
  donation.bindEvents();
});