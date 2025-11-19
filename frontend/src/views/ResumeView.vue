<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import api from '../services/api'

interface Resume {
  id: number
  pdf_path: string
  pdf_original_name: string
  pdf_size: number | null
  created_at: string
  updated_at: string
}

const resume = ref<Resume | null>(null)
const loading = ref(true)
const error = ref('')
const showFullscreen = ref(false)

const getPdfUrl = (path: string) => {
  return `http://localhost:8000/storage/${path}`
}

async function fetchResume() {
  loading.value = true
  error.value = ''
  try {
    const response = await api.get('/resume')
    resume.value = response.data
  } catch (err: any) {
    if (err.response?.status === 404) {
      error.value = 'No resume available at this time.'
    } else {
      error.value = 'Failed to load resume. Please try again later.'
    }
  } finally {
    loading.value = false
  }
}

function openFullscreen() {
  showFullscreen.value = true
  document.body.style.overflow = 'hidden'
  // Add event listener for ESC key
  document.addEventListener('keydown', handleEscKey)
}

function closeFullscreen() {
  showFullscreen.value = false
  document.body.style.overflow = ''
  // Remove event listener
  document.removeEventListener('keydown', handleEscKey)
}

function handleEscKey(event: KeyboardEvent) {
  if (event.key === 'Escape' && showFullscreen.value) {
    closeFullscreen()
  }
}

onMounted(() => {
  fetchResume()
})

onUnmounted(() => {
  // Cleanup: ensure body scroll is restored and event listener is removed
  document.body.style.overflow = ''
  document.removeEventListener('keydown', handleEscKey)
})
</script>

