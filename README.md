# SplitMate

SplitMate is a simple iPhone app for splitting grocery bills between housemates.

The main idea is that not every item in a grocery bill is shared by everyone. The user can add the people involved, enter the grocery items, choose who shared each item, and then see how much each person has to pay.

## How the app works

The app has five main screens.

1. **Housemates**  
   Add the people who are part of the bill.

2. **Receipt Entry**  
   Enter the grocery item name, price and quantity.

3. **Assign Items**  
   Choose which people shared each item.

4. **Review Split**  
   Check the items and the calculated split before confirming.

5. **Final Amounts**  
   See the final amount each person needs to pay.

The app starts with no default housemate names, so the user adds the housemates involved in the bill.

## Project structure

I separated the project into different folders so the code is easier to understand and manage.

### Models

`Person.swift` stores information about a housemate.

`GroceryItem.swift` stores information about a grocery item such as the name, price, quantity and the people assigned to it.

### Data

`SplitMateStore.swift` keeps the data used by the app.

It handles things like:

- adding people
- adding grocery items
- assigning people to items
- calculating each person's share
- calculating the total bill
- resetting the bill

The app currently only keeps the data while it is running.

### Screens

The five screens are:

- `PeopleSelectionView.swift`
- `ItemEntryView.swift`
- `AssignItemsView.swift`
- `ReviewSplitView.swift`
- `FinalAmountView.swift`

`ContentView.swift` handles the navigation between these screens.

### Reusable views

I created reusable views instead of repeating the same UI code on different screens.

Some of these are:

- `PersonAvatar`
- `MiniPersonAvatar`
- `PrimaryButton`
- `SecondaryButton`
- `ScreenHeader`
- `ProgressIndicator`
- `SplitSegments`

I also use `SplitMateTheme.swift` to keep the main colours and styling in one place.

## Custom Layout

I created `FlowLayout` using SwiftUI's `Layout` protocol.

I needed this because the number of housemates can change and the names can also have different lengths. If all the people were placed inside a normal `HStack`, they could go outside the screen when there are too many.

I considered using `LazyVGrid`, but that would place the views into fixed columns. For this app I wanted the housemate controls to use their own width and move to the next row only when they run out of space.

`FlowLayout` checks the available width and places as many views as possible on one row. If the next view does not fit, it starts a new row.

It takes more code than using a normal stack, but it works better for this part of the interface and can also be reused.

## Splitting the money

The app calculates the final split using cents.

For example, if an item costs $18.75 and four people share it, the split cannot be exactly the same to two decimal places.

The app splits it as:

- $4.69
- $4.69
- $4.69
- $4.68

This means the final amounts still add up to exactly $18.75.

## Responsive design

I used SwiftUI layout views and scrolling so the screens can work on different iPhone sizes.

The custom `FlowLayout` also helps when there are more housemates or longer names because the controls can move onto another row instead of going outside the screen.

## If the app became bigger

At the moment, `SplitMateStore` keeps the app state and handles the calculations because the project does not use a database or networking.

If I added features like saving old bills or sharing bills online, I would separate the data access from `SplitMateStore`.

I would probably create a repository layer, for example a `SplitRepository`.

The repository could handle saving and loading people, grocery items and completed bills. A local version could use SwiftData, while another version could get data from an API.

Another option would be to put the database and networking code directly inside `SplitMateStore`.

That would be simpler at first, but the store would eventually be responsible for too many things, including app state, calculations, storage and networking.

I think using a repository would make the project easier to maintain because the data code would stay separate from the UI state. It would also make testing easier because I could use a test repository instead of needing a real database or internet connection.

## Running the app

1. Open the project in Xcode.
2. Choose an iPhone simulator.
3. Build and run the app.
4. Add at least two housemates.
5. Add grocery items.
6. Assign the items to the people who shared them.
7. Review the split.
8. Confirm to see the final amounts.

## AI Use

I used ChatGPT as a reference during Part B to clarify SwiftUI concepts and troubleshoot issues.

I reviewed and tested the final implementation in Xcode.
