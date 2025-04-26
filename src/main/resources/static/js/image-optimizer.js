/**
 * Image optimization script for Sports Field Booking System
 */
document.addEventListener('DOMContentLoaded', function() {
    // Optimize image loading with lazy loading and fade-in effect
    const optimizeImages = () => {
        const images = document.querySelectorAll('img[loading="lazy"]');
        
        // Create IntersectionObserver to load images only when they're visible
        const imageObserver = new IntersectionObserver((entries, observer) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const img = entry.target;
                    const src = img.getAttribute('data-src') || img.getAttribute('src');
                    
                    if (src) {
                        img.src = src;
                        img.style.opacity = '0';
                        
                        img.onload = function() {
                            img.style.transition = 'opacity 0.3s ease';
                            img.style.opacity = '1';
                        };
                        
                        img.onerror = function() {
                            // If image fails to load, use a fallback
                            const fallback = img.getAttribute('data-fallback') || '/images/football1.jpg';
                            img.src = fallback;
                        };
                        
                        observer.unobserve(img);
                    }
                }
            });
        }, {
            rootMargin: '50px 0px',
            threshold: 0.01
        });
        
        // Observe all lazy-loaded images
        images.forEach(img => {
            imageObserver.observe(img);
        });
    };
    
    // Initialize image optimization
    optimizeImages();
    
    // Handle image errors
    document.querySelectorAll('img').forEach(img => {
        img.addEventListener('error', function() {
            this.src = '/images/football1.jpg';
        });
    });
});
