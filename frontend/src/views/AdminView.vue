<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useProjectsStore } from '../stores/projects'
import api from '../services/api'

const projectsStore = useProjectsStore()

const showForm = ref(false)
const editingProject = ref<number | null>(null)
const title = ref('')
const description = ref('')
const category = ref<'single_family' | 'multi_family_commercial' | 'land_entitlements'>('single_family')
const pdfFile = ref<File | null>(null)
const isPublished = ref(true)
const formError = ref('')

// Resume state
const resumeFile = ref<File | null>(null)
const resumeUploading = ref(false)
const resumeError = ref('')
const resumeSuccess = ref('')
const currentResume = ref<any>(null)

onMounted(() => {
  projectsStore.fetchProjects()
  fetchCurrentResume()
})

async function fetchCurrentResume() {
  try {
    const response = await api.get('/resume')
    currentResume.value = response.data
  } catch (error) {
    // No resume uploaded yet
  }
}

function openCreateForm() {
  resetForm()
  showForm.value = true
}

function openEditForm(project: any) {
  editingProject.value = project.id
  title.value = project.title
  description.value = project.description || ''
  category.value = project.category || 'single_family'
  isPublished.value = project.is_published
  pdfFile.value = null
  showForm.value = true
}

function resetForm() {
  editingProject.value = null
  title.value = ''
  description.value = ''
  category.value = 'single_family'
  pdfFile.value = null
  isPublished.value = true
  formError.value = ''
}

function closeForm() {
  showForm.value = false
  resetForm()
}

function handleFileChange(event: Event) {
  const target = event.target as HTMLInputElement
  if (target.files && target.files[0]) {
    pdfFile.value = target.files[0]
  }
}

function handleResumeFileChange(event: Event) {
  const target = event.target as HTMLInputElement
  if (target.files && target.files[0]) {
    resumeFile.value = target.files[0]
  }
}

async function handleResumeUpload() {
  if (!resumeFile.value) {
    resumeError.value = 'Please select a PDF file'
    return
  }

  resumeUploading.value = true
  resumeError.value = ''
  resumeSuccess.value = ''

  const formData = new FormData()
  formData.append('pdf', resumeFile.value)

  try {
    const response = await api.post('/resume', formData, {
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    })
    currentResume.value = response.data
    resumeSuccess.value = 'Resume uploaded successfully!'
    resumeFile.value = null
    // Clear file input
    const fileInput = document.getElementById('resume-file') as HTMLInputElement
    if (fileInput) fileInput.value = ''
  } catch (error) {
    resumeError.value = 'Failed to upload resume. Please try again.'
  } finally {
    resumeUploading.value = false
  }
}

async function handleSubmit() {
  formError.value = ''

  if (!title.value.trim()) {
    formError.value = 'Title is required'
    return
  }

  if (!editingProject.value && !pdfFile.value) {
    formError.value = 'PDF file is required'
    return
  }

  const formData = new FormData()
  formData.append('title', title.value)
  formData.append('description', description.value)
  formData.append('category', category.value)
  formData.append('is_published', isPublished.value ? '1' : '0')

  if (pdfFile.value) {
    formData.append('pdf', pdfFile.value)
  }

  try {
    if (editingProject.value) {
      await projectsStore.updateProject(editingProject.value, formData)
    } else {
      await projectsStore.createProject(formData)
    }
    closeForm()
  } catch (error) {
    formError.value = 'Failed to save project. Please try again.'
  }
}

async function handleDelete(id: number) {
  if (confirm('Are you sure you want to delete this project?')) {
    try {
      await projectsStore.deleteProject(id)
    } catch (error) {
      alert('Failed to delete project')
    }
  }
}
</script>

