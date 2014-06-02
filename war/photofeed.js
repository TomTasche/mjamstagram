function onFileSelected() {
	filename = document.getElementById("input-file").value;
	if (filename == null || filename == "") {
		document.getElementById("btn-post").setAttribute("class",
				"inactive btn");
		document.getElementById("btn-post").disabled = true;
	} else {
		document.getElementById("btn-post").setAttribute("class", "active btn");
		document.getElementById("btn-post").disabled = false;
	}
}

function togglePhotoPost(expanded) {
	onFileSelected();
	if (expanded) {
		document.getElementById("btn-choose-image").style.display = "none";
		document.getElementById("upload-form").style.display = "block";
	} else {
		document.getElementById("btn-choose-image").style.display = "inline-block";
		document.getElementById("upload-form").style.display = "none";
	}
}

function onCommentChanged(id) {
	comment = document.getElementById("comment-input-" + id).value;
	if (comment == null || comment.trim() == "") {
		document.getElementById("comment-submit-" + id).setAttribute("class",
				"inactive btn");
		document.getElementById("comment-submit-" + id).disabled = true;
	} else {
		document.getElementById("comment-submit-" + id).setAttribute("class",
				"active btn");
		document.getElementById("comment-submit-" + id).disabled = false;
	}
}

function toggleCommentPost(id, expanded) {
	onCommentChanged(id);
	if (expanded) {
		document.getElementById("comment-input-" + id).setAttribute("class",
				"post-comment expanded");
		document.getElementById("comment-submit-" + id).style.display = "inline-block";
		document.getElementById("comment-cancel-" + id).style.display = "inline-block";
	} else {
		document.getElementById("comment-input-" + id).value = ""
		document.getElementById("comment-input-" + id).setAttribute("class",
				"post-comment collapsed");
		document.getElementById("comment-submit-" + id).style.display = "none";
		document.getElementById("comment-cancel-" + id).style.display = "none";
	}
}