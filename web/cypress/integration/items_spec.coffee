describe 'items', ->

  beforeEach ->
    cy
      .visitMainPage()
      .login()
      .clearLists()
      .createList()
      .selectList()

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
      cy.focused().parent().should 'have.class', 'item'

    describe 'changing the item name', ->

      beforeEach ->
        cy
          .get('.item').first().find 'textarea'
          .type 'some item'
          .reload()

      it 'persists the item name', ->
        cy
          .get('.item').first().find 'textarea'
          .should 'have.text', 'some item'

    describe 'hitting enter', ->

      beforeEach ->
        cy.get('.item').first().find('textarea').type 'first one{enter}'

      it 'adds another item and focuses it', ->
        cy
          .get '.item'
            .should 'have.length', 2
          .first().find('textarea')
            .should 'have.value', 'first one'

        cy.focused()
          .parent()
            .should 'have.class', 'item'
          .prev()
            .should 'have.class', 'item' # makes sure the focused one is second

    describe 'double-tapping enter', ->

      beforeEach ->
        cy
          .get('.item').first().find 'textarea'
          .type 'first one{enter}{enter}second line'

      it 'adds a new line', ->
        cy
          .get('.item').first().find 'textarea'
          .should 'have.value', 'first one\nsecond line'

    describe 'checking off the item', ->

      beforeEach ->
        cy
          .get('.item').first().find('textarea').blur()
          .get('.item').first().find '.toggle-checked'
          .click()
          .reload()

      it 'persists the item checked state', ->
        cy
          .get('.item').first()
          .should 'have.class', 'is-checked'

    describe 'removing the item', ->

      beforeEach ->
        cy.get('.item').first().within ->
          cy
            .get('.toggle-options').click()
            .get('.remove').click()

      it 'removes the item', ->
        cy.get('.item').should 'have.length', 0

  describe 'adding a label', ->

    beforeEach ->
      cy.get('.items > footer button').eq(1).click()

    it 'displays an empty label', ->
      cy.get('.type-label').should 'have.length', 1

    it 'focuses the label', ->
      cy.focused().parent().should('have.class', 'type-label')

  describe 'bulk adding items', ->

    beforeEach ->
      cy.get('.items > footer button').eq(2).click()

    it 'displays the bulk add form', ->
      cy.get('.bulk-add').should 'have.class', 'modal-showing'

    describe 'canceling', ->

      beforeEach ->
        cy.get('.bulk-add .cancel').click()

      it 'hides the bulk add form', ->
        cy.get('.bulk-add').should 'not.have.class', 'modal-showing'

    describe 'adding', ->

      beforeEach ->
        cy
          .get('.bulk-add textarea').type 'one{enter}two{enter}three'
          .get('.bulk-add .add').click()

      it 'hides the bulk add form', ->
        cy.get('.bulk-add').should 'not.have.class', 'modal-showing'

      it 'adds 3 items', ->
        cy
          .get('.item').should 'have.length', 3
          .get('.item').first().find('textarea').should 'have.value', 'one'
          .get('.item').eq(1).find('textarea').should 'have.value', 'two'
          .get('.item').eq(2).find('textarea').should 'have.value', 'three'

  describe 'clearing completed', ->

    beforeEach ->
      cy
        .get('.items > footer button').first()
        .click()
        .click()
        .click()

        .get('.item').first().find('.toggle-checked').click()
        .get('.item').eq(1).find('textarea').type 'will remain'
        .get('.item').last().find('.toggle-checked').click()

        .get('.items > footer button').last().click()
        .get('.confirm:contains("Clear Completed")').click()

    it 'removes the checked items', ->
      cy
        .get('.item')
          .should 'have.length', 1
        .first().find('textarea')
          .should 'have.value', 'will remain'

  describe 'wide mode', ->

    describe 'when no list is selected', ->

      it 'shows no list selected message', ->
        cy
          .get('.back').click()
          .viewport(560, 300)
          .get('.no-items')
            .should('have.text', 'No List Selected')