<template>
  <div class="admin">
    <div class="container">
      <div class="admin-header">
        <h1 class="page-title">Admin Dashboard</h1>
        <button @click="openCreateForm" class="btn btn-primary">
          + Add New Project
        </button>
      </div>

      <!-- Resume Upload Section -->
      <div class="resume-section">
        <h2 class="section-title">Resume Management</h2>
        <div class="resume-upload-card">
          <div v-if="currentResume" class="current-resume">
            <div class="resume-info">
              <span class="info-label">Current Resume:</span>
              <span class="info-value">{{ currentResume.pdf_original_name }}</span>
              <span v-if="currentResume.pdf_size" class="info-size">
                ({{ (currentResume.pdf_size / 1024 / 1024).toFixed(2) }} MB)
              </span>
            </div>
          </div>

          <div class="upload-form">
            <div v-if="resumeSuccess" class="success-message">
              {{ resumeSuccess }}
            </div>
            <div v-if="resumeError" class="error-message">
              {{ resumeError }}
            </div>

            <div class="form-group">
              <label for="resume-file">Upload New Resume (PDF Only) *</label>
              <p class="form-hint">Only PDF files can be previewed in the browser. Please convert Word documents to PDF before uploading.</p>
              <input
                id="resume-file"
                type="file"
                accept=".pdf"
                @change="handleResumeFileChange"
                class="form-control"
                :disabled="resumeUploading"
              />
            </div>

            <button
              @click="handleResumeUpload"
              class="btn btn-upload"
              :disabled="!resumeFile || resumeUploading"
            >
              {{ resumeUploading ? 'Uploading...' : 'Upload Resume' }}
            </button>
          </div>
        </div>
      </div>

      <h2 class="section-title">Projects Management</h2>

      <div v-if="projectsStore.loading" class="loading">
        Loading projects...
      </div>

      <div v-else class="projects-list">
        <div v-if="projectsStore.projects.length === 0" class="empty">
          <p>No projects yet. Create your first project!</p>
        </div>

        <div v-for="project in projectsStore.projects" :key="project.id" class="project-item">
          <div class="project-info">
            <h3>{{ project.title }}</h3>
            <p v-if="project.description">{{ project.description }}</p>
            <div class="project-meta">
              <span class="badge" :class="project.is_published ? 'badge-success' : 'badge-warning'">
                {{ project.is_published ? 'Published' : 'Draft' }}
              </span>
              <span class="badge badge-info">
                {{ project.category === 'single_family' ? 'Single Family' :
                   project.category === 'multi_family_commercial' ? 'Multi-Family/Commercial' :
                   'Land Entitlements' }}
              </span>
              <span class="file-name">{{ project.pdf_original_name }}</span>
            </div>
          </div>
          <div class="project-actions">
            <button @click="openEditForm(project)" class="btn btn-secondary btn-sm">
              Edit
            </button>
            <button @click="handleDelete(project.id)" class="btn btn-danger btn-sm">
              Delete
            </button>
          </div>
        </div>
      </div>

      <!-- Modal Form -->
      <div v-if="showForm" class="modal-overlay" @click.self="closeForm">
        <div class="modal-content">
          <div class="modal-header">
            <h2>{{ editingProject ? 'Edit Project' : 'Create New Project' }}</h2>
            <button @click="closeForm" class="close-btn">&times;</button>
          </div>

          <form @submit.prevent="handleSubmit" class="project-form">
            <div v-if="formError" class="error-message">
              {{ formError }}
            </div>

            <div class="form-group">
              <label for="title">Project Title *</label>
              <input
                id="title"
                v-model="title"
                type="text"
                required
                class="form-control"
                placeholder="Enter project title"
              />
            </div>

            <div class="form-group">
              <label for="description">Description</label>
              <textarea
                id="description"
                v-model="description"
                class="form-control"
                rows="4"
                placeholder="Enter project description"
              ></textarea>
            </div>

            <div class="form-group">
              <label for="category">Project Category *</label>
              <select
                id="category"
                v-model="category"
                required
                class="form-control"
              >
                <option value="single_family">Single Family</option>
                <option value="multi_family_commercial">Multi-Family/Commercial</option>
                <option value="land_entitlements">Land Entitlements</option>
              </select>
            </div>

            <div class="form-group">
              <label for="pdf">PDF File {{ editingProject ? '(leave empty to keep current)' : '*' }}</label>
              <input
                id="pdf"
                type="file"
                accept=".pdf"
                @change="handleFileChange"
                class="form-control"
              />
            </div>

            <div class="form-group checkbox-group">
              <label>
                <input
                  v-model="isPublished"
                  type="checkbox"
                />
                <span>Publish this project</span>
              </label>
            </div>

            <div class="form-actions">
              <button type="button" @click="closeForm" class="btn btn-secondary">
                Cancel
              </button>
              <button type="submit" class="btn btn-primary">
                {{ editingProject ? 'Update' : 'Create' }} Project
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.admin {
  padding: 4rem 0;
  min-height: 60vh;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 2rem;
}

.admin-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 3rem;
  flex-wrap: wrap;
  gap: 1rem;
}

.page-title {
  font-size: 2.5rem;
  font-weight: 700;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  margin: 0;
}

.section-title {
  font-size: 1.75rem;
  font-weight: 700;
  color: #1a1a1a;
  margin-bottom: 1.5rem;
  margin-top: 3rem;
}

