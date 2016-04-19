describe 'items', ->

  beforeEach ->
    cy
      .visitMainPage()
      .login()
      .clearLists()
      .createList()
      .get('.list').first().within ->
        cy.get('input').type('list name', force: true)
        cy.get('.toggle-options').click(force: true)
        cy.get('.name').click(force: true)

  it 'shows the items', ->
    cy
      .get '.items h1'
      .should 'have.text', 'list name'

  it 'shows no items message', ->
    cy.get('.no-items').should 'have.text', 'No Items'

  describe 'returning to app', ->

    beforeEach ->
      cy.reload()

    it 'shows the previously selected list', ->
      cy
        .get '.items h1'
        .should 'have.text', 'list name'

  describe 'adding an item', ->

    beforeEach ->
      cy.get('.items > footer button').first().click()

    it 'displays an empty item', ->
      cy.get('.item').should 'have.length', 1

    it 'focuses the item', ->
      cy.get('.item').first().should 'have.class', 'editing'

    describe 'changing the item name', ->

      beforeEach ->
        cy
          .get('.item').first().find 'textarea'
          .type 'some item', force: true
          .reload()

      it 'persists the item name', ->
        cy
          .get('.item').first().find 'textarea'
          .should 'have.text', 'some item'

    describe 'clicking next', ->

      beforeEach ->
        cy.get('.item').first().within ->
          cy.get('textarea').type 'first one'
          cy.get('.next').click(force: true)

      it 'adds another item', ->
        cy
          .get '.item'
            .should 'have.length', 2
          .first().find('textarea').should 'have.value', 'first one'

      describe 'from first item', ->

        beforeEach ->
          cy.get('.item').first().find('.next').click(force: true)

        it 'focuses the second item', ->
          cy.get('.item').last()
            .should 'have.class', 'editing'

    describe 'checking off the item', ->

      beforeEach ->
        cy
          .get('.item').first().find '.toggle-checked'
          .click(force: true)
          .reload()

      it 'persists the item checked state', ->
        cy
          .get('.item').first()
          .should 'have.class', 'checked'

    describe 'removing the item', ->

      beforeEach ->
        cy.get('.item').first().within ->
          cy.get('.toggle-options').click(force: true)
          cy.get('.remove').click(force: true)

      it 'removes the item', ->
        cy.get('.item').should 'have.length', 0

  describe 'clearing completed', ->

    beforeEach ->
      cy
        .get('.items > footer button').first()
        .click()
        .click()
        .click()

      cy.get('.item').first().find('.toggle-checked').click(force: true)
      cy.get('.item').eq(1).find('textarea').type 'will remain', force: true
      cy.get('.item').last().find('.toggle-checked').click(force: true)

      cy.get('.items > footer button').last().click()
      cy.get('.confirm:contains("Clear Completed")').click()

    it 'removes the checked items', ->
      cy
        .get('.item')
          .should 'have.length', 1
        .first().find('textarea')
          .should 'have.value', 'will remain'
