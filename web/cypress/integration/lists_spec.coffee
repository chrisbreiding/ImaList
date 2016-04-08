describe 'lists', ->

  beforeEach ->
    cy
      .visitMainPage()
      .login()

  it 'shows the lists', ->
    cy
      .get '.lists h1'
      .should 'have.text', 'ImaList'

  describe 'adding a list', ->

    beforeEach ->
      cy.get('.lists > footer button').first().click()

    afterEach ->
      cy.get('.lists > ul li').first().find('.remove').click(force: true)
      cy.get('.confirm').click()

    it 'displays an empty list item', ->
      cy
        .get '.lists > ul li'
        .should 'have.length', 1

    it 'shows the list options', ->
      cy
        .get('.lists > ul li').first()
        .should 'have.class', 'showing-options'

    describe 'editing a list', ->

      beforeEach ->
        cy
          .get('.lists > ul li').first().find 'input'
          .type 'some list name', force: true
        cy.reload()

      it 'persists the list name', ->
        cy
        .get('.lists > ul li').first().find '.name'
        .should 'have.text', 'some list name'

    describe 'sharing a list', ->

      beforeEach ->
        cy
          .get('.lists > ul li').first().find '.toggle-shared'
          .click(force: true)

      it 'shows that it is shared', ->
        cy
          .get('.lists > ul li').first().find '.shared-indicator'
          .should 'be.visible'

    describe 'closing the options', ->

      beforeEach ->
        cy
          .get('.lists > ul li').first().find '.toggle-options'
          .click(force: true)

      it 'hides the options', ->
        cy
          .get('.lists > ul li').first()
          .should 'not.have.class', 'showing-options'

  describe 'removing a list', ->

    beforeEach ->
      cy.get('.lists > footer button').first().click()
      cy.get('.lists > ul li').first().find('.remove').click(force: true)
      cy.get('.confirm').click()

    it 'removes the list', ->
      cy
        .get '.lists > ul li'
        .should 'have.length', 0
