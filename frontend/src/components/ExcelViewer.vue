<script setup lang="ts">
import { ref, onMounted, watch } from 'vue'
import * as XLSX from 'xlsx'
import { useProjectsStore } from '../stores/projects'

const props = defineProps<{
  filePath: string
  fileName?: string
}>()

const projectsStore = useProjectsStore()
const loading = ref(true)
const error = ref<string | null>(null)
const sheets = ref<string[]>([])
const activeSheet = ref<string>('')
const tableData = ref<string[][]>([])

async function loadExcel() {
  loading.value = true
  error.value = null

  try {
    // Use the CORS-enabled API route
    const url = projectsStore.getFileUrlWithCors(props.filePath)
    const response = await fetch(url)
    if (!response.ok) {
      throw new Error('Failed to fetch Excel file')
    }

    const arrayBuffer = await response.arrayBuffer()
    const workbook = XLSX.read(arrayBuffer, { type: 'array' })

    sheets.value = workbook.SheetNames
    const firstSheetName = workbook.SheetNames[0]
    if (!firstSheetName) throw new Error('No sheets found')
    activeSheet.value = firstSheetName

    loadSheet(workbook, activeSheet.value)
  } catch (err: any) {
    error.value = err.message || 'Failed to load Excel file'
    console.error('Error loading Excel:', err)
  } finally {
    loading.value = false
  }
}

function loadSheet(workbook: XLSX.WorkBook, sheetName: string) {
  const worksheet = workbook.Sheets[sheetName]
  if (!worksheet) return
  const data = XLSX.utils.sheet_to_json<string[]>(worksheet, { header: 1, defval: '' })
  tableData.value = data as string[][]
}

async function changeSheet(sheetName: string) {
  activeSheet.value = sheetName
  loading.value = true

  try {
    const url = projectsStore.getFileUrlWithCors(props.filePath)
    const response = await fetch(url)
    const arrayBuffer = await response.arrayBuffer()
    const workbook = XLSX.read(arrayBuffer, { type: 'array' })
    loadSheet(workbook, sheetName)
  } catch (err: any) {
    error.value = err.message
  } finally {
    loading.value = false
  }
}

function downloadFile() {
  // Use the regular storage URL for downloads
  const url = projectsStore.getPdfUrl(props.filePath)
  const link = document.createElement('a')
  link.href = url
  link.download = props.fileName || 'spreadsheet.xlsx'
  link.target = '_blank'
  document.body.appendChild(link)
  link.click()
  document.body.removeChild(link)
}

onMounted(() => {
  loadExcel()
})

watch(() => props.filePath, () => {
  loadExcel()
})
</script>

<template>
  <div class="excel-viewer">
    <div v-if="loading" class="excel-loading">
      <div class="spinner"></div>
      <p>Loading spreadsheet...</p>
    </div>
    
    <div v-else-if="error" class="excel-error">
      <p>{{ error }}</p>
      <button @click="loadExcel" class="retry-btn">Retry</button>
    </div>
    
    <div v-else class="excel-content">
      <!-- Sheet tabs and download button -->
      <div class="excel-toolbar">
        <div class="sheet-tabs">
          <button
            v-for="sheet in sheets"
            :key="sheet"
            :class="['sheet-tab', { active: sheet === activeSheet }]"
            @click="changeSheet(sheet)"
          >
            {{ sheet }}
          </button>
        </div>
        <button class="download-btn" @click="downloadFile">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
            <polyline points="7 10 12 15 17 10"/>
            <line x1="12" y1="15" x2="12" y2="3"/>
          </svg>
          Download
        </button>
      </div>
      
      <!-- Spreadsheet table -->
      <div class="table-container">
        <table class="excel-table">
          <tbody>
            <tr v-for="(row, rowIndex) in tableData" :key="rowIndex" :class="{ 'header-row': rowIndex === 0 }">
              <td v-for="(cell, cellIndex) in row" :key="cellIndex" :class="{ 'header-cell': rowIndex === 0 }">
                {{ cell }}
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<style scoped>
.excel-viewer {
  width: 100%;
  height: 100%;
  min-height: 400px;
  display: flex;
  flex-direction: column;
  background: #fff;
  border-radius: 8px;
  overflow: hidden;
}

.excel-loading,
.excel-error {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 400px;
  gap: 1rem;
}

.spinner {
  width: 40px;
  height: 40px;
  border: 3px solid #e5e7eb;
  border-top-color: #217346;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.retry-btn {
  padding: 0.5rem 1rem;
  background: #217346;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.excel-content {
  display: flex;
  flex-direction: column;
  height: 100%;
}

.excel-toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0.5rem 1rem;
  background: #f3f4f6;
  border-bottom: 1px solid #e5e7eb;
  flex-shrink: 0;
}

.sheet-tabs {
  display: flex;
  gap: 0.25rem;
  overflow-x: auto;
}

.sheet-tab {
  padding: 0.5rem 1rem;
  background: #e5e7eb;
  border: none;
  border-radius: 4px 4px 0 0;
  cursor: pointer;
  font-size: 0.875rem;
  white-space: nowrap;
  transition: all 0.2s;
}

.sheet-tab:hover {
  background: #d1d5db;
}

.sheet-tab.active {
  background: #217346;
  color: white;
}

.download-btn {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.5rem 1rem;
  background: #217346;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 0.875rem;
  transition: all 0.2s;
}

.download-btn:hover {
  background: #1a5c38;
}

.table-container {
  flex: 1;
  overflow: auto;
  padding: 0;
}

.excel-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 0.875rem;
}

.excel-table td {
  padding: 0.5rem 0.75rem;
  border: 1px solid #e5e7eb;
  white-space: nowrap;
  max-width: 300px;
  overflow: hidden;
  text-overflow: ellipsis;
  color: #1f2937 !important;
  background: #fff;
}

.header-row {
  position: sticky;
  top: 0;
  z-index: 1;
}

.header-cell {
  background: #217346 !important;
  color: white;
  font-weight: 600;
}

.excel-table tr:nth-child(even) td:not(.header-cell) {
  background: #f9fafb;
}

.excel-table tr:hover td:not(.header-cell) {
  background: #f0fdf4;
}
</style>

