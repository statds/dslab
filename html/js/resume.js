(function ($) {
	"use strict"; // Start of use strict

	// Closes responsive menu when a scroll trigger link is clicked
	$('.js-scroll-trigger').click(function () {
		$('.navbar-collapse').collapse('hide');
	});

})(jQuery); // End of use strict

$(window).on('resize', function () {
	$('.resume-section').css('min-height', $(window).height());
});


function navbar() {
	var x = document.getElementById("myTopnav");
	var activePageTitle = x.querySelector('.active.hide-on-large'); // Select the active page title

	if (x.className === "topnav") {
		x.className += " responsive";
		if (activePageTitle) {
			activePageTitle.style.display = 'none'; // Hide the active page title when navbar is expanded
		}
	} else {
		x.className = "topnav";
		if (activePageTitle) {
			activePageTitle.style.display = 'block'; // Show the active page title when navbar is collapsed
		}
	}
}

function toggleCourses(element) {
	const courses = element.nextElementSibling;
	if (courses.style.display === "none" || courses.style.display === "") {
		courses.style.display = "block";
	} else {
		courses.style.display = "none";
	}
}

function toggleReadMore() {
	var content = document.querySelector('.hidden-content');
	var linkText = document.querySelector('.read-more');
	
	if (content.style.display === "none" || content.style.display === "") {
		content.style.display = "block";
		linkText.innerHTML = "Show Less";
	} else {
		content.style.display = "none";
		linkText.innerHTML = "Read More";
	}
}
