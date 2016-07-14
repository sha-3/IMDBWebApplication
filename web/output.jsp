<%--
  Created by IntelliJ IDEA.
  User: akansha.deswal
  Date: 14/07/16
  Time: 10:09 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="com.nutanix.UDPMessageProtos.ServerSideMessage"%>
<%@ page import="com.nutanix.UDPMessageProtos" %>
<%
    ServerSideMessage reponseFromServer = (ServerSideMessage) request.getAttribute("Output");
    UDPMessageProtos.Header.Opcode headerOpcode = reponseFromServer.getMessageHeader().getOpcode();
%>
<html>
<head>
    <title>Output</title>
</head>
<body>
<% if (!reponseFromServer.getIsRequestExecutedSuccessfully()) {%>
<div id="result">Error executing your request</div>
<% } else {%>
<div id="result">Your request was executed successfully</div>
<%if(headerOpcode.equals(UDPMessageProtos.Header.Opcode.LISTALL)
        || headerOpcode.equals(UDPMessageProtos.Header.Opcode.FIND)) {%>
<%=reponseFromServer.getMovieList()%>
<%}}%>
</body>
</html>
