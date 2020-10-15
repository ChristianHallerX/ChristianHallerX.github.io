---
title: Smart AirBnB booking in Berlin
image: /assets/img/research/Berlin_AirBnB/Berlin_AirBnB_Cover.png
description: >
  Explore AirBnB listings - what options drive the price?
---

0. this unordered seed list will be replaced by toc as unordered list
{:toc}

I have been to Berlin for various occasions and will likely visit there again. My stays are a mix of hotel rooms, hostels, and private rooms with AirBnB. Returning there, I would like to optimize my AirBnB booking, and for that reason I am running an analysis on the current listings. The most touristy attractions, including government institutions, are located in 'Mitte' central district. My hypothesis is that listings are going to be most expensive in the center. Perhaps you can learn something from this, too and optimize your spending. Caution: these findings are for Berlin specifically and may not carry over to other cities.


## The purpose of this analysis:
Find optimal AirBnB website settings that lead to smart booking decisions. What types of listings cost more? Where are prices lowest/highest? etc.

	A. How are the prices distributed?
	B. Breakdown of listings by room type.  
	C. What is the median price of a listing by district and room type. 
	D. What is the average difference in a listing price between superhost and non-superhost status for each room type and district?
	E. Which website options influence the price? (Regression problem: idenfying predictor variables)
	

<br><img src="\assets\img\research\Berlin_AirBnB\large-berlin-districts-map.jpg" alt="Berlin Map" style="width:640px"><br>
Image Source: <a href="https://www.mapsland.com/europe/germany/berlin/large-berlin-districts-map" target="_blank">mapsland.com</a><br>


## Data Source
The Berlin data are very recent and were obtained from <a href="http://insideairbnb.com/get-the-data.html" target="_blank">Inside AirBnB</a>.

**Download Date**: 17<sup>th</sup> September 2020. 

**Scraping Date**: 30<sup>th</sup> August 2020.

The files loaded are the listings.csv (all active accommodation places for Berlin) and the calender.csv (availability of accommodations with date and price).

Inside AirBnB serves a map of all the data set samples: <a href="http://insideairbnb.com/berlin/" target="_blank">Distribution of samples map</a>.


## Analysis Steps
1. **Download Data**
2. **Explore Data**
3. **Data Cleaning**
4. **Analyze/Visualize** (question A-D)
5. **Model** (question E)
	- Random Forest Regressor
	- Linear Regression
	- Gradient Boosting

The Jupyter/Python notebook for this analysis can be found <a href="https://github.com/ChristianHallerX/DataScienceProjects/blob/master/AirBNB_Berlin.ipynb" target="_blank">**here**</a>.



## Results

### A. How are the prices distributed?

<br><img src="\assets\img\research\Berlin_AirBnB\price_distribution.png" alt="price distribution" style="width:720px">

Figure summary:

The price distribution shows that the majority of listings are *Private rooms* and *Entire home/apt*.

The *Private room* category has the majority of its listings cheaper than *Entire home/apt* and also has a shorter tail. The room types *Shared room* and *Hotel room* have much fewer counts.

Listings in the *Shared room* category are cheaper than *Private rooms*. *Hotel room* counts are almost indistinguishible.


### B. What is the room type breakdown?

<br><img src="\assets\img\research\Berlin_AirBnB/room_types.png" alt="room price doughnut" style="width:640px">

Figure summary:

The room distribution on AirBnB Berlin is relatively balanced between private rooms (41%) and entire homes/apartments (56%). A much smaller proportion of 1% are shared rooms with other guests, which are hostel style accomodations, and another 1% are listed Hotel rooms. 


### C. What is the median listing price by room type and district?

<br><img src="\assets\img\research\Berlin_AirBnB\price_range_district.png" alt="price distribution by district" style="width:720px">


<br><img src="\assets\img\research\Berlin_AirBnB\Berlin_price_map.png" alt="price map" style="width:720px"><br>
Image Source: <a href="https://www.mapsland.com/europe/germany/berlin/large-berlin-districts-map" target="_blank">modified after mapsland.com</a><br>

Figure summary:

All room types combined, the top four most expensive districts are Pankow, Marzahn-Hellersdorf, Mitte, and Charlottenburg-Wilmersdorf. Marzahn-Hellersdorf is neither a central tourist district "Mitte" nor adjacent, which is counterintuitive. However, the highest prices of Pankow are explained because on its southern end lies the hot neighborhood "Prenzlauer Berg", which is famous for art, night clubs, etc.  The districts Spandau, Neukölln, Reinickendorf, and Lichtenberg are the least expensive. These least expensive districts are on the outer most perimeter of Berlin and have relatively few tourist destinations.   

<br><img src="\assets\img\research\Berlin_AirBnB\price_range_type_district.png" alt="price by room type and district" style="width:720px">


Figure summary:

