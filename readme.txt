MLB Highlights is a iOS app for iPad that allows users to see random MLB Highlights by year, month, day and team. Starting from 2010 to 2017 and from April to November.

After the highlight users will have the option to save or not the highlight to their favorite list.

If there's no highlight available for a particular day the app will display the selected team's final score and logo and the opponent on that particular day along with the final score.  This feature is only available when selecting a team on a American League (AL) or National League (NL).

If the selected team didn't play that day the app will let the user know that there's no highlights. 

If selecting ALL the app will choose random highlights and random teams without displaying the final score or teams logo. This is because the request is to get all the media available on selected date.

If selecting Favorite the app will display a table view with the saved highlights. With a image of the team if the team's name is provided by the API if not the MLB logo will display instead. The player's name if it is provided by the API if not a title "Highlight Headline". The headline is always provided by the API and is on the right side.

Selecting a table will display the highlight corresponding to that index row.

After the highlight an alert will display to ask the user to keep or delete the recent viewed highlight and if deleted it will remove the highlight from the list and core data. This option is not available if the user do not press the X button  on the media player to dismiss the video before it finished.  In other words users must finish watching the selected highlight until the end for the delete option.

This app uses MLBAM API http://gd2.mlb.com/components/game/mlb to fetch for the information and highlights urls.

Some of the data are JSON and other are XML so I use a SWXMLHash library to parse the XML.

Here is a short video of the app:  https://youtu.be/OLy_dJSDgAc ==> Video is the TVOS version but it is the same behavior as an iPad.

The app also checks for duplicate highlights before saving it to favorite.

NOTE: The app instead of display an alert when request returned a status code other than 2xx!, it will display teams final scores and logo if they play or image "There is no game".

Alert is display if there's no internet connection during the request to notify user to check their connection.

To go back before the highlight ends press X button and users won't have an option to save.

After a highlight users can keep pressing the button for more random highlight without changing parameters of selected date or team.



  