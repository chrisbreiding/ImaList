Cypress.addParentCommand('visitMainPage', function () {
  cy
    .server().visit('/')
    .get('.settings button').click()
    .get('.settings input').clear().type('imalist-test{enter}');
});

Cypress.addParentCommand('login', function (password) {
  password = password || Cypress.env('password');
  cy
    .get('.login input[type=email]').type(Cypress.env('email'))
    .get('.login input[type=password]').type(password)
    .get('.login > form button').click();
});

Cypress.addParentCommand('clearLists', function () {
  var $ = Cypress.$

  cy
    .get('.lists > footer button').first().click()
    .get('.list')
    .then(function () {
      $('.list').each(function () {
        $(this).find('.remove').click()
        $('.confirm:contains("Remove List")').click()
      });
    });
});

Cypress.addParentCommand('createList', function () {
  cy.get('.lists > footer button').first().click();
});
