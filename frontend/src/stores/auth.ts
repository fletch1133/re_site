import { defineStore } from 'pinia'
import { ref } from 'vue'
import api from '../services/api'

export const useAuthStore = defineStore('auth', () => {
  const user = ref(null)
  const token = ref(localStorage.getItem('auth_token') || null)
  const isAuthenticated = ref(!!token.value)

  async function login(email: string, password: string) {
    try {
      const response = await api.post('/login', { email, password })
      token.value = response.data.token
      user.value = response.data.user
      isAuthenticated.value = true
      localStorage.setItem('auth_token', response.data.token)
      return true
    } catch (error) {
      console.error('Login failed:', error)
      return false
    }
  }

  async function logout() {
    try {
      await api.post('/logout')
    } catch (error) {
      console.error('Logout error:', error)
    } finally {
      token.value = null
      user.value = null
      isAuthenticated.value = false
      localStorage.removeItem('auth_token')
    }
  }

  async function checkAuth() {
    if (!token.value) return false
    
    try {
      const response = await api.get('/me')
      user.value = response.data
      isAuthenticated.value = true
      return true
    } catch (error) {
      logout()
      return false
    }
  }

  return {
    user,
    token,
    isAuthenticated,
    login,
    logout,
    checkAuth
  }
})

