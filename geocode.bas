Const USER = "krasi"
'SET THE FOLLOWING FOR THE POSITION OF THE RELEVANT COLUMNS
Const LATCOL = 3
Const LNGCOL = 4
Const CNTCOL = 6

Sub Geocode(searchText)
Dim oRequest As Object
Dim url As String
Set oRequest = CreateObject("WinHttp.WinHttpRequest.5.1")
url = "http://api.geonames.org/search?q=" & searchText & "&username=" & USER
oRequest.Open "GET", url
oRequest.setProxy 2, "http://10.168.209.72:8012", "" 'use the JRC proxy
oRequest.Send
'check we have a valid response otherwise we are over our usage limit
response = oRequest.ResponseText
StarttotalResultsCount = InStr(1, response, "<totalResultsCount>")
If StarttotalResultsCount = 0 Then
    MsgBox "The hourly limit of 2000 credits for " & USER & " has been exceeded. Please throttle your requests or use the commercial service."
    Exit Sub
End If
endtotalResultsCount = InStr(1, response, "</totalResultsCount>")
totalResultsCount = Mid(response, StarttotalResultsCount + 19, (endtotalResultsCount - (StarttotalResultsCount + 19)))
'check we have some results
If totalResultsCount = 0 Then
    Exit Sub
End If
startLat = InStr(1, response, "<lat>")
endLat = InStr(1, response, "</lat>")
If startLat > 0 Then
    'get the latitude
    lat = Mid(response, startLat + 5, (endLat - (startLat + 5)))
    startlng = InStr(1, response, "<lng>")
    endlng = InStr(1, response, "</lng>")
    If startlng > 0 Then
        'get the longitude
        lng = Mid(response, startlng + 5, (endlng - (startlng + 5)))
        'get the country code
        StartcountryCode = InStr(1, response, "<countryCode>")
        endcountryCode = InStr(1, response, "</countryCode>")
        countryCode = Mid(response, StartcountryCode + 13, (endcountryCode - (StartcountryCode + 13)))
        Cells(ActiveCell.Row, LATCOL) = lat
        Cells(ActiveCell.Row, LNGCOL) = lng
        Cells(ActiveCell.Row, CNTCOL) = countryCode
    End If
End If
End Sub

Sub IterateThroughRows()
searchText = ActiveCell.Value
While ActiveCell.Value <> ""
    Geocode ActiveCell.Value
    ActiveCell.Offset(rowOffset:=1, columnOffset:=0).Activate
Wend
End Sub
