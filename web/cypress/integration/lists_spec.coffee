describe 'lists', ->

  beforeEach ->
    cy
      .visitMainPage()
      .login()
      .clearLists()

  it 'shows the lists', ->
    cy
      .get '.lists h1'
      .should 'have.text', 'ImaList'

  describe 'adding a list', ->

    beforeEach ->
      cy.createList()

    it 'displays an empty list item', ->
      cy.get('.list').should 'have.length', 1

    it 'shows the list options', ->
      cy
        .get('.list').first()
        .should 'have.class', 'showing-options'

    describe 'editing a list', ->

      beforeEach ->
        cy
          .get('.list').first().find 'input'
          .type 'some list name', force: true
        cy.reload()

      it 'persists the list name', ->
        cy
        .get('.list').first().find '.name'
        .should 'have.text', 'some list name'

    describe 'sharing a list', ->

      beforeEach ->
        cy
          .get('.list').first().find '.toggle-shared'
          .click(force: true)

      it 'shows that it is shared', ->
        cy
          .get('.list').first().find '.shared-indicator'
          .should 'be.visible'

    describe 'closing the options', ->

      beforeEach ->
        cy
          .get('.list').first().find '.toggle-options'
          .click(force: true)

      it 'hides the options', ->
        cy
          .get('.list').first()
          .should 'not.have.class', 'showing-options'

  describe 'removing a list', ->

    beforeEach ->
      cy
        .createList()
        .get('.list').first().find('.remove').click(force: true)
        .get('.confirm').click()

    it 'removes the list', ->
      cy
        .get '.list'
        .should 'have.length', 0
