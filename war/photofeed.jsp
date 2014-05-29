<%@ page contentType="text/html;charset=UTF-8" language="java"
  isELIgnored="false"%>

<%@ page import="java.util.ArrayList"%>
<%@ page import="com.google.cloud.demo.*"%>
<%@ page import="com.google.cloud.demo.model.*"%>
<%@ page import="com.google.appengine.api.users.*"%>
<%@ page import="com.google.appengine.api.datastore.DatastoreNeedIndexException"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
  UserService userService = UserServiceFactory.getUserService();
  AppContext appContext = AppContext.getAppContext();
  ConfigManager configManager = appContext.getConfigManager();
  DemoUser currentUser = appContext.getCurrentUser();
  PhotoServiceManager serviceManager = appContext.getPhotoServiceManager();
  PhotoManager photoManager = appContext.getPhotoManager();
  RestaurantManager restaurantManager = appContext.getRestaurantManager();
  CommentManager commentManager = appContext.getCommentManager();
%>
<!DOCTYPE html>

<head>
<script type="text/javascript">
function onFileSelected() {
  filename = document.getElementById("input-file").value;
  if (filename == null || filename == "") {
    document.getElementById("btn-post").setAttribute("class", "inactive btn");
    document.getElementById("btn-post").disabled = true;
  } else {
    document.getElementById("btn-post").setAttribute("class", "active btn");
    document.getElementById("btn-post").disabled = false;
  }
}

function togglePhotoPost(expanded) {
  onFileSelected();
  if (expanded) {
    document.getElementById("btn-choose-image").style.display="none";
    document.getElementById("upload-form").style.display="block";
  } else {
    document.getElementById("btn-choose-image").style.display="inline-block";
    document.getElementById("upload-form").style.display="none";
  }
}

function onCommentChanged(id) {
  comment = document.getElementById("comment-input-" + id).value;
  if (comment == null || comment.trim() == "") {
    document.getElementById("comment-submit-" + id).setAttribute("class", "inactive btn");
    document.getElementById("comment-submit-" + id).disabled = true;
  } else {
    document.getElementById("comment-submit-" + id).setAttribute("class", "active btn");
    document.getElementById("comment-submit-" + id).disabled = false;
  }
}

function toggleCommentPost(id, expanded) {
  onCommentChanged(id);
  if (expanded) {
    document.getElementById("comment-input-" + id).setAttribute("class", "post-comment expanded");
    document.getElementById("comment-submit-" + id).style.display="inline-block";
    document.getElementById("comment-cancel-" + id).style.display="inline-block";
  } else {
    document.getElementById("comment-input-" + id).value = ""
    document.getElementById("comment-input-" + id).setAttribute("class", "post-comment collapsed");
    document.getElementById("comment-submit-" + id).style.display="none";
    document.getElementById("comment-cancel-" + id).style.display="none";
  }
}
</script>
<title>mjamstagram!</title>
<link rel="stylesheet" type="text/css" href="photofeed.css" />
</head>

