Feature: create a book

  Background:
    Given url 'http://library2.cybertekschool.com/rest/v1'
    * def LibraryDataGenerator = Java.type('com.app.utils.LibraryDataGenerator')
    # point another feature file
    * def tokenFeature = call read('classpath:features/Authentication.feature')
    * def authToken = tokenFeature.token
    * print authToken

  @fight
  Scenario: book tests
    # POST A BOOK
    * header x-library-token = authToken
    * def book = LibraryDataGenerator.createBook()
    * form fields book
    * path 'add_book'
    When method post
    Then status 200
    * print response
    * def bookId = response.book_id
    * match response  == { "book_id": "#notnull","message": "The book has been created."}
    * print bookId
    # GET BOOK
    Given header x-library-token = authToken
    * path 'get_book_by_id', bookId
    When method get
    Then status 200
    * print response
    * match response.name == book.name
    # DELETE AND VERIFY ERROR MESSAGE
    Given header x-library-token = authToken
    * path 'delete_book', bookId
    When method delete
    Then status 403