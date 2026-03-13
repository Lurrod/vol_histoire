document.addEventListener("DOMContentLoaded", async () => {
  /* =========================================================================
     UTILITIES
     ========================================================================= */
  
  function showToast(message, type = 'info') {
    const container = document.getElementById('toast-container');
    const toast = document.createElement('div');
    toast.className = `toast toast-${type}`;
    
    const icon = type === 'success' ? 'check-circle' : 
                 type === 'error' ? 'exclamation-circle' : 
                 'info-circle';
    
    toast.innerHTML = `
      <i class="fas fa-${icon}"></i>
      <span>${message}</span>
    `;
    
    container.appendChild(toast);
    
    setTimeout(() => {
      toast.classList.add('fade-out');
      setTimeout(() => toast.remove(), 300);
    }, 3000);
  }

  function formatDate(dateString) {
    if (!dateString) return 'Non spécifié';
    const date = new Date(dateString);
    return date.toLocaleDateString('fr-FR', { 
      year: 'numeric', 
      month: 'long', 
      day: 'numeric' 
    });
  }

  /* =========================================================================
     NAVIGATION & AUTH
     ========================================================================= */
  
  const header = document.querySelector('header');
  const hamburger = document.querySelector('.hamburger');
  const navLinks = document.querySelector('.nav-links');
  const loginIcon = document.getElementById('login-icon');
  const userToggle = document.querySelector('.user-toggle');
  const userDropdown = document.querySelector('.user-dropdown');

  // Header scroll effect with passive listener
  let lastScroll = 0;
  window.addEventListener('scroll', () => {
    const currentScroll = window.pageYOffset;

    if (currentScroll > 100) {
      header.classList.add('scrolled');
    } else {
      header.classList.remove('scrolled');
    }

    lastScroll = currentScroll;
  }, { passive: true });

  // Mobile menu toggle
  hamburger?.addEventListener('click', () => {
    navLinks?.classList.toggle('show');
    hamburger.classList.toggle('active');
    document.body.style.overflow = navLinks?.classList.contains('show') ? 'hidden' : '';
  });

  // Close mobile menu on link click (except login icon)
  document.querySelectorAll('.nav-links a').forEach(link => {
    link.addEventListener('click', (e) => {
      // Ne pas fermer le menu si c'est l'icône de login
      if (link.id === 'login-icon') {
        return;
      }
      navLinks?.classList.remove('show');
      hamburger?.classList.remove('active');
      document.body.style.overflow = '';
    });
  });

  // Close mobile menu on window resize with debouncing
  let resizeTimer;
  window.addEventListener('resize', () => {
    clearTimeout(resizeTimer);
    resizeTimer = setTimeout(() => {
      if (window.innerWidth > 992) {
        navLinks?.classList.remove('show');
        hamburger?.classList.remove('active');
        document.body.style.overflow = '';
      }
    }, 250); // Debounce resize events
  });

  // User dropdown toggle
  userToggle?.addEventListener('click', (e) => {
    e.preventDefault();
    e.stopPropagation();
    
    // Toggle the dropdown visibility
    if (userDropdown?.classList.contains('show')) {
      userDropdown.classList.remove('show');
      setTimeout(() => {
        userDropdown.classList.add('hidden');
      }, 300); // Wait for animation to complete
    } else {
      userDropdown?.classList.remove('hidden');
      setTimeout(() => {
        userDropdown?.classList.add('show');
      }, 10); // Small delay for smooth animation
    }
  });

  // Close dropdown when clicking outside
  document.addEventListener('click', (e) => {
    if (!userToggle?.contains(e.target) && !userDropdown?.contains(e.target)) {
      userDropdown?.classList.remove('show');
      userDropdown?.classList.add('hidden');
    }
  });

  // Login redirect
  loginIcon?.addEventListener('click', (e) => {
    const token = localStorage.getItem('token');
    if (!token) {
      e.preventDefault();
      window.location.href = 'login.html';
    }
  });

  // Settings navigation
  document.getElementById('settings-icon')?.addEventListener('click', (e) => {
    e.preventDefault();
    window.location.href = 'settings.html';
  });

  // Logout handlers
  const logoutButtons = document.querySelectorAll('#logout-icon, #logout-btn');
  logoutButtons.forEach(btn => {
    btn?.addEventListener('click', (e) => {
      e.preventDefault();
      localStorage.removeItem('token');
      
      // Show logout message
      showToast('Déconnexion réussie', 'success');
      
      // Redirect after a short delay
      setTimeout(() => {
        window.location.href = 'index.html';
      }, 1000);
    });
  });

  // Keyboard navigation - ESC to close menus
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
      navLinks?.classList.remove('show');
      hamburger?.classList.remove('active');
      userDropdown?.classList.remove('show');
      userDropdown?.classList.add('hidden');
      document.body.style.overflow = '';
    }
  });

  const token = localStorage.getItem('token');
  let userRole = null;

  if (token) {
    try {
      const payload = JSON.parse(atob(token.split('.')[1]));
      userRole = Number(payload.role);
      
      document.getElementById('user-name').textContent = payload.name;
      document.querySelector('.user-role').textContent = 
        userRole === 1 ? 'Administrateur' : userRole === 2 ? 'Éditeur' : 'Membre';
      
      userDropdown?.classList.remove('hidden');
      
      if (userRole === 1 || userRole === 2) {
        document.getElementById('edit-btn')?.classList.remove('hidden');
        document.getElementById('delete-btn')?.classList.remove('hidden');
      }
    } catch (error) {
      console.error('Token error:', error);
      localStorage.removeItem('token');
    }
  }

  // Settings navigation
  document.getElementById('settings-icon')?.addEventListener('click', (e) => {
    e.preventDefault();
    window.location.href = 'settings.html';
  });

  document.getElementById('logout-icon')?.addEventListener('click', (e) => {
    e.preventDefault();
    localStorage.removeItem('token');
    showToast('Déconnexion réussie', 'success');
    setTimeout(() => window.location.href = 'index.html', 1000);
  });

  /* =========================================================================
     TOUCH GESTURES
     ========================================================================= */

  let touchStartY = 0;
  let touchEndY = 0;

  document.addEventListener('touchstart', (e) => {
    touchStartY = e.changedTouches[0].screenY;
  }, { passive: true });

  document.addEventListener('touchend', (e) => {
    touchEndY = e.changedTouches[0].screenY;
    handleSwipe();
  }, { passive: true });

  function handleSwipe() {
    const swipeThreshold = 100;
    const diff = touchStartY - touchEndY;

    // Swipe up to close mobile menu
    if (diff > swipeThreshold && navLinks?.classList.contains('show')) {
      navLinks.classList.remove('show');
      hamburger?.classList.remove('active');
      document.body.style.overflow = '';
    }
  }

  /* =========================================================================
     GET AIRCRAFT ID
     ========================================================================= */
  
  const urlParams = new URLSearchParams(window.location.search);
  const aircraftId = urlParams.get('id');

  if (!aircraftId) {
    showToast('ID d\'avion manquant', 'error');
    setTimeout(() => window.location.href = 'hangar.html', 1500);
    return;
  }

  /* =========================================================================
     LOAD AIRCRAFT DATA
     ========================================================================= */
  
  let aircraftData = null;

  async function loadAircraftDetails() {
    try {
      const response = await fetch(`/api/airplanes/${aircraftId}`);
      
      if (!response.ok) {
        throw new Error('Avion non trouvé');
      }

      aircraftData = await response.json();
      renderAircraftDetails();
      loadRelatedData();
      checkFavoriteStatus();
      
    } catch (error) {
      console.error('Error loading aircraft:', error);
      showToast(error.message || 'Erreur lors du chargement', 'error');
      setTimeout(() => window.location.href = 'hangar.html', 1500);
    }
  }

  function renderAircraftDetails() {
    // Update page title
    document.title = `${aircraftData.name} | Vol d'Histoire`;

    // Breadcrumb
    document.getElementById('breadcrumb-name').textContent = aircraftData.name;

    // Hero section
    document.getElementById('aircraft-name').textContent = aircraftData.name || 'N/A';
    document.getElementById('aircraft-complete-name').textContent = aircraftData.complete_name || '';
    
    const badge = document.getElementById('hero-badge');
    if (aircraftData.generation) {
      badge.innerHTML = `
        <i class="fas fa-layer-group"></i>
        <span>${aircraftData.generation}e Génération</span>
      `;
    }

    document.getElementById('hero-country').textContent = aircraftData.country_name || 'Non spécifié';
    document.getElementById('hero-manufacturer').textContent = aircraftData.manufacturer_name || 'Non spécifié';
    
    if (aircraftData.date_operationel) {
      const year = new Date(aircraftData.date_operationel).getFullYear();
      document.getElementById('hero-year').textContent = year;
    }

    // Hero image
    const heroImage = document.getElementById('hero-image');
    heroImage.src = aircraftData.image_url || 'https://via.placeholder.com/800x500?text=No+Image';
    heroImage.alt = aircraftData.name;

    // Quick stats
    document.getElementById('stat-speed').textContent = 
      aircraftData.max_speed ? `${aircraftData.max_speed} km/h` : 'N/A';
    document.getElementById('stat-range').textContent = 
      aircraftData.max_range ? `${aircraftData.max_range} km` : 'N/A';
    document.getElementById('stat-weight').textContent = 
      aircraftData.weight ? `${aircraftData.weight} kg` : 'N/A';
    document.getElementById('stat-status').textContent = 
      aircraftData.status || 'Non spécifié';

    // Description
    document.getElementById('aircraft-description').textContent = 
      aircraftData.description || 'Aucune description disponible.';

    // Timeline dates
    const conceptEl = document.getElementById('date-concept');
    conceptEl.querySelector('.timeline-date').textContent = formatDate(aircraftData.date_concept);

    const firstFlyEl = document.getElementById('date-first-fly');
    firstFlyEl.querySelector('.timeline-date').textContent = formatDate(aircraftData.date_first_fly);

    const operationalEl = document.getElementById('date-operational');
    operationalEl.querySelector('.timeline-date').textContent = formatDate(aircraftData.date_operationel);
  }

  async function loadRelatedData() {
    try {
      const [armamentRes, techRes, missionsRes, warsRes] = await Promise.all([
        fetch(`/api/airplanes/${aircraftId}/armament`),
        fetch(`/api/airplanes/${aircraftId}/tech`),
        fetch(`/api/airplanes/${aircraftId}/missions`),
        fetch(`/api/airplanes/${aircraftId}/wars`)
      ]);

      const armament = await armamentRes.json();
      const technologies = await techRes.json();
      const missions = await missionsRes.json();
      const wars = await warsRes.json();

      renderArmament(armament);
      renderTechnologies(technologies);
      renderMissions(missions);
      renderWars(wars);

    } catch (error) {
      console.error('Error loading related data:', error);
    }
  }

  function renderArmament(armament) {
    const container = document.getElementById('armament-list');
    
    if (!armament || armament.length === 0) {
      container.innerHTML = '<p style="color: var(--text-secondary); text-align: center;">Aucun armement répertorié</p>';
      return;
    }

    container.innerHTML = armament.map(item => `
      <div class="feature-card">
        <h4>${item.name}</h4>
        <p>${item.description || 'Pas de description disponible'}</p>
      </div>
    `).join('');
  }

  function renderTechnologies(technologies) {
    const container = document.getElementById('tech-list');
    
    if (!technologies || technologies.length === 0) {
      container.innerHTML = '<p style="color: var(--text-secondary); text-align: center;">Aucune technologie répertoriée</p>';
      return;
    }

    container.innerHTML = technologies.map(item => `
      <div class="feature-card">
        <h4>${item.name}</h4>
        <p>${item.description || 'Pas de description disponible'}</p>
      </div>
    `).join('');
  }

  function renderMissions(missions) {
    const container = document.getElementById('missions-list');
    
    if (!missions || missions.length === 0) {
      container.innerHTML = '<p style="color: var(--text-secondary); text-align: center;">Aucune mission répertoriée</p>';
      return;
    }

    const missionIcons = {
      'Appui aérien rapproché': 'crosshairs',
      'Frappe tactique': 'bomb',
      'Supériorité aérienne': 'jet-fighter',
      'Interception': 'bullseye',
      'Reconnaissance': 'binoculars',
      'Escorte': 'shield-halved'
    };

    container.innerHTML = missions.map(item => `
      <div class="mission-card">
        <div class="mission-icon">
          <i class="fas fa-${missionIcons[item.name] || 'bullseye'}"></i>
        </div>
        <h4>${item.name}</h4>
        <p>${item.description || ''}</p>
      </div>
    `).join('');
  }

  function renderWars(wars) {
    const container = document.getElementById('wars-list');
    
    if (!wars || wars.length === 0) {
      container.innerHTML = '<p style="color: var(--text-secondary); text-align: center;">Aucun engagement historique répertorié</p>';
      return;
    }

    container.innerHTML = wars.map(war => {
      const startYear = war.date_start ? new Date(war.date_start).getFullYear() : '?';
      const endYear = war.date_end ? new Date(war.date_end).getFullYear() : '?';
      
      return `
        <div class="war-card">
          <h4>${war.name}</h4>
          <div class="war-period">
            <i class="fas fa-calendar-days"></i>
            <span>${startYear} - ${endYear}</span>
          </div>
          <p>${war.description || 'Pas de description disponible'}</p>
        </div>
      `;
    }).join('');
  }

  /* =========================================================================
     FAVORITE FUNCTIONALITY
     ========================================================================= */
  
  const favoriteBtn = document.getElementById('favorite-btn');
  let isFavorite = false;

  async function checkFavoriteStatus() {
    if (!token) return;

    try {
      const response = await fetch(`/api/airplanes/${aircraftId}/favorite`, {
        headers: { Authorization: `Bearer ${token}` }
      });

      const data = await response.json();
      isFavorite = data.isFavorite;
      updateFavoriteButton();

    } catch (error) {
      console.error('Error checking favorite:', error);
    }
  }

  function updateFavoriteButton() {
    if (!favoriteBtn) return;

    if (isFavorite) {
      favoriteBtn.classList.add('favorited');
      favoriteBtn.innerHTML = `
        <i class="fas fa-heart"></i>
        <span>Dans les favoris</span>
      `;
    } else {
      favoriteBtn.classList.remove('favorited');
      favoriteBtn.innerHTML = `
        <i class="far fa-heart"></i>
        <span>Ajouter aux favoris</span>
      `;
    }
  }

  favoriteBtn?.addEventListener('click', async () => {
    if (!token) {
      showToast('Veuillez vous connecter pour ajouter aux favoris', 'info');
      setTimeout(() => window.location.href = 'login.html', 1500);
      return;
    }

    try {
      const method = isFavorite ? 'DELETE' : 'POST';
      const response = await fetch(`/api/favorites/${aircraftId}`, {
        method,
        headers: { Authorization: `Bearer ${token}` }
      });

      if (!response.ok) {
        throw new Error('Erreur lors de la mise à jour des favoris');
      }

      isFavorite = !isFavorite;
      updateFavoriteButton();
      showToast(
        isFavorite ? 'Ajouté aux favoris !' : 'Retiré des favoris',
        'success'
      );

    } catch (error) {
      console.error('Error toggling favorite:', error);
      showToast(error.message, 'error');
    }
  });

  /* =========================================================================
     EDIT & DELETE FUNCTIONALITY
     ========================================================================= */
  
  const editBtn = document.getElementById('edit-btn');
  const deleteBtn = document.getElementById('delete-btn');
  const editModal = document.getElementById('edit-modal');
  const editForm = document.getElementById('edit-form');
  const cancelEditBtn = document.getElementById('cancel-edit-btn');
  const modalClose = document.querySelector('.modal-close');

  editBtn?.addEventListener('click', () => {
    openEditModal();
  });

  [cancelEditBtn, modalClose].forEach(btn => {
    btn?.addEventListener('click', () => closeEditModal());
  });

  editModal?.addEventListener('click', (e) => {
    if (e.target === editModal || e.target.classList.contains('modal-backdrop')) {
      closeEditModal();
    }
  });

  async function openEditModal() {
    if (!aircraftData) return;

    // Populate form
    document.getElementById('edit-name').value = aircraftData.name || '';
    document.getElementById('edit-complete-name').value = aircraftData.complete_name || '';
    document.getElementById('edit-little-description').value = aircraftData.little_description || '';
    document.getElementById('edit-image-url').value = aircraftData.image_url || '';
    document.getElementById('edit-description').value = aircraftData.description || '';
    document.getElementById('edit-status').value = aircraftData.status || '';
    document.getElementById('edit-date-concept').value = aircraftData.date_concept?.split('T')[0] || '';
    document.getElementById('edit-date-first-fly').value = aircraftData.date_first_fly?.split('T')[0] || '';
    document.getElementById('edit-date-operationel').value = aircraftData.date_operationel?.split('T')[0] || '';
    document.getElementById('edit-max-speed').value = aircraftData.max_speed || '';
    document.getElementById('edit-max-range').value = aircraftData.max_range || '';
    document.getElementById('edit-weight').value = aircraftData.weight || '';

    // Load and populate selects
    await loadFormSelects();

    document.getElementById('edit-country-id').value = aircraftData.country_id || '';
    document.getElementById('edit-manufacturer-id').value = aircraftData.id_manufacturer || '';
    document.getElementById('edit-generation-id').value = aircraftData.id_generation || '';
    document.getElementById('edit-type').value = aircraftData.type || '';

    editModal.classList.add('show');
    document.body.style.overflow = 'hidden';
  }

  function closeEditModal() {
    editModal.classList.remove('show');
    document.body.style.overflow = '';
  }

  async function loadFormSelects() {
    try {
      const [countriesRes, manufacturersRes, typesRes] = await Promise.all([
        fetch('/api/countries'),
        fetch('/api/manufacturers'),
        fetch('/api/types')
      ]);

      const countries = await countriesRes.json();
      const manufacturers = await manufacturersRes.json();
      const types = await typesRes.json();

      document.getElementById('edit-country-id').innerHTML = 
        '<option value="">Sélectionner...</option>' +
        countries.map(c => `<option value="${c.id}">${c.name}</option>`).join('');

      document.getElementById('edit-manufacturer-id').innerHTML = 
        '<option value="">Sélectionner...</option>' +
        manufacturers.map(m => `<option value="${m.id}">${m.name}</option>`).join('');

      document.getElementById('edit-type').innerHTML = 
        '<option value="">Sélectionner...</option>' +
        types.map(t => `<option value="${t.id}">${t.name}</option>`).join('');

      document.getElementById('edit-generation-id').innerHTML = 
        '<option value="">Sélectionner...</option>' +
        [1, 2, 3, 4, 5].map(g => `<option value="${g}">${g}e Génération</option>`).join('');

    } catch (error) {
      console.error('Error loading form selects:', error);
    }
  }

  editForm?.addEventListener('submit', async (e) => {
    e.preventDefault();

    if (!token || (userRole !== 1 && userRole !== 2)) {
      showToast('Accès non autorisé', 'error');
      return;
    }

    const formData = {
      name: document.getElementById('edit-name').value,
      complete_name: document.getElementById('edit-complete-name').value,
      little_description: document.getElementById('edit-little-description').value,
      image_url: document.getElementById('edit-image-url').value,
      description: document.getElementById('edit-description').value,
      country_id: parseInt(document.getElementById('edit-country-id').value),
      id_manufacturer: parseInt(document.getElementById('edit-manufacturer-id').value),
      id_generation: parseInt(document.getElementById('edit-generation-id').value),
      type: parseInt(document.getElementById('edit-type').value),
      status: document.getElementById('edit-status').value,
      date_concept: document.getElementById('edit-date-concept').value || null,
      date_first_fly: document.getElementById('edit-date-first-fly').value || null,
      date_operationel: document.getElementById('edit-date-operationel').value || null,
      max_speed: parseFloat(document.getElementById('edit-max-speed').value) || null,
      max_range: parseFloat(document.getElementById('edit-max-range').value) || null,
      weight: parseFloat(document.getElementById('edit-weight').value) || null
    };

    try {
      const response = await fetch(`/api/airplanes/${aircraftId}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`
        },
        body: JSON.stringify(formData)
      });

      if (!response.ok) {
        throw new Error('Erreur lors de la mise à jour');
      }

      showToast('Avion mis à jour avec succès !', 'success');
      closeEditModal();
      
      // Reload data
      await loadAircraftDetails();

    } catch (error) {
      console.error('Error updating aircraft:', error);
      showToast(error.message || 'Erreur lors de la mise à jour', 'error');
    }
  });

  deleteBtn?.addEventListener('click', async () => {
    if (!confirm(`Êtes-vous sûr de vouloir supprimer "${aircraftData.name}" ?\n\nCette action est irréversible.`)) {
      return;
    }

    try {
      const response = await fetch(`/api/airplanes/${aircraftId}`, {
        method: 'DELETE',
        headers: { Authorization: `Bearer ${token}` }
      });

      if (!response.ok) {
        throw new Error('Erreur lors de la suppression');
      }

      showToast('Avion supprimé avec succès', 'success');
      setTimeout(() => window.location.href = 'hangar.html', 1500);

    } catch (error) {
      console.error('Error deleting aircraft:', error);
      showToast(error.message || 'Erreur lors de la suppression', 'error');
    }
  });

  /* =========================================================================
     KEYBOARD SHORTCUTS
     ========================================================================= */
  
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
      closeEditModal();
    }
  });

  /* =========================================================================
     ANIMATIONS
     ========================================================================= */
  
  const observeElements = () => {
    const observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.style.opacity = '1';
          entry.target.style.transform = 'translateY(0)';
          observer.unobserve(entry.target);
        }
      });
    }, { threshold: 0.1 });

    document.querySelectorAll('.content-section').forEach(section => {
      section.style.opacity = '0';
      section.style.transform = 'translateY(20px)';
      section.style.transition = 'all 0.5s ease';
      observer.observe(section);
    });
  };

  /* =========================================================================
     INITIALIZE
     ========================================================================= */
  
  await loadAircraftDetails();
  observeElements();

  console.log('Aircraft details page initialized');
});