<template>
  <div class="resume">
    <!-- Page Header -->
    <section class="page-header">
      <div class="container">
        <h1 class="page-title">Professional Resume</h1>
        <p class="page-subtitle">View and download my current professional resume</p>
      </div>
    </section>

    <!-- Resume Content -->
    <section class="resume-section">
      <div class="container">
        <div v-if="loading" class="loading">
          <div class="spinner"></div>
          <p>Loading resume...</p>
        </div>

        <div v-else-if="error" class="error">
          <p>{{ error }}</p>
        </div>

        <div v-else-if="resume" class="resume-card-wrapper">
          <div class="resume-card" @click="openFullscreen">
            <div class="pdf-preview">
              <iframe
                :src="getPdfUrl(resume.pdf_path) + '#toolbar=0&navpanes=0&scrollbar=0'"
                class="pdf-iframe"
                title="Resume Preview"
                scrolling="no"
              ></iframe>
              <div class="preview-overlay">
                <div class="overlay-content">
                  <div class="overlay-icon">
                    <svg width="56" height="56" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
                      <polyline points="14 2 14 8 20 8"/>
                      <line x1="16" y1="13" x2="8" y2="13"/>
                      <line x1="16" y1="17" x2="8" y2="17"/>
                      <polyline points="10 9 9 9 8 9"/>
                    </svg>
                  </div>
                  <span class="overlay-text">View Full Resume</span>
                  <span class="overlay-subtext">Click to open viewer</span>
                </div>
              </div>
            </div>
            <div class="resume-content">
              <h3 class="resume-title">{{ resume.pdf_original_name }}</h3>
              <p class="resume-description">Click to view the full resume with download options</p>
              <div class="resume-footer">
                <div class="resume-meta">
                  <span class="meta-icon">📄</span>
                  <span class="meta-text">PDF Document</span>
                </div>
                <div v-if="resume.pdf_size" class="resume-size">
                  <span class="size-icon">💾</span>
                  <span class="size-text">{{ (resume.pdf_size / 1024 / 1024).toFixed(2) }} MB</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Fullscreen Modal -->
    <div v-if="showFullscreen && resume" class="fullscreen-modal" @click.self="closeFullscreen">
      <div class="modal-viewer">
        <div class="viewer-toolbar">
          <div class="toolbar-left">
            <span class="doc-name">{{ resume.pdf_original_name }}</span>
            <span v-if="resume.pdf_size" class="doc-size">
              {{ (resume.pdf_size / 1024 / 1024).toFixed(2) }} MB
            </span>
          </div>
          <div class="toolbar-right">
            <a
              :href="getPdfUrl(resume.pdf_path)"
              download
              class="btn-download"
              @click.stop
            >
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
                <polyline points="7 10 12 15 17 10"/>
                <line x1="12" y1="15" x2="12" y2="3"/>
              </svg>
              DOWNLOAD
            </a>
            <a
              :href="getPdfUrl(resume.pdf_path)"
              target="_blank"
              class="btn-newtab"
              @click.stop
            >
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"/>
                <polyline points="15 3 21 3 21 9"/>
                <line x1="10" y1="14" x2="21" y2="3"/>
              </svg>
              NEW TAB
            </a>
            <button @click="closeFullscreen" class="btn-close" title="Close (ESC)">
              <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <line x1="18" y1="6" x2="6" y2="18"/>
                <line x1="6" y1="6" x2="18" y2="18"/>
              </svg>
              <span class="close-text">CLOSE</span>
            </button>
          </div>
        </div>

        <div class="document-container">
          <iframe
            :src="getPdfUrl(resume.pdf_path)"
            class="document-iframe"
            title="Resume Document"
          ></iframe>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.resume {
  width: 100%;
  background: linear-gradient(to bottom, #ffffff 0%, #f8fafc 100%);
  min-height: calc(100vh - 80px);
}

.container {
  max-width: 100%;
  margin: 0 auto;
  padding: 0 6rem;
}

.page-header {
  background: linear-gradient(135deg, #1a1a1a 0%, #2d3748 100%);
  padding: 5rem 0;
  position: relative;
  overflow: hidden;
}

.page-header::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(135deg, rgba(44, 82, 130, 0.1) 0%, rgba(26, 26, 26, 0.2) 100%);
  pointer-events: none;
}

.page-title {
  font-size: 3.5rem;
  font-weight: 700;
  margin-bottom: 1.25rem;
  color: #ffffff;
  letter-spacing: -1.5px;
  text-align: center;
  position: relative;
  z-index: 1;
}

.page-subtitle {
  font-size: 1.25rem;
  color: rgba(255, 255, 255, 0.9);
  text-align: center;
  max-width: 700px;
  margin: 0 auto;
  line-height: 1.6;
  position: relative;
  z-index: 1;
}

.resume-section {
  padding: 5rem 0 6rem;
}

.loading {
  text-align: center;
  padding: 5rem 2rem;
}

.spinner {
  width: 50px;
  height: 50px;
  border: 4px solid #e5e7eb;
  border-top-color: #2c5282;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin: 0 auto 1.5rem;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.loading p {
  font-size: 1.125rem;
  color: #4a5568;
}

.error {
  text-align: center;
  padding: 5rem 2rem;
  color: #dc2626;
  font-size: 1.125rem;
}

.resume-card-wrapper {
  display: flex;
  justify-content: center;
  align-items: center;
}

.resume-card {
  background: white;
  border-radius: 8px;
  border: 1px solid #e5e7eb;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  display: flex;
  flex-direction: column;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
  max-width: 600px;
  width: 100%;
  cursor: pointer;
}

.resume-card:hover {
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.12);
  transform: translateY(-8px);
  border-color: #2c5282;
}

