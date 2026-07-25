<%
    // Redirect entry point
    if (session.getAttribute("user") != null) {
        response.sendRedirect(request.getContextPath() + "/dashboard");
    } else {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
    }
%>
