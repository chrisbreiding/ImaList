describe 'authentication', ->

  beforeEach ->
    cy.visitMainPage()

  it 'shows the login form', ->
    cy
      .get '.login h1'
      .should 'have.text', 'Please Log In'

  describe 'logging in with incorrect password', ->

    beforeEach ->
      cy.login 'wrong'

    it 'shows an error message', ->
      cy
        .get '.error'
        .should 'have.text', 'Login failed. Please try again.'

  describe 'logging in with correct password', ->

    beforeEach ->
      cy.login()

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
