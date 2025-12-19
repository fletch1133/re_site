<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ProjectController;
use App\Http\Controllers\Api\ResumeController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Storage;

// Test route (no database)
Route::get('/test', function () {
    return response()->json([
        'status' => 'ok',
        'message' => 'API is working!',
        'timestamp' => now()->toIso8601String(),
    ]);
});

// Serve storage files with CORS headers (for Excel preview and PDFs)
Route::get('/files/{path}', function (string $path) {
    $fullPath = storage_path('app/public/' . $path);

    if (!file_exists($fullPath)) {
        // Log for debugging
        \Log::error('File not found: ' . $fullPath);
        return response()->json(['error' => 'File not found', 'path' => $fullPath], 404);
    }

    $mimeType = mime_content_type($fullPath) ?: 'application/octet-stream';

    return response()->file($fullPath, [
        'Access-Control-Allow-Origin' => '*',
        'Content-Type' => $mimeType,
    ]);
})->where('path', '.*');

// Public routes
Route::post('/login', [AuthController::class, 'login']);
Route::get('/projects', [ProjectController::class, 'index']);
Route::get('/projects/{id}', [ProjectController::class, 'show']);
Route::get('/resume', [ResumeController::class, 'show']);

// Protected routes (admin only)
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/me', [AuthController::class, 'me']);

    // Project management
    Route::post('/projects', [ProjectController::class, 'store']);
    Route::post('/projects/{id}', [ProjectController::class, 'update']); // Using POST for file uploads
    Route::delete('/projects/{id}', [ProjectController::class, 'destroy']);

    // Resume management
    Route::post('/resume', [ResumeController::class, 'upload']);
});