<body>
  <div class="wrap">

    <div class="header group">
      <h1>
        <!--<img src="img/photofeed.png" alt="Photofeed" />-->
	mjamstagram!
      </h1>
      <div class="glow"></div>
    </div>

    <%
    if (currentUser != null) {
    	%>
	    <div id="upload-wrap">
	      <div id="upload">
	        <div class="account group">
	          <div id="account-name">
	            <h2><%= ServletUtils.getProtectedUserNickname(currentUser.getNickname()) %></h2>
	            <p>You are ready to upload photos of your food!
	              | <a
	                href=<%= userService.createLogoutURL(configManager.getMainPageUrl())%>>Sign
	                out</a>
	            </p>
	          </div>
	          <!-- /#account-name -->
	        </div>
	        <!-- /.account -->
	        <a id="btn-choose-image" class="active btn" onclick="togglePhotoPost(true)">Choose a photo</a>
	        <div id="upload-form" style="display:none">
	          <form action="<%= serviceManager.getUploadUrl() %>" method="post"
	            enctype="multipart/form-data">
	            <input id="input-file" class="inactive file btn" type="file" name="photo"
	              onchange="onFileSelected()">
	            <input type="text" name="url" placeholder="link to the restaurant where you ordered"></input>
	            <input type="text" name="food" placeholder="What food is shown on the photo you want to upload?"></input>
	            <br />
	            <input id="btn-post" class="active btn" type="submit" value="Post">
	            <a class="cancel" onclick="togglePhotoPost(false)">Cancel</a>
	          </form>
	        </div>
	      </div>
	      <!-- /#upload -->
	    </div>
	    <!-- /#upload-wrap -->
	    <%
    } else {
    	%>
    	<div id="upload-wrap">
	      <div id="upload">
	        <div class="account group">
	          <div id="account-name">
	            <h2>anonymous user</h2>
	            <p>In order to upload a photo of your food, please sign in below:
	            </p>
	          </div>
	          <!-- /#account-name -->
	        </div>
	        <!-- /.account -->
	        <a id="btn-choose-image" class="active btn" href=<%= userService.createLoginURL(configManager.getMainPageUrl())%>>Sign In!</a>
	      </div>
	      <!-- /#upload -->
	    </div>
	    <!-- /#upload-wrap -->
    	<%
    }
    %>

    <!-- KK -->
    <%
      Iterable<Photo> photoIter = photoManager.getActivePhotos();
      ArrayList<Photo> photos = new ArrayList<Photo>();
      try {
        for (Photo photo : photoIter) {
          photos.add(photo);
        }
      } catch (DatastoreNeedIndexException e) {
        pageContext.forward(configManager.getErrorPageUrl(
          ConfigManager.ERROR_CODE_DATASTORE_INDEX_NOT_READY));
      }

      int count = 0;
      for (Photo photo : photos) {
    	  Restaurant restaurant = restaurantManager.getRestaurant(photo.getRestaurantId());
    	  
        String firstClass = "";
        String lastClass = "";
        if (count == 0) {
          firstClass = "first";
        }
        if (count == photos.size() - 1) {
          lastClass = "last";
        }
    %>
    <div class="feed <%= firstClass %> <%= lastClass %>">
      <div class="post group">
        <div class="image-wrap">
          <img class="photo-image"
            src="<%= serviceManager.getImageDownloadUrl(photo) %>"
            alt="Photo Image" />
        </div>
        <div class="owner group">
          <div class="desc">
            <h3><%= ServletUtils.getProtectedUserNickname(photo.getOwnerNickname()) %></h3>
            <p>
            	<c:out value="<%= photo.getFood() %>" escapeXml="true"/>
            	//
            	<a href="<%= restaurant.getUrl() %>"><%= restaurant.getName() %></a>
            </p>
            <p class="timestamp"><%= ServletUtils.formatTimestamp(photo.getUploadTime()) %></p>
          </div>
          <!-- /.desc -->
        </div>
        <!-- /.usr -->
      </div>
      <!-- /.post -->
      <%
        Iterable<Comment> comments = commentManager.getComments(photo);
        for (Comment comment : comments) {
    %>
      <div class="post group">
        <div class="usr">
          <div class="comment">
          	<h3><%= ServletUtils.getProtectedUserNickname(comment.getCommentOwnerName()) %></h3>
            <p><c:out value="<%= comment.getContent() %>" escapeXml="true"/>
            <p>
            <p class="timestamp"><%= ServletUtils.formatTimestamp(comment.getTimestamp()) %></p>
          </div>
          <!-- /.comment -->
        </div>
        <!-- /.usr -->
      </div>
      <!-- /.post -->

      <%
        }
    %>
      <div class="post group">
        <div class="usr last">
          <div class="comment">
            <form action="<%= configManager.getCommentPostUrl() %>"
              method="post">
              <input type="hidden" name="user" value="<%= photo.getOwnerId()%>" />
              <input type="hidden" name="id" value="<%= photo.getId()%>" />
              <textarea id="comment-input-<%= count %>" class="post-comment collapsed" name="comment"
                placeholder="Post a comment" onclick="toggleCommentPost(<%= count%>, true)"
                onchange="onCommentChanged(<%= count%>)"
                onkeyup="onCommentChanged(<%= count%>)" onPaste="onCommentChanged(<%= count%>)"></textarea>
              <input id="comment-submit-<%= count %>" class="inactive btn" style="display:none"
                type="submit" name="send" value="Post comment">
              <a id="comment-cancel-<%= count %>" class="cancel" style="display:none"
                onclick="toggleCommentPost(<%= count %>, false)">Cancel</a>
            </form>
          </div>
          <!-- /.comment -->
        </div>
        <!-- /.usr -->
      </div>
      <!-- /.post -->
    </div>
    <!-- /.feed -->
    <%
        count++;
      }
    %>
  </div>
  <!-- /.wrap -->
</body>
</html>