.resume-section {
  margin-bottom: 4rem;
}

.resume-upload-card {
  background: white;
  padding: 2rem;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.current-resume {
  margin-bottom: 2rem;
  padding-bottom: 2rem;
  border-bottom: 1px solid #e5e7eb;
}

.resume-info {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  flex-wrap: wrap;
}

.info-label {
  font-weight: 600;
  color: #4a5568;
}

.info-value {
  color: #1a1a1a;
}

.info-size {
  color: #6b7280;
  font-size: 0.875rem;
}

.upload-form {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.btn-upload {
  align-self: flex-start;
  background-color: #2c5282;
  color: white;
  border: none;
  padding: 0.75rem 2rem;
  border-radius: 4px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s;
}

.btn-upload:hover:not(:disabled) {
  background-color: #2a4365;
  transform: translateY(-2px);
}

.btn-upload:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.success-message {
  padding: 1rem;
  background-color: #d1fae5;
  color: #065f46;
  border-radius: 4px;
  border-left: 4px solid #10b981;
}

.error-message {
  padding: 1rem;
  background-color: #fee2e2;
  color: #991b1b;
  border-radius: 4px;
  border-left: 4px solid #ef4444;
}

.loading, .empty {
  text-align: center;
  padding: 3rem;
  font-size: 1.2rem;
  color: #6c757d;
}

.projects-list {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.project-item {
  background: white;
  padding: 1.5rem;
  border-radius: 12px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 1rem;
}

.project-info {
  flex: 1;
}

.project-info h3 {
  margin: 0 0 0.5rem 0;
  color: #667eea;
  font-size: 1.3rem;
}

.project-info p {
  margin: 0 0 0.75rem 0;
  color: #6c757d;
}

.project-meta {
  display: flex;
  gap: 1rem;
  align-items: center;
  flex-wrap: wrap;
}

.badge {
  padding: 0.25rem 0.75rem;
  border-radius: 12px;
  font-size: 0.85rem;
  font-weight: 600;
}

.badge-success {
  background: #d4edda;
  color: #155724;
}

.badge-warning {
  background: #fff3cd;
  color: #856404;
}

.badge-info {
  background: #d1ecf1;
  color: #0c5460;
}

.file-name {
  font-size: 0.9rem;
  color: #6c757d;
}

.project-actions {
  display: flex;
  gap: 0.5rem;
}

.btn {
  padding: 0.75rem 1.5rem;
  border: none;
  border-radius: 8px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s;
  text-decoration: none;
  display: inline-block;
}

.btn-sm {
  padding: 0.5rem 1rem;
  font-size: 0.9rem;
}

.btn-primary {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
}

.btn-primary:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
}

.btn-secondary {
  background: #6c757d;
  color: white;
}

.btn-secondary:hover {
  background: #5a6268;
}

.btn-danger {
  background: #dc3545;
  color: white;
}

.btn-danger:hover {
  background: #c82333;
}

.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  padding: 1rem;
}

.modal-content {
  background: white;
  border-radius: 12px;
  max-width: 600px;
  width: 100%;
  max-height: 90vh;
  overflow-y: auto;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1.5rem;
  border-bottom: 1px solid #e9ecef;
}

.modal-header h2 {
  margin: 0;
  color: #667eea;
}

.close-btn {
  background: none;
  border: none;
  font-size: 2rem;
  cursor: pointer;
  color: #6c757d;
  line-height: 1;
}

.project-form {
  padding: 1.5rem;
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

.form-hint {
  font-size: 0.875rem;
  color: #6b7280;
  margin-bottom: 0.75rem;
  line-height: 1.5;
  font-style: italic;
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

textarea.form-control {
  resize: vertical;
}

.checkbox-group label {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  cursor: pointer;
}

.checkbox-group input[type="checkbox"] {
  width: auto;
  cursor: pointer;
}

.form-actions {
  display: flex;
  gap: 1rem;
  justify-content: flex-end;
  margin-top: 2rem;
}

.error-message {
  background: #f8d7da;
  color: #721c24;
  padding: 1rem;
  border-radius: 8px;
  margin-bottom: 1.5rem;
}

@media (max-width: 768px) {
  .admin-header {
    flex-direction: column;
    align-items: stretch;
  }

  .project-item {
    flex-direction: column;
    align-items: stretch;
  }

  .project-actions {
    justify-content: stretch;
  }

  .project-actions .btn {
    flex: 1;
  }
}
</style>

