<!DOCTYPE html>
<html lang="en">
<%@page import="java.util.List" %>
<%@page import="com.transport.travelbookingsystem.models.TravelPlans" %>

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

<div class="currentplans">
    <h2>Current Plans</h2>
    <% TravelPlans currentPlan=(TravelPlans) request.getAttribute("currentPlan"); if (currentPlan !=null) { %>
    <div class="plan">
        <div class="planimg">
            <img src="/images/<%=currentPlan.getDestination()%>.jpg" alt="">
        </div>
        <div class="plandetails">
            <div class="field">
                <span class="label">Trip Id:</span>
                <span class="value">
                                    <%= currentPlan.getId() %>
                                </span>
            </div>

            <div class="field">
                <span class="label">Destination:</span>
                <span class="value">
                                    <%= currentPlan.getDestination() %>
                                </span>
            </div>
            <form action="/travel/plans/<%=currentPlan.getId()%>" method="get">
                <button type="submit">View</button>
            </form>
        </div>

    </div>
    <% } else { %>
    <p>No Current plans found.</p>
    <% } %>
</div>

<div class="previousplan">
    <h2>Previous Plans</h2>
    <% List<TravelPlans> previousPlans = (List<TravelPlans>) request.getAttribute("previousPlans");
        if (previousPlans != null && !previousPlans.isEmpty()) {
            for (TravelPlans plan : previousPlans) {
    %>
    <div class="plan">
        <div class="planimg">
            <img src="/images/<%=plan.getDestination()%>.jpg" alt="">
        </div>
        <div class="plandetails">
            <div class="field">
                <span class="label">Trip Id:</span>
                <span class="value">
                                            <%= plan.getId() %>
                                        </span>
            </div>

            <div class="field">
                <span class="label">Destination:</span>
                <span class="value">
                                            <%= plan.getDestination() %>
                                        </span>
            </div>
            <form action="/travel/plans/<%=plan.getId()%>" method="get">
                <button type="submit">View</button>
            </form>
        </div>
    </div>
    <% } } else { %>
    <p>No previous plans found.</p>
    <% } %>
</div>

</body>

</html>
