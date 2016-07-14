<%--
  Created by IntelliJ IDEA.
  User: akansha.deswal
  Date: 12/07/16
  Time: 4:14 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String listOfMovies = (String) request.getAttribute("listOfMovie");%>
<html>
<head>
    <title>IMDB</title>
    <script>

        function showApprioriateDiv(elem){
            if(elem.value == "0")
                document.getElementById('addMovie').style.display = "block";
            if(elem.value == "2")
                document.getElementById('search').style.display = "block";
            if(elem.value == "1")
                document.getElementById('delete').style.display = "block";
        }
    </script>
</head>
<body>
<form action="/IMDB" method="post">
    <select name="IMDBAction" onchange="showApprioriateDiv(this)">
        <option value="0">Add Movie</option>
        <option value="1">Delete Movie</option>
        <option value="2">Search Movie</option>
        <option value="3">List All Movies</option>
        <option value="4">Update Movie</option>
    </select>
    <div id="delete" style="display: none;">
        <label>Name of movie you wish to delete</label>
        <input type="text" name="DeleteText" placeholder="MovieName"/>
    </div>
    <div id="addMovie" style="display: none;">
        <input type="text" name="movieName" placeholder="MovieName"/>
        <input type="date" name="dateOfRelease" placeholder="Date Of Release"/>
        <input type="text" name="durationInMinutes" placeholder="Duration (mins)"/>
        <input type="text" name="actor" placeholder="Actor"/>
        <input type="text" name="director" placeholder="Director"/>
        <select name="Genre">
            <option value="0">ADVENTURE</option>
            <option value="1">SCI_FI</option>
            <option value="2">DRAMA</option>
            <option value="3">COMEDY</option>
            <option value="4">ROMANCE</option>
            <option value="5">MUSICAL</option>
        </select>
    </div>
    <div id="search" style="display: none;">
        <select name="searchValue">
            <option value="0">Actor</option>
            <option value="1">Director</option>
            <option value="2">Genre</option>
            <option value="3">Movie</option>
        </select>
    </div>
    <input type="submit" value="submit">
</form>
</body>
</html>

