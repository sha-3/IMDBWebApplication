<%--
  Created by IntelliJ IDEA.
  User: akansha.deswal
  Date: 12/07/16
  Time: 4:14 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<head>
    <title>IMDB</title>
    <script type="text/javascript" src="http://code.jquery.com/jquery.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function(){
            $("#IMDBAction").change(function(){
                $(this).find("option:selected").each(function(){
                    if($(this).attr("value")=="0"){
                        $(".Movie").not(".add").hide();
                        $(".add").show();
                    }
                    else if($(this).attr("value")=="1"){
                        $(".Movie").not(".delete").hide();
                        $(".delete").show();
                    }
                    else if($(this).attr("value")=="2"){
                        $(".Movie").not(".search").hide();
                        $(".search").show();
                    }
                    else{
                        $(".Movie").hide();
                    }
                });
            }).change();
        });
        </script>
</head>
<link rel="stylesheet" type="text/css" href="IMDBStyleSheet.css">
<body>
    <form action="/IMDB" method="post">
        <select name="IMDBAction"  id = "IMDBAction">
            <option value="0">Add Movie</option>
            <option value="1">Delete Movie</option>
            <option value="2">Search Movie</option>
            <option value="3">List All Movies</option>
            <option value="4">Update Movie</option>
        </select>
        <br><br>
        <div class="delete Movie" style="display: none;">
            <label>Name of movie you wish to delete</label>
            <input type="text" name="DeleteText" placeholder="MovieName"/>
        </div>
        <div class="add Movie" style="display: none;">
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
        <div class="search Movie" style="display: none;">
            <select name="searchValue">
                <option value="1">Actor</option>
                <option value="2">Director</option>
                <option value="0">Genre</option>
                <option value="3">Movie</option>
            </select>
            <input type="text" name="searchPhrase" placeholder="searchForPhrase"/>
        </div>
        <br><br>
        <input type="submit" value="SUBMIT">
    </form>
</body>
</html>

