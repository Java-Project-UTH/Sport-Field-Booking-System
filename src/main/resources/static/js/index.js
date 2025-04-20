document.addEventListener("DOMContentLoaded", () => {
    let currentIndex = 0;
    const slides = document.querySelectorAll('.slide');

    // Debugging: Check if slides are correctly selected
    console.log("Slides detected:", slides);

    if (slides.length === 0) {
        console.error("No slides found! Ensure the '.slide' class is applied correctly.");
        return; // Stop execution if no slides are found
    }

    function showNextSlide() {
        // Debugging: Log current index
        console.log("Current index before:", currentIndex);

        // Hide the current slide
        slides[currentIndex].classList.remove('active');

        // Move to the next slide
        currentIndex = (currentIndex + 1) % slides.length;

        // Show the next slide
        slides[currentIndex].classList.add('active');

        // Debugging: Log current index after
        console.log("Current index after:", currentIndex);
    }

    // Change slide every 3 seconds
    setInterval(showNextSlide, 3000);
});
