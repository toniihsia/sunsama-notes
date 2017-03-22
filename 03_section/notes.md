### React, HTML, and CSS
**Questions for Ashutosh**
* Is the `calendars` a top-level field for `main_db.users`?
* ![Filter Panel Design Question](https://s3-us-west-1.amazonaws.com/sunsama-hiring/front-end-design-description.png)
* Figure 1 shows 2 sub-calendars while Figure 2 shows 4 sub-calendars. Wonderig whether there are some calendars that shouldn't be counted or whether they are just two different screenshots.
* 'Need to add info/hint about where to start in the code base'
* Is the entire user doc being pulled up per teammate?

### General Approach
- Iterate through `calendar.items`.
- Two branches of thought:
  - Store all sub-calendars in the front-end and toggle using CSS (stateless approach).
    - Would require making HTML elements for every single sub-calendar which can become expensive if there are many users with many sub-calendars b/c have to wait to load all elements.
  - Create an on-click/handle-click function that creates the DOM element when needed (state approach).
    - Jeremiah Grant on-click event handler triggers re-render with sub-calendars for him.
    - __Question about what is being passed up e.g. the entire user doc or just partial? May have to change JSON. Ask Ashutosh.__