Generally, listings of the room type category *Hotel* (purple) are most expensive of the four types. The category *Entire homes/apt* (olive) are the most expensive among the non-commercial listings. *Private rooms* (red) are often 25 USD cheaper than Entire homes/apt. *Shared rooms* (green) are least expensive. The Hotel category has in many districts the largest range in prices, which may pull the total median of a district higher.

The median prices of *Private rooms* and *Shared rooms* do not decline in the same pattern as does entire *Home/apartments* but rather, is much more stable among districs. Generally speaking, within a listing category, there is no extreme variablility across districts.


### D. What is the difference in price between super host and non super host listings?

<br><img src="\assets\img\research\Berlin_AirBnB\Superhost_price_diff.png" alt="Superhost difference" style="width:7200px">

Figure summary:

Colored bars indicate the price difference between superhost and non superhost listings. *Entire homes/apartments* offered by superhosts are more expensive that those offered by non-superhosts in the majority of districts with the exception of Marzahn-Hellersdorf. The largest superhost price premium has to be paid for *Entire home/apt* in Spandau. The price difference is generally larger for *Entire home/apt* than *Private room*, while it is minimized in Pankow, Lichtenberg, and Charlottenburg-Wilmersdorf. 

Where are Superhosts chaper? 
- In Spandau, Lichtenberg, and Charlottenburg-Wilmersdorf, a superhost listing for a *Private room* is, on average, less expensive than that offered by a non-superhost.
- In Marzahn-Hellersdorf, superhost listings for *Entire home/apt* are on average cheaper.

None of these bargain-Superhost districts are located near Berlin's major tourist destinations in Mitte. This means it is probably a valid choice to pick a non-Superhost listing if a cheaper, central location is desired. Counterintuitively, superhosts do not charge a premium everywhere in Berlin. More remote districts are acceptable, then there may be savings possible with superhosts in few, select districts.


### E. Which website options influence the price?

In a user mindset -- which factor or option is going to be most influential on the price of listings that are displayed on the website?

<br><img src="\assets\img\research\Berlin_AirBnB\importance_plot.png" alt="importance plot" style="width:720px">

Figure Summary:

The Random Forest Regressor yielded the most important options driving price variability with a satisfactory model score of R<sup>2</sup> = 0.88. 

They factors are are in descending importance:

1. Month
2. Number of Persons ('accommodates')
3. Boutique Hotel
4. Number of Bathrooms
5. Hotel Room
6. Elevator (presence and absence are equally important)
7. Minimum Nights
8. Private Room in Apartment
9. Entire Apartment
10. District "Charlottenburg-Wilmersdorf"
11. Hotel
12. Beds
14. District "Mitte"

The month of booking is twice as important than the numer of people accommodated. Districts are not as influential as they are in other cities, such as Paris. As an investigation on the influence of the month I want to visualize the prices per listing type and month.

<br><img src="\assets\img\research\Berlin_AirBnB\price_range_type_month.png" alt="price by room type and month" style="width:720px">

Figure Summary:

*Private room* prices almost double in Spring and Summer (March to July) and are almost on par with the more expensive room types. *Entire home/apt* listings also increas during this month, but much less pronounced. *Hotel rooms* have a drop in prices in August, which may or may not be correlated that the data was scraped in August and short-term booking was discounted. *Shared rooms* show very little variance across the year.


## Analysis Summary

- *Entire home/apt* and *Private rooms* are overwhelmingly most abundant on AirBnB Berlin. *Hotel rooms* and *Shared rooms* (i.e. hostel-style) are NOT commonly advertised here. Other booking platforms may be better resources for these types of accommodations.
- The prices for *Hotel rooms* are the highest on AirBnB, followed by *Entire home/apt*, *Private rooms*, and finally *Shared rooms*.	
- Districts most expensive are Mitte and Pankow, which are very popular tourist destinations for sights and night life. Cheapest are remote districts, which was to be expected.
- In most districts, Superhosts will charge more than non-Superhosts. Superhosts of *Entire home/apts* require an even higher upcharge than than superhosts of *Private rooms*. Surprisingly, Superhosts of *Entire home/apts* in Spandau charge LESS than non-Superhosts.
- Monthly variations in price are more influential on price variability than location. For example, March to July *Private rooms* are almost as expensive as *Entire home/apts* or *Hotel rooms*, which would yiel a much better price/performance ratio.
- Ammenities driving price are Boutique hotel status and hotels in general, number of accommodated persons and number of beds, number of bathrooms and elevator availability.
	
I hope you found this helpful and please let me know if you are interested in learning about other aspects of Berlin's AirBnB data.


## Acknowledgements
Thanks to Elizabeth Herdter, from whose <a href="http://eherdtersmith.rbind.io/post/traveling-to-paris-france-how-to-get-the-biggest-bang-from-your-buck-using-airbnb/" target="_blank">Paris AirBnB Analysis</a> I took inspiration and decided to run my own analysis on Berlin. 
