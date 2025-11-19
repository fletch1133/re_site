<script setup lang="ts">
import { onMounted, computed } from 'vue'
import { useProjectsStore, type Project } from '../stores/projects'

const projectsStore = useProjectsStore()

onMounted(() => {
  projectsStore.fetchProjects()
})

const singleFamilyProjects = computed(() =>
  projectsStore.projects.filter((p: Project) => p.category === 'single_family')
)

const multiFamilyCommercialProjects = computed(() =>
  projectsStore.projects.filter((p: Project) => p.category === 'multi_family_commercial')
)

const landEntitlementsProjects = computed(() =>
  projectsStore.projects.filter((p: Project) => p.category === 'land_entitlements')
)

const getCategoryTitle = (category: string) => {
  switch (category) {
    case 'single_family':
      return 'Single Family'
    case 'multi_family_commercial':
      return 'Multi-Family/Commercial'
    case 'land_entitlements':
      return 'Land Entitlements'
    default:
      return category
  }
}

const getCategoryDescription = (category: string) => {
  switch (category) {
    case 'single_family':
      return 'Residential single-family home developments'
    case 'multi_family_commercial':
      return 'Multi-family residential and commercial property developments'
    case 'land_entitlements':
      return 'Land acquisition, zoning, and entitlement projects'
    default:
      return ''
  }
}
</script>

<template>
  <div class="projects">
    <section class="page-header">
      <div class="container">
        <h1 class="page-title">Project Portfolio</h1>
        <p class="page-subtitle">Comprehensive documentation of completed real estate developments</p>
      </div>
    </section>

    <section class="projects-section">
      <div class="container">
        <div v-if="projectsStore.loading" class="loading">
          <div class="spinner"></div>
          <p>Loading projects...</p>
        </div>

        <div v-else-if="projectsStore.error" class="error">
          <p>{{ projectsStore.error }}</p>
        </div>

        <div v-else-if="projectsStore.projects.length === 0" class="empty">
          <p>No projects available at the moment.</p>
          <p class="empty-subtitle">Check back soon for updates.</p>
        </div>

        <div v-else class="categories-container">
          <!-- Single Family Section -->
          <div v-if="singleFamilyProjects.length > 0" class="category-section">
            <div class="category-header">
              <h2 class="category-title">{{ getCategoryTitle('single_family') }}</h2>
              <p class="category-description">{{ getCategoryDescription('single_family') }}</p>
            </div>
            <div class="projects-grid">
              <div v-for="project in singleFamilyProjects" :key="project.id" class="project-card">
                <a
                  :href="projectsStore.getPdfUrl(project.pdf_path)"
                  target="_blank"
                  class="pdf-preview-link"
                >
                  <div class="pdf-preview">
                    <iframe
                      :src="projectsStore.getPdfUrl(project.pdf_path) + '#toolbar=0&navpanes=0&scrollbar=0'"
                      class="pdf-iframe"
                      :title="project.title"
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
                        <span class="overlay-text">View Full Document</span>
                        <span class="overlay-subtext">Click to open PDF</span>
                      </div>
                    </div>
                  </div>
                </a>
                <div class="project-content">
                  <h3 class="project-title">{{ project.title }}</h3>
                  <p v-if="project.description" class="project-description">{{ project.description }}</p>
                  <div class="project-footer">
                    <div class="project-meta">
                      <span class="meta-icon">📄</span>
                      <span class="meta-text">{{ project.pdf_original_name }}</span>
                    </div>
                    <div v-if="project.pdf_size" class="project-size">
                      <span class="size-icon">💾</span>
                      <span class="size-text">{{ (project.pdf_size / 1024 / 1024).toFixed(2) }} MB</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Multi-Family/Commercial Section -->
          <div v-if="multiFamilyCommercialProjects.length > 0" class="category-section">
            <div class="category-header">
              <h2 class="category-title">{{ getCategoryTitle('multi_family_commercial') }}</h2>
              <p class="category-description">{{ getCategoryDescription('multi_family_commercial') }}</p>
            </div>
            <div class="projects-grid">
              <div v-for="project in multiFamilyCommercialProjects" :key="project.id" class="project-card">
                <a
                  :href="projectsStore.getPdfUrl(project.pdf_path)"
                  target="_blank"
                  class="pdf-preview-link"
                >
                  <div class="pdf-preview">
                    <iframe
                      :src="projectsStore.getPdfUrl(project.pdf_path) + '#toolbar=0&navpanes=0&scrollbar=0'"
                      class="pdf-iframe"
                      :title="project.title"
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
                        <span class="overlay-text">View Full Document</span>
                        <span class="overlay-subtext">Click to open PDF</span>
                      </div>
                    </div>
                  </div>
                </a>
                <div class="project-content">
                  <h3 class="project-title">{{ project.title }}</h3>
                  <p v-if="project.description" class="project-description">{{ project.description }}</p>
                  <div class="project-footer">
                    <div class="project-meta">
                      <span class="meta-icon">📄</span>
                      <span class="meta-text">{{ project.pdf_original_name }}</span>
                    </div>
                    <div v-if="project.pdf_size" class="project-size">
                      <span class="size-icon">💾</span>
                      <span class="size-text">{{ (project.pdf_size / 1024 / 1024).toFixed(2) }} MB</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Land Entitlements Section -->
          <div v-if="landEntitlementsProjects.length > 0" class="category-section">
            <div class="category-header">
              <h2 class="category-title">{{ getCategoryTitle('land_entitlements') }}</h2>
              <p class="category-description">{{ getCategoryDescription('land_entitlements') }}</p>
            </div>
            <div class="projects-grid">
              <div v-for="project in landEntitlementsProjects" :key="project.id" class="project-card">
                <a
                  :href="projectsStore.getPdfUrl(project.pdf_path)"
                  target="_blank"
                  class="pdf-preview-link"
                >
                  <div class="pdf-preview">
                    <iframe
                      :src="projectsStore.getPdfUrl(project.pdf_path) + '#toolbar=0&navpanes=0&scrollbar=0'"
                      class="pdf-iframe"
                      :title="project.title"
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
                        <span class="overlay-text">View Full Document</span>
                        <span class="overlay-subtext">Click to open PDF</span>
                      </div>
                    </div>
                  </div>
                </a>
                <div class="project-content">
                  <h3 class="project-title">{{ project.title }}</h3>
                  <p v-if="project.description" class="project-description">{{ project.description }}</p>
                  <div class="project-footer">
                    <div class="project-meta">
                      <span class="meta-icon">📄</span>
                      <span class="meta-text">{{ project.pdf_original_name }}</span>
                    </div>
                    <div v-if="project.pdf_size" class="project-size">
                      <span class="size-icon">💾</span>
                      <span class="size-text">{{ (project.pdf_size / 1024 / 1024).toFixed(2) }} MB</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<style scoped>
