// BookNest Static Export - Consolidated JavaScript

document.addEventListener('DOMContentLoaded', function() {
  // Mobile menu toggle
  const mobileMenuBtn = document.getElementById('mobile-menu-btn');
  const mobileMenu = document.getElementById('mobile-menu');
  
  if (mobileMenuBtn && mobileMenu) {
    mobileMenuBtn.addEventListener('click', function() {
      mobileMenu.classList.toggle('hidden');
    });
  }

  // Accordion functionality
  const accordionTriggers = document.querySelectorAll('.accordion-trigger');
  
  accordionTriggers.forEach(trigger => {
    trigger.addEventListener('click', function() {
      const content = this.nextElementSibling;
      const icon = this.querySelector('.accordion-icon');
      
      // Close all other accordions
      accordionTriggers.forEach(otherTrigger => {
        if (otherTrigger !== trigger) {
          const otherContent = otherTrigger.nextElementSibling;
          const otherIcon = otherTrigger.querySelector('.accordion-icon');
          if (otherContent) otherContent.classList.add('hidden');
          if (otherIcon) otherIcon.style.transform = 'rotate(0deg)';
        }
      });
      
      // Toggle current accordion
      if (content) {
        content.classList.toggle('hidden');
        if (icon) {
          icon.style.transform = content.classList.contains('hidden') ? 'rotate(0deg)' : 'rotate(180deg)';
        }
      }
    });
  });

  // Sidebar toggle for student portal
  const sidebarToggle = document.getElementById('sidebar-toggle');
  const sidebar = document.getElementById('sidebar');
  
  if (sidebarToggle && sidebar) {
    sidebarToggle.addEventListener('click', function() {
      sidebar.classList.toggle('-translate-x-full');
    });
  }

  // Form validation
  const forms = document.querySelectorAll('form[data-validate]');
  
  forms.forEach(form => {
    form.addEventListener('submit', function(e) {
      e.preventDefault();
      
      const inputs = form.querySelectorAll('input[required]');
      let isValid = true;
      
      inputs.forEach(input => {
        if (!input.value.trim()) {
          isValid = false;
          input.classList.add('border-red-500');
        } else {
          input.classList.remove('border-red-500');
        }
      });
      
      if (isValid) {
        // Show success message
        const successMsg = document.createElement('div');
        successMsg.className = 'fixed top-4 right-4 bg-green-500 text-white px-6 py-3 rounded-lg shadow-lg animate-fade-in';
        successMsg.textContent = 'Form submitted successfully!';
        document.body.appendChild(successMsg);
        
        setTimeout(() => {
          successMsg.remove();
        }, 3000);
      }
    });
  });

  // Search functionality
  const searchInput = document.getElementById('search-input');
  const searchBtn = document.getElementById('search-btn');
  
  if (searchBtn && searchInput) {
    searchBtn.addEventListener('click', function() {
      const query = searchInput.value.trim();
      if (query) {
        // In static version, just show an alert
        alert('Search for: ' + query);
      }
    });
    
    searchInput.addEventListener('keypress', function(e) {
      if (e.key === 'Enter') {
        searchBtn.click();
      }
    });
  }

  // Dark mode toggle
  const darkModeToggle = document.getElementById('dark-mode-toggle');
  
  if (darkModeToggle) {
    // Check for saved preference
    if (localStorage.getItem('darkMode') === 'true' || 
        (!localStorage.getItem('darkMode') && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
      document.documentElement.classList.add('dark');
    }
    
    darkModeToggle.addEventListener('click', function() {
      document.documentElement.classList.toggle('dark');
      localStorage.setItem('darkMode', document.documentElement.classList.contains('dark'));
    });
  }

  // Smooth scroll for anchor links
  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function(e) {
      e.preventDefault();
      const target = document.querySelector(this.getAttribute('href'));
      if (target) {
        target.scrollIntoView({
          behavior: 'smooth',
          block: 'start'
        });
      }
    });
  });

  // Image lazy loading
  const images = document.querySelectorAll('img[data-src]');
  
  if ('IntersectionObserver' in window) {
    const imageObserver = new IntersectionObserver((entries, observer) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          const img = entry.target;
          img.src = img.dataset.src;
          img.removeAttribute('data-src');
          observer.unobserve(img);
        }
      });
    });
    
    images.forEach(img => imageObserver.observe(img));
  } else {
    // Fallback for older browsers
    images.forEach(img => {
      img.src = img.dataset.src;
    });
  }

  // Animate elements on scroll
  const animateOnScroll = document.querySelectorAll('.animate-on-scroll');
  
  if ('IntersectionObserver' in window && animateOnScroll.length > 0) {
    const animateObserver = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.classList.add('animate-slide-up');
        }
      });
    }, { threshold: 0.1 });
    
    animateOnScroll.forEach(el => animateObserver.observe(el));
  }

  // Tab functionality
  const tabButtons = document.querySelectorAll('[data-tab]');
  
  tabButtons.forEach(button => {
    button.addEventListener('click', function() {
      const tabId = this.dataset.tab;
      const tabContent = document.getElementById(tabId);
      
      // Hide all tab contents
      document.querySelectorAll('.tab-content').forEach(content => {
        content.classList.add('hidden');
      });
      
      // Remove active state from all buttons
      tabButtons.forEach(btn => {
        btn.classList.remove('bg-primary', 'text-primary-foreground');
        btn.classList.add('bg-secondary');
      });
      
      // Show selected tab and activate button
      if (tabContent) {
        tabContent.classList.remove('hidden');
      }
      this.classList.remove('bg-secondary');
      this.classList.add('bg-primary', 'text-primary-foreground');
    });
  });

  // Toast notification helper
  window.showToast = function(message, type = 'success') {
    const colors = {
      success: 'bg-green-500',
      error: 'bg-red-500',
      warning: 'bg-yellow-500',
      info: 'bg-blue-500'
    };
    
    const toast = document.createElement('div');
    toast.className = `fixed bottom-4 right-4 ${colors[type]} text-white px-6 py-3 rounded-lg shadow-lg animate-fade-in z-50`;
    toast.textContent = message;
    document.body.appendChild(toast);
    
    setTimeout(() => {
      toast.classList.add('opacity-0');
      toast.style.transition = 'opacity 0.3s ease';
      setTimeout(() => toast.remove(), 300);
    }, 3000);
  };
});
