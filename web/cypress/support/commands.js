Cypress.addParentCommand('login', function (password) {
  password = password || Cypress.env('password');
  cy
    .get('.login input[type=email]').type(Cypress.env('email'))
    .get('.login input[type=password]').type(password)
    .get('.login button').click();
});
