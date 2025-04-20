// Wait for DOM to be fully loaded
document.addEventListener('DOMContentLoaded', function() {
    // Mobile menu toggle
    const mobileMenuToggle = document.querySelector('.mobile-menu-toggle');
    const navbarLinks = document.querySelector('.navbar-links');
    
    if (mobileMenuToggle && navbarLinks) {
        mobileMenuToggle.addEventListener('click', function() {
            navbarLinks.classList.toggle('active');
        });
    }
    
    // Form validation
    const registerForm = document.getElementById('registerForm');
    if (registerForm) {
        registerForm.addEventListener('submit', function(event) {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (password !== confirmPassword) {
                event.preventDefault();
                alert('Mật khẩu xác nhận không khớp!');
            }
        });
    }
    
    // Booking form calculation
    const bookingForm = document.getElementById('bookingForm');
    if (bookingForm) {
        const startDateTimeInput = document.getElementById('startDateTime');
        const endDateTimeInput = document.getElementById('endDateTime');
        const pricePerHourElement = document.querySelector('.field-price');
        
        if (startDateTimeInput && endDateTimeInput && pricePerHourElement) {
            const updateBookingSummary = function() {
                const startDateTime = new Date(startDateTimeInput.value);
                const endDateTime = new Date(endDateTimeInput.value);
                
                if (startDateTime && endDateTime && !isNaN(startDateTime) && !isNaN(endDateTime)) {
                    // Extract price per hour from text
                    const priceText = pricePerHourElement.textContent;
                    const priceMatch = priceText.match(/[\d,]+/);
                    if (priceMatch) {
                        const pricePerHour = parseFloat(priceMatch[0].replace(/,/g, ''));
                        
                        // Calculate duration in hours
                        const durationMs = endDateTime - startDateTime;
                        const durationHours = Math.max(1, Math.ceil(durationMs / (1000 * 60 * 60)));
                        
                        // Calculate total price
                        const totalPrice = durationHours * pricePerHour;
                        
                        // Update summary
                        const bookingDurationElement = document.getElementById('bookingDuration');
                        const totalPriceElement = document.getElementById('totalPrice');
                        
                        if (bookingDurationElement && totalPriceElement) {
                            bookingDurationElement.textContent = durationHours + ' giờ';
                            totalPriceElement.textContent = totalPrice.toLocaleString() + ' VNĐ';
                        }
                    }
                }
            };
            
            startDateTimeInput.addEventListener('change', updateBookingSummary);
            endDateTimeInput.addEventListener('change', updateBookingSummary);
            
            // Initial calculation
            updateBookingSummary();
        }
    }
    
    // Profile tabs
    const profileMenuLinks = document.querySelectorAll('.profile-menu a');
    if (profileMenuLinks.length > 0) {
        profileMenuLinks.forEach(link => {
            link.addEventListener('click', function(e) {
                e.preventDefault();
                
                // Remove active class from all links and sections
                document.querySelectorAll('.profile-menu a').forEach(item => item.classList.remove('active'));
                document.querySelectorAll('.profile-section').forEach(section => section.classList.remove('active'));
                
                // Add active class to clicked link
                this.classList.add('active');
                
                // Show corresponding section
                const targetId = this.getAttribute('href').substring(1);
                const targetSection = document.getElementById(targetId);
                if (targetSection) {
                    targetSection.classList.add('active');
                }
            });
        });
    }
    
    // Review modal
    const modal = document.getElementById('edit-review-modal');
    const editButtons = document.querySelectorAll('.edit-review-btn');
    const closeBtn = document.querySelector('.close');
    
    if (modal && editButtons.length > 0 && closeBtn) {
        editButtons.forEach(button => {
            button.addEventListener('click', function() {
                const reviewId = this.getAttribute('data-review-id');
                const rating = this.getAttribute('data-rating');
                const comment = this.getAttribute('data-comment');
                
                // Set form action
                const editForm = document.getElementById('editReviewForm');
                if (editForm) {
                    editForm.action = `/reviews/${reviewId}/update`;
                    
                    // Set rating
                    const ratingInput = document.querySelector(`#edit-star${rating}`);
                    if (ratingInput) {
                        ratingInput.checked = true;
                    }
                    
                    // Set comment
                    const commentInput = document.getElementById('edit-comment');
                    if (commentInput) {
                        commentInput.value = comment || '';
                    }
                }
                
                // Show modal
                modal.style.display = 'block';
            });
        });
        
        closeBtn.addEventListener('click', function() {
            modal.style.display = 'none';
        });
        
        window.addEventListener('click', function(event) {
            if (event.target === modal) {
                modal.style.display = 'none';
            }
        });
    }
    
    // Filter form reset
    const resetFilterBtn = document.getElementById('resetFilter');
    if (resetFilterBtn) {
        resetFilterBtn.addEventListener('click', function() {
            const filterForm = document.getElementById('filterForm');
            if (filterForm) {
                const typeSelect = document.getElementById('type');
                const locationInput = document.getElementById('location');
                const maxPriceInput = document.getElementById('maxPrice');
                const indoorRadios = document.querySelectorAll('input[name="indoor"]');
                
                if (typeSelect) typeSelect.value = '';
                if (locationInput) locationInput.value = '';
                if (maxPriceInput) maxPriceInput.value = '';
                
                indoorRadios.forEach(radio => {
                    if (radio.value === '') radio.checked = true;
                });
                
                filterForm.submit();
            }
        });
    }
});
