describe 'authentication', ->

  beforeEach ->
    cy.server().visit '/', onBeforeLoad: (contentWindow)->
      contentWindow.localStorage.appName = 'imalist-test'

  it 'shows the login form', ->
    cy
      .get '.login h1'
      .should 'have.text', 'Please Log In'

  describe 'logging in with incorrect password', ->

    beforeEach ->
      cy
        .get('.login input[type=email]').type Cypress.env('email')
        .get('.login input[type=password]').type 'wrong'
        .get('.login button').click()

    it 'shows an error message', ->
      cy
        .get '.error'
        .should 'have.text', 'Login failed. Please try again.'

  describe 'logging in with correct password', ->

    beforeEach ->
      cy
        .get('.login input[type=email]').type Cypress.env('email')
        .get('.login input[type=password]').type Cypress.env('password')
        .get('.login button').click()

    it 'shows the lists', ->
      cy
        .get '.lists h1'
        .should 'have.text', 'ImaList'

    describe 'then logging out', ->

      beforeEach ->
        cy.get('.logout').click()

      describe 'and confirming', ->

        beforeEach ->
          cy.get('.confirm').click()

        it 'shows the login form', ->
          cy
            .get '.login h1'
            .should 'have.text', 'Please Log In'

      describe 'and canceling', ->

        beforeEach ->
          cy.get('.cancel').click()

        it 'stays on the lists', ->
          cy
            .get '.lists h1'
            .should 'have.text', 'ImaList'
