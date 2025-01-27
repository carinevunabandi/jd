Oyster Card Coding Test
-----------------------
We'd like you to model the following fare card system, a limited version of London’s Oyster card system. At your interview, you should be able to demonstrate a user loading a card with £30, taking the following trips, and then viewing the balance.

•	Tube: Holborn to Earl’s Court
•	328 bus from Earl’s Court to Chelsea
•	Tube: Earl’s Court to Hammersmith

Operation
1.	When the user passes through the inward barrier at the station, their oyster card is charged the maximum fare.

2.	When they pass out of the barrier at the exit station, the fare is calculated and the maximum fare transaction is removed and replaced with the real transaction (in this way, if the user doesn’t swipe out, they are charged the maximum fare).

3.	Similarly, if they swipe out without swiping in, they are charged the maximum fare.

4.	They will be refused entry if the balance on the card is not at least the minimum fare for that station.

5.	All bus journeys are charged at the same price.
Data
For this test use the following data:
Stations and zones:
Station	Zones
Holborn	1
Earl's Court	1, 2
Wimbledon	3
Hammersmith	2
    

Fares:
Journey	Fare
Anywhere in Zone 1	£2.50
Any one zone outside zone 1	£2.00
Any two zones including zone 1	£3.00
Any two zones excluding zone 1	£2.25
Any three zones	£3.20
Any bus journey	£1.80

The maximum possible fare is therefore £3.20.


Some things to remember:
•	Don't be concerned about the speed of the app; it's just a talking point demo.
•	It doesn't need to be 100% perfect as per the spec. Just do an hour of work and talk about what you would do from that point, i.e., the skeleton plus however much meat you can put on it in a reasonable time frame.
•	Don't worry about making pristine examples, saying "this bit doesn't look quite right because...., therefore I would...." as part of your demonstration is fine and is a good talking point.
•	Don't be afraid to talk about things you didn't do but would have done if doing this for real.
•	More broadly, the goal here is to allow you to express your approach and thought process to the panel. The actual final product is secondary to this.


