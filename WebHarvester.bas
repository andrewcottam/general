Attribute VB_Name = "WebHarvester"
Const USER = "krasi"
Function getStartPos(searchText, searchTerm) As Integer
startpos = InStr(1, searchText, searchTerm)
If startpos > 0 Then
    startpos = startpos + Len(searchTerm)
End If
getStartPos = startpos
End Function
Function getEndPos(searchText, startpos, searchTerm) As Integer
endpos = InStr(startpos, searchText, searchTerm)
getEndPos = endpos
End Function

Function cleanText(sInput) As String
 Dim RegEx As Object
 Set RegEx = CreateObject("vbscript.regexp")
 Dim sOut As String
 With RegEx
   .Global = True
   .IgnoreCase = True
   .MultiLine = True
.Pattern = "<[^>]*>" 'Regular Expression for HTML Tags.
 End With
 sOut = Trim(RegEx.Replace(sInput, ""))
 sOut = Replace(sOut, "  ", "")
 sOut = Replace(sOut, vbTab, "")
 sOut = Replace(sOut, vbCr, "")
 sOut = Replace(sOut, vbCrLf, "")
 sOut = Replace(sOut, vbLf, "")
 sOut = Replace(sOut, vbNewLine, "")
 sOut = Replace(sOut, "&nbsp;", "")
 sOut = Replace(sOut, "&euro;", "€")
 cleanText = sOut
 Set RegEx = Nothing
End Function

Sub AddInfo(projectid)
Dim oRequest As Object
Dim url As String
Set oRequest = CreateObject("WinHttp.WinHttpRequest.5.1")
url = "http://ec.europa.eu/environment/life/project/Projects/index.cfm?fuseaction=search.dspPage&n_proj_id=" + Str(projectid)
oRequest.Open "GET", url
oRequest.setProxy 2, "http://10.168.209.72:8012", "" 'use the JRC proxy
oRequest.Send
response = oRequest.ResponseText
'background
Const TEXT_TITLE As String = "<td class=""tdtitle"" colspan=""2"">"
Const TEXT_BACKGROUND As String = "Background</span><br><br>"
Const TEXT_OBJECTIVES As String = "Objectives</span><br><br>"
Const TEXT_N2KSITES As String = "Natura 2000 sites</span><br><br>"
Const TEXT_COORDINATOR As String = "Coordinator</span></td>"
Const TEXT_REFERENCE As String = "Project reference</span></td>"
Const TEXT_BUDGET As String = "Total budget</span></td>"
Const TEXT_DURATION As String = "Duration</span></td>"
Const TEXT_LOCATION As String = "Project location</span></td>"
'get the start positions of the text
start00 = getStartPos(response, TEXT_TITLE)
start01 = getStartPos(response, TEXT_BACKGROUND)
start02 = getStartPos(response, TEXT_OBJECTIVES)
start03 = getStartPos(response, TEXT_N2KSITES)
start04 = getStartPos(response, TEXT_COORDINATOR)
start05 = getStartPos(response, TEXT_REFERENCE)
start06 = getStartPos(response, TEXT_BUDGET)
start07 = getStartPos(response, TEXT_DURATION)
start08 = getStartPos(response, TEXT_LOCATION)
'get the end positions of the text
end00 = getEndPos(response, start00, "<br>")
end01 = getEndPos(response, start01, "<br>")
end02 = getEndPos(response, start02, "<br>")
end03 = getEndPos(response, start03, "<br>")
end04 = getEndPos(response, start04, "</tr>")
end05 = getEndPos(response, start05, "</tr>")
end06 = getEndPos(response, start06, "</tr>")
end07 = getEndPos(response, start07, "</tr>")
end08 = getEndPos(response, start08, "</tr>")
'get the duration start and end
d = Mid(response, start07, end07 - start07) 'duration
start_start = getStartPos(d, ">")
start_stop = InStr(start_start, d, "&nbsp;")
duration_start = Mid(d, start_start, start_stop - start_start)
end_start = InStr(start_stop + 1, d, "&nbsp;") + 6
end_stop = InStr(end_start, d, "</td>")
duration_end = Mid(d, end_start, end_stop - end_start)
'set the text
Cells(ActiveCell.Row, 2) = cleanText(Mid(response, start00, end00 - start00)) 'b title
Cells(ActiveCell.Row, 3) = cleanText(Mid(response, start01, end01 - start01)) 'c background
'Cells(ActiveCell.Row, 5) = cleanText(Mid(response, start02, end02 - start02)) 'd objectives
Cells(ActiveCell.Row, 5) = cleanText(Mid(response, start03, end03 - start03)) 'e n2ksites
Cells(ActiveCell.Row, 6) = cleanText(Mid(response, start04, end04 - start04)) 'f coordinator
Cells(ActiveCell.Row, 7) = cleanText(Mid(response, start05, end05 - start05)) 'g reference
Cells(ActiveCell.Row, 8) = cleanText(Mid(response, start06, end06 - start06)) 'h budget
Cells(ActiveCell.Row, 9) = duration_start 'i
Cells(ActiveCell.Row, 10) = duration_end   'j
Cells(ActiveCell.Row, 11) = cleanText(Mid(response, start08, end08 - start08)) 'k budget
Set oRequest = Nothing
End Sub

Sub IterateThroughRows()
searchText = ActiveCell.Value
While ActiveCell.Value <> ""
    AddInfo ActiveCell.Value
    ActiveCell.Offset(rowOffset:=1, columnOffset:=0).Activate
Wend
End Sub

