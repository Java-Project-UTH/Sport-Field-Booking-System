document.addEventListener('DOMContentLoaded', function() {
    // Get elements
    const menuToggle = document.querySelector('.menu-toggle');
    const sidebar = document.querySelector('.sidebar');
    const mainContent = document.querySelector('.main-content');
    const sidebarOverlay = document.querySelector('.sidebar-overlay');

    // Chỉ xử lý sidebar khi nó tồn tại (khi đã đăng nhập)
    if (sidebar && mainContent) {
        // Toggle sidebar on menu button click
        if (menuToggle) {
            menuToggle.addEventListener('click', function() {
                sidebar.classList.toggle('active');
                mainContent.classList.toggle('sidebar-active');
                if (sidebarOverlay) {
                    sidebarOverlay.classList.toggle('active');
                }
            });
        }

        // Close sidebar when clicking on overlay
        if (sidebarOverlay) {
            sidebarOverlay.addEventListener('click', function() {
                sidebar.classList.remove('active');
                mainContent.classList.remove('sidebar-active');
                sidebarOverlay.classList.remove('active');
            });
        }

        // Close sidebar when window is resized to desktop size
        window.addEventListener('resize', function() {
            if (window.innerWidth > 992) {
                sidebar.classList.remove('active');
                mainContent.classList.remove('sidebar-active');
                if (sidebarOverlay) {
                    sidebarOverlay.classList.remove('active');
                }
            }
        });

        // Add active class to current menu item
        const currentLocation = window.location.pathname;
        const menuItems = document.querySelectorAll('.sidebar-menu a');

        menuItems.forEach(item => {
            const itemPath = item.getAttribute('href');

            // Check if the current path starts with the menu item path
            // This handles both exact matches and sub-paths
            if (currentLocation === itemPath ||
                (itemPath !== '/' && currentLocation.startsWith(itemPath))) {
                item.classList.add('active');
            }
        });
    }
});
