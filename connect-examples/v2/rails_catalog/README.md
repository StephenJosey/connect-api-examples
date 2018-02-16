# README

This sample application showcases a variety of ways to utilize Square's Catalog API.
It also utilizes a basic shopping cart to show a possible way of tracking customer's items before purchase.

Ruby version: 2.4.2

Rails version: 5.1.4

To get the app running:

* Run bundler, and migrate the db (used for shopping cart)

```
bundle install
rails db:migrate
```
* Add a .env file at the root with following values:

```
SQUARE_APPLICATION_ID=your-app-id
SQUARE_ACCESS_TOKEN=your-access-token
SQUARE_LOCATION_ID=your-location-id
```

* The application runs in `http://localhost:3000/`