.projects {
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

.projects-section {
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

.empty {
  text-align: center;
  padding: 5rem 2rem;
}

.empty p {
  font-size: 1.25rem;
  color: #4a5568;
  margin-bottom: 0.5rem;
}

.empty-subtitle {
  font-size: 1rem;
  color: #9ca3af;
}

.categories-container {
  display: flex;
  flex-direction: column;
  gap: 5rem;
}

.category-section {
  width: 100%;
}

.category-header {
  margin-bottom: 3rem;
  text-align: center;
  padding-bottom: 2rem;
  border-bottom: 3px solid #2c5282;
}

.category-title {
  font-size: 2.5rem;
  font-weight: 700;
  color: #1a1a1a;
  margin-bottom: 0.75rem;
  letter-spacing: -1px;
}

.category-description {
  font-size: 1.125rem;
  color: #4a5568;
  max-width: 700px;
  margin: 0 auto;
  line-height: 1.6;
}

.projects-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(450px, 1fr));
  gap: 3rem;
}

.project-card {
  background: white;
  border-radius: 8px;
  border: 1px solid #e5e7eb;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  display: flex;
  flex-direction: column;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
}

.project-card:hover {
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.12);
  transform: translateY(-8px);
  border-color: #2c5282;
}

.pdf-preview-link {
  display: block;
  text-decoration: none;
  position: relative;
  overflow: hidden;
}

.pdf-preview {
  position: relative;
  width: 100%;
  height: 350px;
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

.project-card:hover .preview-overlay {
  opacity: 1;
}

.overlay-content {
  text-align: center;
  color: white;
  transform: translateY(10px);
  transition: transform 0.4s ease;
}

.project-card:hover .overlay-content {
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

.project-content {
  padding: 2rem;
  display: flex;
  flex-direction: column;
  flex-grow: 1;
}

.project-title {
  font-size: 1.75rem;
  font-weight: 700;
  color: #1a1a1a;
  margin: 0 0 1rem 0;
  letter-spacing: -0.5px;
  line-height: 1.3;
}

.project-description {
  color: #4a5568;
  line-height: 1.8;
  flex-grow: 1;
  font-size: 1rem;
  margin-bottom: 1.5rem;
}

.project-footer {
  padding-top: 1.5rem;
  border-top: 1px solid #e5e7eb;
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 1rem;
}

.project-meta {
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
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.project-size {
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

@media (max-width: 1200px) {
  .container {
    padding: 0 4rem;
  }

  .projects-grid {
    grid-template-columns: repeat(auto-fill, minmax(400px, 1fr));
    gap: 2.5rem;
  }
}

@media (max-width: 1024px) {
  .container {
    padding: 0 3rem;
  }

  .projects-grid {
    grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
    gap: 2rem;
  }

  .page-title {
    font-size: 3rem;
  }

  .page-subtitle {
    font-size: 1.125rem;
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

  .projects-section {
    padding: 3rem 0 4rem;
  }

  .categories-container {
    gap: 3rem;
  }

  .category-header {
    margin-bottom: 2rem;
    padding-bottom: 1.5rem;
  }

  .category-title {
    font-size: 2rem;
  }

  .category-description {
    font-size: 1rem;
  }

  .projects-grid {
    grid-template-columns: 1fr;
    gap: 2rem;
  }

  .pdf-preview {
    height: 300px;
  }

  .project-content {
    padding: 1.5rem;
  }

  .project-title {
    font-size: 1.5rem;
  }

  .project-description {
    font-size: 0.9375rem;
  }

  .project-footer {
    flex-direction: column;
    align-items: flex-start;
    gap: 0.75rem;
  }

  .project-size {
    width: 100%;
    justify-content: center;
  }
}
</style>

