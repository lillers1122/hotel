1. What classes does each implementation include? Are they the same?

A. CartEntry, ShoppingCart, Order
B. CartEntry, ShoppingCart, Order

A and B have identically named classes. The classes themselves are not structured the same.

2. Write a sentence to describe each class.

A CartEntry is an object that has a unit price and a quantity.
A ShoppingCart is an object that holds an array of entries.
An Order is an instance of a ShoppingCart that has a method to calculate its total price.

3. How do the classes relate to each other?

Order creates an instance of a ShoppingCart that has a method that can calculate the total_price of the shopping cart. CartEntry is used to create a an instance of a purchasable item (or multiple).

4. What data does each class store?

A. @unit_price, @quantity | @entries | @cart
B. @unit_price, @quantity | @entries | @cart

5. What methods does each class have?

A. Order has total_price
B. price | price | total_price

In implementation B, each class can calculate its own price.

6. Consider the Order#total_price method. In each implementation:
a. Is logic to compute the price delegated to "lower level" classes like ShoppingCart and CartEntry, or is it retained in Order?

A. The logic to compute the price is retained in Order.
B. The logic to compute the price is delegated to the other classes.

b. Does total_price directly manipulate the instance variables of other classes?

A. Yes, total_price performs calculations on ShoppingCart and its contents.
B. No, total_price relies on the ShoppingCart and its contents to know their own prices and share them.

7. If we decide items are cheaper if bought in bulk, how would this change the code? Which implementation is easier to modify?

CartEntry would need to be altered to have an alternative bulk price. Implementation B would be easier to modify because no additional work needs to be done to the Order class (as it would with Implementation A).

8. Which implementation better adheres to the single responsibility principle?

Implementation B better adheres to the single responsibility principle.

9. Bonus question once you've read Metz ch. 3: Which implementation is more loosely coupled?

Implementation B is more loosely coupled.
