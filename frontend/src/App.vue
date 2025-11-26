<script setup lang="ts">
import { RouterLink, RouterView } from 'vue-router'
import { useAuthStore } from './stores/auth'
import { computed } from 'vue'

const authStore = useAuthStore()
const isAuthenticated = computed(() => authStore.isAuthenticated)

function handleLogout() {
  authStore.logout()
}
</script>

<template>
  <div class="app">
    <header class="header">
      <div class="container">
        <div class="nav-wrapper">
          <RouterLink to="/" class="logo">
            <img src="/redevlogo.png" alt="Logo" class="logo-image" />
            <span class="logo-text">Anthony Fletcher Development</span>
          </RouterLink>
          <nav class="nav">
            <RouterLink to="/" class="nav-link">HOME</RouterLink>
            <RouterLink to="/about" class="nav-link">ABOUT</RouterLink>
            <RouterLink to="/projects" class="nav-link nav-link-primary">PROJECTS</RouterLink>
            <RouterLink to="/resume" class="nav-link">RESUME</RouterLink>
            <RouterLink v-if="isAuthenticated" to="/admin" class="nav-link">ADMIN</RouterLink>
            <RouterLink v-if="!isAuthenticated" to="/login" class="nav-link nav-link-login">LOGIN</RouterLink>
            <button v-if="isAuthenticated" @click="handleLogout" class="nav-link logout-btn">LOGOUT</button>
          </nav>
        </div>
      </div>
    </header>

    <main class="main">
      <RouterView />
    </main>

    <footer class="footer">
      <div class="container">
        <div class="footer-content">
          <p class="footer-text">&copy; 2025 AF Technologies. All rights reserved.</p>
        </div>
      </div>
    </footer>
  </div>
</template>

<style scoped>
* {
  box-sizing: border-box;
}

.app {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  background-color: #ffffff;
}

.header {
  background-color: #ffffff;
  border-bottom: 1px solid #e5e7eb;
  padding: 0;
  position: sticky;
  top: 0;
  z-index: 1000;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
}

.container {
  max-width: 100%;
  margin: 0 auto;
  padding: 0 6rem;
  width: 100%;
}

.nav-wrapper {
  display: flex;
  justify-content: space-between;
  align-items: center;
  height: 80px;
  gap: 2rem;
}

.logo {
  text-decoration: none;
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.logo-image {
  height: 45px;
  width: auto;
  object-fit: contain;
}

.logo-text {
  font-size: 1.75rem;
  font-weight: 700;
  letter-spacing: 3px;
  color: #1a1a1a;
  transition: color 0.3s ease;
}

.logo:hover .logo-text {
  color: #2c5282;
}

.nav {
  display: flex;
  gap: 2.5rem;
  align-items: center;
}

.nav-link {
  color: #4a5568;
  text-decoration: none;
  font-weight: 500;
  font-size: 0.875rem;
  letter-spacing: 1.5px;
  padding: 0.5rem 0.25rem;
  border-bottom: 2px solid transparent;
  transition: all 0.3s ease;
  position: relative;
  text-transform: uppercase;
  white-space: nowrap;
}

.nav-link:hover {
  color: #1a1a1a;
  border-bottom-color: #2c5282;
}

.nav-link.router-link-active {
  color: #1a1a1a;
  border-bottom-color: #2c5282;
}

.nav-link-primary {
  color: #2c5282;
  font-weight: 700;
  font-size: 0.9375rem;
}

.nav-link-login {
  padding: 0.5rem 1.5rem;
  border: 1px solid #2c5282;
  border-radius: 2px;
  color: #2c5282;
  border-bottom: 1px solid #2c5282;
}

.nav-link-login:hover {
  background-color: #2c5282;
  color: white;
  border-bottom: 1px solid #2c5282;
}

.logout-btn {
  background: none;
  border: 1px solid #dc2626;
  cursor: pointer;
  font-size: 0.875rem;
  letter-spacing: 1px;
  padding: 0.5rem 1.5rem;
  border-radius: 2px;
  color: #dc2626;
  font-weight: 500;
  transition: all 0.3s ease;
}

.logout-btn:hover {
  background-color: #dc2626;
  color: white;
}

.main {
  flex: 1;
  width: 100%;
}

.footer {
  background-color: #1a1a1a;
  padding: 2.5rem 0;
  margin-top: auto;
}

.footer-content {
  text-align: center;
}

.footer-text {
  color: #9ca3af;
  font-size: 0.875rem;
  margin: 0;
  letter-spacing: 0.5px;
}

@media (max-width: 1024px) {
  .container {
    padding: 0 3rem;
  }

  .nav {
    gap: 2rem;
  }
}

@media (max-width: 768px) {
  .nav-wrapper {
    flex-direction: column;
    height: auto;
    padding: 1rem 0;
    gap: 1rem;
  }

  .nav {
    flex-wrap: wrap;
    justify-content: center;
    gap: 1rem;
  }

  .logo-image {
    height: 35px;
  }

  .logo-text {
    font-size: 1.25rem;
  }

  .container {
    padding: 0 1.5rem;
  }
}
</style>