.pdf-preview {
  position: relative;
  width: 100%;
  height: 500px;
  background: linear-gradient(135deg, #f8fafc 0%, #e5e7eb 100%);
  overflow: hidden;
}

.pdf-iframe {
  width: 100%;
  height: 100%;
  border: none;
  pointer-events: none;
  transform: scale(1.1);
}

.preview-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(135deg, rgba(44, 82, 130, 0.95) 0%, rgba(26, 26, 26, 0.95) 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity 0.4s ease;
}

.resume-card:hover .preview-overlay {
  opacity: 1;
}

.overlay-content {
  text-align: center;
  color: white;
  transform: translateY(10px);
  transition: transform 0.4s ease;
}

.resume-card:hover .overlay-content {
  transform: translateY(0);
}

.overlay-icon {
  margin-bottom: 1rem;
}

.overlay-icon svg {
  filter: drop-shadow(0 2px 8px rgba(0, 0, 0, 0.3));
}

.overlay-text {
  display: block;
  font-size: 1.25rem;
  font-weight: 600;
  letter-spacing: 0.5px;
  margin-bottom: 0.5rem;
}

.overlay-subtext {
  display: block;
  font-size: 0.875rem;
  opacity: 0.9;
  letter-spacing: 0.3px;
}

.resume-content {
  padding: 2rem;
  display: flex;
  flex-direction: column;
}

.resume-title {
  font-size: 1.75rem;
  font-weight: 700;
  color: #1a1a1a;
  margin: 0 0 1rem 0;
  letter-spacing: -0.5px;
  line-height: 1.3;
}

.resume-description {
  color: #4a5568;
  line-height: 1.8;
  font-size: 1rem;
  margin-bottom: 1.5rem;
}

.resume-footer {
  padding-top: 1.5rem;
  border-top: 1px solid #e5e7eb;
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 1rem;
}

.resume-meta {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  flex: 1;
}

.meta-icon {
  font-size: 1.25rem;
}

.meta-text {
  font-size: 0.875rem;
  color: #6b7280;
  font-weight: 500;
}

.resume-size {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.5rem 1rem;
  background-color: #f7fafc;
  border-radius: 6px;
}

.size-icon {
  font-size: 1rem;
}

.size-text {
  font-size: 0.875rem;
  color: #2c5282;
  font-weight: 600;
}

/* Fullscreen Modal */
.fullscreen-modal {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.9);
  z-index: 9999;
  display: flex;
  align-items: center;
  justify-content: center;
  animation: fadeIn 0.3s ease;
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

.modal-viewer {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  background-color: #2b2b2b;
}

.viewer-toolbar {
  background-color: #1a1a1a;
  padding: 1rem 2rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-bottom: 1px solid #404040;
  flex-shrink: 0;
}

.toolbar-left {
  display: flex;
  align-items: center;
  gap: 1.5rem;
}

.toolbar-right {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.doc-name {
  color: white;
  font-weight: 600;
  font-size: 0.9375rem;
}

.doc-size {
  color: #9ca3af;
  font-size: 0.875rem;
}

.btn-download,
.btn-newtab {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.625rem 1.25rem;
  background-color: #2c5282;
  color: white;
  text-decoration: none;
  border-radius: 4px;
  font-weight: 600;
  font-size: 0.875rem;
  letter-spacing: 0.5px;
  transition: all 0.3s ease;
  border: none;
  cursor: pointer;
}

.btn-download:hover,
.btn-newtab:hover {
  background-color: #2a4365;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(44, 82, 130, 0.4);
}

.btn-close {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  padding: 0.625rem 1.25rem;
  background-color: transparent;
  color: white;
  border: 2px solid #404040;
  border-radius: 4px;
  cursor: pointer;
  transition: all 0.3s ease;
  font-weight: 600;
  font-size: 0.875rem;
  letter-spacing: 0.5px;
}

.close-text {
  display: inline;
}

.btn-close:hover {
  background-color: #dc2626;
  border-color: #dc2626;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(220, 38, 38, 0.4);
}

.document-container {
  flex: 1;
  width: 100%;
  background-color: #525659;
  overflow: hidden;
}

.document-iframe {
  width: 100%;
  height: 100%;
  border: none;
  display: block;
}

/* Responsive Design */
@media (max-width: 1200px) {
  .container {
    padding: 0 4rem;
  }
}

@media (max-width: 1024px) {
  .container {
    padding: 0 3rem;
  }

  .page-title {
    font-size: 3rem;
  }

  .page-subtitle {
    font-size: 1.125rem;
  }

  .resume-card {
    max-width: 500px;
  }

  .pdf-preview {
    height: 450px;
  }
}

@media (max-width: 768px) {
  .container {
    padding: 0 2rem;
  }

  .page-header {
    padding: 4rem 0;
  }

  .page-title {
    font-size: 2.5rem;
  }

  .page-subtitle {
    font-size: 1rem;
  }

  .resume-section {
    padding: 3rem 0 4rem;
  }

  .resume-card {
    max-width: 100%;
  }

  .pdf-preview {
    height: 400px;
  }

  .resume-content {
    padding: 1.5rem;
  }

  .resume-title {
    font-size: 1.5rem;
  }

  .resume-description {
    font-size: 0.9375rem;
  }

  .resume-footer {
    flex-direction: column;
    align-items: flex-start;
    gap: 0.75rem;
  }

  .resume-size {
    width: 100%;
    justify-content: center;
  }

  .viewer-toolbar {
    padding: 0.75rem 1rem;
    flex-direction: column;
    gap: 1rem;
    align-items: flex-start;
  }

  .toolbar-left {
    flex-direction: column;
    gap: 0.5rem;
    align-items: flex-start;
    width: 100%;
  }

  .toolbar-right {
    width: 100%;
    flex-wrap: wrap;
  }

  .btn-download,
  .btn-newtab {
    flex: 1;
    justify-content: center;
  }

  .btn-close {
    width: 100%;
    justify-content: center;
  }

  .close-text {
    display: inline;
  }
}
</style>


