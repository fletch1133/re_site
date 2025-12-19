<script setup lang="ts">
import { ref, onMounted } from 'vue'
import * as XLSX from 'xlsx'
import { useProjectsStore } from '../stores/projects'

const props = defineProps<{
  filePath: string
}>()

const projectsStore = useProjectsStore()
const loading = ref(true)
const error = ref(false)
const previewData = ref<string[][]>([])

async function loadPreview() {
  loading.value = true
  error.value = false

  try {
    // Use the CORS-enabled API route
    const url = projectsStore.getFileUrlWithCors(props.filePath)
    const response = await fetch(url)
    if (!response.ok) throw new Error('Failed to fetch')

    const arrayBuffer = await response.arrayBuffer()
    const workbook = XLSX.read(arrayBuffer, { type: 'array' })
    const sheetName = workbook.SheetNames[0]
    if (!sheetName) throw new Error('No sheets found')
    const firstSheet = workbook.Sheets[sheetName]
    if (!firstSheet) throw new Error('Sheet not found')
    const data = XLSX.utils.sheet_to_json<string[]>(firstSheet, { header: 1, defval: '' })

    // Only show first 8 rows for preview
    previewData.value = (data as string[][]).slice(0, 8)
  } catch (err) {
    error.value = true
    console.error('Error loading Excel preview:', err)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  loadPreview()
})
</script>

<template>
  <div class="excel-preview">
    <!-- Loading state -->
    <div v-if="loading" class="preview-loading">
      <div class="mini-spinner"></div>
    </div>
    
    <!-- Error state -->
    <div v-else-if="error" class="preview-error">
      <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="#217346" stroke-width="1.5">
        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
        <polyline points="14 2 14 8 20 8"/>
        <path d="M8 13h2l2 3 2-3h2"/>
        <path d="M8 17h2l2-3 2 3h2"/>
      </svg>
      <span>Excel File</span>
    </div>
    
    <!-- Preview table -->
    <div v-else class="preview-table-wrapper">
      <table class="preview-table">
        <tbody>
          <tr v-for="(row, rowIndex) in previewData" :key="rowIndex">
            <td v-for="(cell, cellIndex) in row.slice(0, 5)" :key="cellIndex" :class="{ 'header-cell': rowIndex === 0 }">
              {{ cell }}
            </td>
          </tr>
        </tbody>
      </table>
      <div class="preview-fade"></div>
    </div>
  </div>
</template>

<style scoped>
.excel-preview {
  width: 100%;
  height: 100%;
  background: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
}

.preview-loading {
  display: flex;
  align-items: center;
  justify-content: center;
}

.mini-spinner {
  width: 30px;
  height: 30px;
  border: 3px solid #e5e7eb;
  border-top-color: #217346;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.preview-error {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
  color: #217346;
  font-size: 0.875rem;
}

.preview-table-wrapper {
  width: 100%;
  height: 100%;
  overflow: hidden;
  position: relative;
}

.preview-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 0.65rem;
  table-layout: fixed;
}

.preview-table td {
  padding: 0.25rem 0.35rem;
  border: 1px solid #e5e7eb;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 80px;
  color: #1f2937 !important;
  background: #fff;
}

.header-cell {
  background: #217346;
  color: white;
  font-weight: 600;
}

.preview-table tr:nth-child(even) td:not(.header-cell) {
  background: #f9fafb;
}

.preview-fade {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 40px;
  background: linear-gradient(transparent, white);
  pointer-events: none;
}
</style>

