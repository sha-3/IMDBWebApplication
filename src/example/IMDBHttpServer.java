package example;

import java.io.IOException;
import com.nutanix.UDPMessageProtos;
import com.nutanix.UDPMessageProtos.Header;
import com.nutanix.UDPMessageProtos.ClientSideMessage;
import com.nutanix.Utils.MovieActionFactory;
import com.nutanix.Utils.MovieService;
import redis.clients.jedis.BinaryJedis;
import com.nutanix.UDPMessageProtos.ServerSideMessage;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletException;
import com.nutanix.MovieProtos.Movie;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;


/**
 * Created by akansha.deswal on 12/07/16.
 */
public class IMDBHttpServer extends javax.servlet.http.HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int selectedAction = Integer.parseInt(request.getParameter("IMDBAction"));
        Header.Builder header = Header.newBuilder();
        header.setOpcode(UDPMessageProtos.Header.Opcode.values()[selectedAction]);
        header.setMessageUUID("gh");
        header.build();

        MovieActionFactory movieActionFactory = new MovieActionFactory();
        MovieService movieService = movieActionFactory.getMovieOperationObject
                (header.getOpcode());

        ClientSideMessage.Builder clientMessage = ClientSideMessage.newBuilder();
        clientMessage.setMessageHeader(header);
        ServerSideMessage.Builder serverMessage = ServerSideMessage.newBuilder();
        serverMessage.setMessageHeader(header);
        BinaryJedis redisClient = new BinaryJedis("localhost");
        switch(header.getOpcode()) {
            case ADD:
                takeInputAddMovie(clientMessage, request);
                break;
            case DELETE:
                takeInputDeleteMovie(clientMessage, request);
                break;
            case UPDATE:
                takeInputUpdateMovie(clientMessage, request);
                break;
            case FIND:
                takeInputFindMovie(clientMessage, request);
                break;
        }

        movieService.executeRequest(redisClient, clientMessage.build(), serverMessage);
        request.setAttribute("Output",serverMessage.build());
        getServletContext().getRequestDispatcher("/output.jsp").forward(request,response);
    }

    protected void doGet(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response) throws javax.servlet.ServletException, IOException {
        doPost(request,response);
    }

    private void takeInputAddMovie(ClientSideMessage.Builder clientMessage,HttpServletRequest request) {
        Movie.Builder newMovie = Movie.newBuilder();
        newMovie.setName(request.getParameter("movieName"));

        newMovie.setDurationInMinutes(Integer.parseInt(request.getParameter("durationInMinutes")));
        newMovie.addActors(request.getParameter("actor"));
        newMovie.addDirectors(request.getParameter("director"));

        String dateOfRelease = request.getParameter("dateOfRelease");
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        try {
        Date dateOfR = sdf.parse(dateOfRelease);
            Movie.Date.Builder date = Movie.Date.newBuilder();

            date.setYear(dateOfR.getYear());
            date.setMonth(Movie.Month.values()[dateOfR.getMonth()]);
            date.setDay(dateOfR.getDay());

            newMovie.setDateOfRelease(date.build());
        } catch(ParseException ex) {

        }
        clientMessage.setMovie(newMovie.build());
    }
    private void takeInputDeleteMovie(ClientSideMessage.Builder clientMessage,HttpServletRequest request) {
        clientMessage.setMovieToBeDeleted(request.getParameter("DeleteText"));
    }
    private void takeInputFindMovie(ClientSideMessage.Builder clientMessage,HttpServletRequest request) {

    }
    private void takeInputUpdateMovie(ClientSideMessage.Builder clientMessage,HttpServletRequest request) {

    }
}

