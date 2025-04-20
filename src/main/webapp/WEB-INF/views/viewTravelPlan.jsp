<!DOCTYPE html>
<html lang="en">
<%@page import="com.transport.travelbookingsystem.models.TravelPlans" %>
    <%@page import="com.transport.travelbookingsystem.models.TransportSchedules" %>

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Plans</title>
            <link rel="stylesheet" href="/css/bookingplanstyle.css">
        </head>

        <body>
            <div class="container">
                <div class="usernavbar">
                    <div class="navbar-brand">TravelMate</div>
                    <ul class="navbar-links">
                        <li><a href="/user/profile">Dashboard</a></li>
                        <li><a href="#packages">Booking Packages</a></li>
                        <li><a href="#gallery">TravelMate Gallery</a></li>
                        <li><a href="/travel/plans">Your Plans</a></li>
                        <li><a href="/travel/create">Booking form</a></li>
                    </ul>
                    <div class="navbar-account">
                        <form action="/logout" method="post">
                            <button type="submit">Logout</button>
                        </form>

                    </div>
                </div>
            </div>

            <div class="travelPlans">
                <h2>Travel Plan</h2>
                <% TravelPlans travelPlan=(TravelPlans) request.getAttribute("travelPlan"); if (travelPlan !=null) { %>
                    <div class="plan">
                        <div class="planimg">
                            <img src="/images/<%=travelPlan.getDestination()%>.jpg" alt="">
                        </div>
                        <div class="plandetails">
                            <div class="field">
                                <span class="label">Trip Id:</span>
                                <span class="value">
                                    <%= travelPlan.getId() %>
                                </span>
                            </div>

                            <div class="field">
                                <span class="label">Destination:</span>
                                <span class="value">
                                    <%= travelPlan.getDestination() %>
                                </span>
                            </div>
                            <% TransportSchedules mediumOfTravel=(TransportSchedules)
                                request.getAttribute("mediumOfTravel"); if (mediumOfTravel !=null) { %>
                                <div class="field">
                                    <span class="label">Medium of Transport:</span>
                                    <span class="value">
                                        <%= mediumOfTravel.getMedium() %>
                                    </span>
                                </div>

                                <div class="field">
                                    <span class="label">Source and Destination:</span>
                                    <span class="value">
                                        <%= mediumOfTravel.getSource()%> | <%= mediumOfTravel.getDestination() %>
                                    </span>
                                </div>

                                <div class="field">
                                    <span class="label">Departure time</span>
                                    <span class="value">
                                        <%= mediumOfTravel.getDepartureTime()%>
                                    </span>
                                </div>

                                <div class="field">
                                    <span class="label">Arrival time:</span>
                                    <span class="value">
                                        <%= mediumOfTravel.getArrivalTime() %>
                                    </span>
                                </div>
                                <% } %>
                                    <div class="field">
                                        <span class="label">Co-passenger details:</span>
                                        <span class="value">none</span>
                                    </div>
                        </div>

                    </div>
                    <% } else { %>
                        <p>No Current plans found.</p>
                        <% } %>
            </div>

        </body>

</html>