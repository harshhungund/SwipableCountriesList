# SwipableCountriesList

Architecture used is MVVM.

CountriesViewModel is the VM layer handling data and populating the table.

Networking is handled by a set ofreusable classes - NetworkManager, Router, EndpointType etc.

Parsing is done is CountriesDataParser.

CountryCellTableViewCell.swift is where the all the animation and translation upon user swipe are being handled:
- handlePan and handleTap capture user interaction on the cell.
- based on the speed and extent of swiping, the newframe is calculated which tells the action view to be hidden or shown using calculateSwipeDestinationFrame and  swipingRange functions.
- updateOpenModeAfterSwipe decides if the row needs to be deleted, the delete icon needs to be shown or hidden.
- translateContentViewToX is responsible for movement of contentview across the cell. 
- deleteCountry causes swiped row to be deleted from table and the viewmodel.
- to cancel current swipe if any other cell is tapped/swiped, notification with title "Another Cell Tapped" is fired.

