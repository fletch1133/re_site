<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'

const router = useRouter()
const authStore = useAuthStore()

const email = ref('admin@example.com')
const password = ref('password')
const error = ref('')
const loading = ref(false)

async function handleLogin() {
  error.value = ''
  loading.value = true

  try {
    const success = await authStore.login(email.value, password.value)
    if (success) {
      router.push('/admin')
    } else {
      error.value = 'Invalid credentials. Please try again.'
    }
  } catch (err) {
    error.value = 'An error occurred. Please try again.'
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="login">
    <div class="container">
      <div class="login-card">
        <h1 class="page-title">Admin Login</h1>
        
        <form @submit.prevent="handleLogin" class="login-form">
          <div v-if="error" class="error-message">
            {{ error }}
          </div>

          <div class="form-group">
            <label for="email">Email</label>
            <input
              id="email"
              v-model="email"
              type="email"
              required
              placeholder="admin@example.com"
              class="form-control"
            />
          </div>

          <div class="form-group">
            <label for="password">Password</label>
            <input
              id="password"
              v-model="password"
              type="password"
              required
              placeholder="Enter your password"
              class="form-control"
            />
          </div>

          <button type="submit" :disabled="loading" class="btn btn-primary">
            {{ loading ? 'Logging in...' : 'Login' }}
          </button>
        </form>

        <div class="demo-credentials">
          <p><strong>Demo Credentials:</strong></p>
          <p>Email: admin@example.com</p>
          <p>Password: password</p>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.login {
  padding: 4rem 0;
  min-height: 60vh;
  display: flex;
  align-items: center;
}

.container {
  max-width: 500px;
  margin: 0 auto;
  padding: 0 2rem;
  width: 100%;
}

.login-card {
  background: white;
  padding: 3rem;
  border-radius: 12px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.page-title {
  font-size: 2rem;
  font-weight: 700;
  margin-bottom: 2rem;
  text-align: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.login-form {
  margin-bottom: 2rem;
}

.form-group {
  margin-bottom: 1.5rem;
}

.form-group label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 600;
  color: #495057;
}

.form-control {
  width: 100%;
  padding: 0.75rem;
  border: 2px solid #e9ecef;
  border-radius: 8px;
  font-size: 1rem;
  transition: border-color 0.3s;
}

.form-control:focus {
  outline: none;
  border-color: #667eea;
}

.btn {
  width: 100%;
  padding: 0.75rem;
  border: none;
  border-radius: 8px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s;
}

.btn-primary {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
}

.btn-primary:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
}

.btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.error-message {
  background: #f8d7da;
  color: #721c24;
  padding: 1rem;
  border-radius: 8px;
  margin-bottom: 1.5rem;
}

.demo-credentials {
  background: #f8f9fa;
  padding: 1rem;
  border-radius: 8px;
  text-align: center;
  font-size: 0.9rem;
  color: #6c757d;
}

.demo-credentials p {
  margin: 0.25rem 0;
}
</style>

