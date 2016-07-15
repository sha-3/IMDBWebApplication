<%@ page import="com.nutanix.UDPMessageProtos" %>
<%@ page import="java.util.UUID" %>
<%@ page import="com.nutanix.Utils.MovieActionFactory" %>
<%@ page import="com.nutanix.Utils.MovieService" %>
<%@ page import="redis.clients.jedis.BinaryJedis" %>
<%@ page import="com.nutanix.MovieProtos" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%--
  Created by IntelliJ IDEA.
  User: akansha.deswal
  Date: 12/07/16
  Time: 4:14 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% UDPMessageProtos.Header.Builder header = UDPMessageProtos.Header.newBuilder();
    header.setOpcode(UDPMessageProtos.Header.Opcode.LISTALL);
    header.setMessageUUID(UUID.randomUUID().toString());
    header.build();
    List<MovieProtos.Movie> movieList = new ArrayList<>();
    MovieActionFactory movieActionFactory = new MovieActionFactory();
    MovieService movieService = movieActionFactory.getMovieOperationObject
            (header.getOpcode());

    UDPMessageProtos.ClientSideMessage.Builder clientMessage = UDPMessageProtos.ClientSideMessage.newBuilder();
    clientMessage.setMessageHeader(header);
    UDPMessageProtos.ServerSideMessage.Builder serverMessage = UDPMessageProtos.ServerSideMessage.newBuilder();
    serverMessage.setMessageHeader(header);
    BinaryJedis redisClient = new BinaryJedis("localhost");
    movieService.executeRequest(redisClient, clientMessage.build(), serverMessage);
    if (serverMessage.getIsRequestExecutedSuccessfully() && !serverMessage.getMovieList().isEmpty()) {
        movieList= serverMessage.getMovieList();
    }
%>
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
                    else if($(this).attr("value")=="4"){
                        $(".Movie").not(".update").hide();
                        $(".update").show();
                        $(".add").show();
                        $(this).attr("value").set("0");
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
<h1>IMDB</h1>
<h2>Movie Encyclopedia</h2>
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
            <%if(request.getParameter("selectedMovieToUpdate")!=null) {
                int i = Integer.parseInt(request.getParameter("selectedMovieToUpdate")); %>
                <input type="" name="movieName" value=<%=movieList.get(i).getName()%>>
                <input type="date" name="dateOfRelease" value=<%=movieList.get(i).getDateOfRelease()%>>
                <input type="text" name="durationInMinutes" value=<%=movieList.get(i).getDurationInMinutes()%>>
                <input type="text" name="actor" value=<%=movieList.get(i).getActors(0)%>>
                <input type="text" name="director" value=<%=movieList.get(i).getDirectors(0)%>>
                <select name="Genre">
                    <option value="0">ADVENTURE</option>
                    <option value="1">SCI_FI</option>
                    <option value="2">DRAMA</option>
                    <option value="3">COMEDY</option>
                    <option value="4">ROMANCE</option>
                    <option value="5">MUSICAL</option>
                </select>
                <% } else {%>
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
           <% }%>

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
<form action="/index.jsp" method="post">
<div class="update Movie" style="display: none;">
    <select name="selectedMovieToUpdate" id="selectedMovieToUpdate" onchange="this.form.submit()">
        <%for (int i=0;i<movieList.size();i++) {%>
        <option value=<%=i%>><%=movieList.get(i).getName()%></option>
        <% }%>
    </select>
</div>
</form>
</body>
</html>

