import { defineStore } from 'pinia'
import { ref } from 'vue'
import api from '../services/api'

export interface Project {
  id: number
  title: string
  description: string | null
  category: 'single_family' | 'multi_family_commercial' | 'land_entitlements'
  pdf_path: string
  pdf_original_name: string
  pdf_size: number | null
  summary_pdf_path: string | null
  summary_pdf_original_name: string | null
  summary_pdf_size: number | null
  is_published: boolean
  created_at: string
  updated_at: string
}

export const useProjectsStore = defineStore('projects', () => {
  const projects = ref<Project[]>([])
  const loading = ref(false)
  const error = ref<string | null>(null)

  async function fetchProjects() {
    loading.value = true
    error.value = null
    try {
      const response = await api.get('/projects')
      projects.value = response.data
    } catch (err: any) {
      error.value = err.message || 'Failed to fetch projects'
      console.error('Error fetching projects:', err)
    } finally {
      loading.value = false
    }
  }

  async function createProject(formData: FormData) {
    loading.value = true
    error.value = null
    try {
      const response = await api.post('/projects', formData, {
        headers: {
          'Content-Type': 'multipart/form-data'
        }
      })
      projects.value.unshift(response.data)
      return response.data
    } catch (err: any) {
      error.value = err.message || 'Failed to create project'
      console.error('Error creating project:', err)
      throw err
    } finally {
      loading.value = false
    }
  }

  async function updateProject(id: number, formData: FormData) {
    loading.value = true
    error.value = null
    try {
      const response = await api.post(`/projects/${id}`, formData, {
        headers: {
          'Content-Type': 'multipart/form-data'
        }
      })
      const index = projects.value.findIndex(p => p.id === id)
      if (index !== -1) {
        projects.value[index] = response.data
      }
      return response.data
    } catch (err: any) {
      error.value = err.message || 'Failed to update project'
      console.error('Error updating project:', err)
      throw err
    } finally {
      loading.value = false
    }
  }

  async function deleteProject(id: number) {
    loading.value = true
    error.value = null
    try {
      await api.delete(`/projects/${id}`)
      projects.value = projects.value.filter(p => p.id !== id)
    } catch (err: any) {
      error.value = err.message || 'Failed to delete project'
      console.error('Error deleting project:', err)
      throw err
    } finally {
      loading.value = false
    }
  }

  function getPdfUrl(pdfPath: string) {
    const storageBaseUrl = import.meta.env.VITE_STORAGE_BASE_URL || 'http://localhost:8000/storage'
    return `${storageBaseUrl}/${pdfPath}`
  }

  // Get file URL with CORS support (for fetching files via JavaScript)
  function getFileUrlWithCors(pdfPath: string) {
    const apiBaseUrl = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8000/api'
    return `${apiBaseUrl}/files/${pdfPath}`
  }

  return {
    projects,
    loading,
    error,
    fetchProjects,
    createProject,
    updateProject,
    deleteProject,
    getPdfUrl,
    getFileUrlWithCors
  }
})

